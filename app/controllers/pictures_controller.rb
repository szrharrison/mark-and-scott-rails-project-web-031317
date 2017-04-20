class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update, :destroy]
  before_action :set_categories, only: [:new, :edit]
  before_action :restrict_to_users, except: [:index, :show]
  before_action :following_picture_owner?, only: [:show]

  def new
    @picture = Picture.new
  end

  def create
    @picture = Picture.new( picture_params )

    @picture.user = current_user
    if @picture.save
      @picture.tagorize_improved
      redirect_to picture_path( @picture )
    else
      redirect_to :new, notice: @picture.errors.full_messages
    end
  end

  def index
    @pictures = Picture.all
  end

  def update
    if @picture.update( picture_params )
      @picture.tagorize
      redirect_to picture_path( @picture )
    else
      redirect_to :edit, notice: @picture.errors.full_messages
    end
  end

  def destroy
    @picture.destroy
    redirect_to user_path( current_user ), notice: "Successfully deleted #{@picture.name}"
  end

  private

  def set_picture
    @picture = Picture.find( params[:id] )
  end

  def set_categories
    @categories = Category.all
  end

  def picture_params
    params_hash = params.require( :picture ).permit( :image, :name )
    params_hash[:category_ids] = params.require( :picture ).require( :category_ids )
    params_hash
  end

  def following_picture_owner?
    @following = current_user.leaders.include?( @picture.user )
  end
end
