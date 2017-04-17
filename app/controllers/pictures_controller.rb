class PicturesController < ApplicationController
  before_action :set_picture, only: [:show, :edit, :update]

  def new
    @picture = Picture.new
  end

  def create
    @picture = Picture.new( picture_params )
    @picture.user = User.first
    if @picture.save
      redirect_to picture_path( @picture )
    else
      render :new
    end
  end

  def index
    @pictures = Picture.all
  end

  private

  def set_picture
    @picture = Picture.find( params[:id] )
  end

  def picture_params
    params.require( :picture ).permit( :image_url )
  end
end
