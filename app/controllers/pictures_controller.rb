class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update]
  before_action :restrict_to_users, except: :index

  def new
    @picture = Picture.new
  end

  def create
    @picture = Picture.new( picture_params )
    categories = params.require( :categories )
    categories = categories.split(",")
    categories.map! do |category|
      Category.find_or_create_by( name: category.strip )
    end
    @picture.categories = categories
    @picture.user = current_user
    if @picture.save
      redirect_to picture_path( @picture )
    else
      render :new
    end
  end

  def index
    @pictures = Picture.all
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
    params.require( :picture ).permit( :image_url, :name )
  end
end
