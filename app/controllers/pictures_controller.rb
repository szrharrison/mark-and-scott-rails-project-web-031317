class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update]
  before_action :set_categories, only: [:new, :edit]
  before_action :restrict_to_users, except: [:index, :show]

  def new
    @picture = Picture.new
  end

  def create
    @picture = Picture.new( picture_params )

    @picture.user = current_user
    if @picture.save
      #TODO make #categorize
      @picture.tagorize
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
end
