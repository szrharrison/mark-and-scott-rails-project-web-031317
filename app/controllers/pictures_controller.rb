class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update]
  before_action :restrict_to_users, except: [:index, :show]

  def new
    @picture = Picture.new
  end

  def create
    @picture = Picture.new( picture_params )
    @picture.category_list = params.require( :categories )

    @picture.user = current_user
    if @picture.save
      #TODO make #categorize
      @picture.tagorize_improved
      redirect_to picture_path( @picture )
    else
      render :new
    end
  end

  def index
    @pictures = Picture.all
  end

  def edit
    @picture_categories = @picture.categories.map do |category|
      category.name
    end
    @picture_categories = @picture_categories.join(", ")
  end

  def update
    if @picture.update( picture_params )
      redirect_to picture_path( @picture )
    else
      render :edit
    end
  end

  private

  def set_picture
    @picture = Picture.find( params[:id] )
  end

  def picture_params
    params.require( :picture ).permit( :image, :name )
  end
end
