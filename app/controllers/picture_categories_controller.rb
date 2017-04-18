class PictureCategoriesController < ApplicationController
  before_action :restrict_to_users
  
  def create
    @picture_category = PictureCategory.new( picture_category_params )
    @picture = Picture.find( params.require( :picture_category ).require( :picture_id ) )
    if @picture_category.save
      redirect_to picture_path( @picture )
    else
      render 'pictures/show'
    end
  end

  def destroy
    @picture_category = PictureCategory.find( params[:id] )
    @picture_category.destroy
    @category = Category.find( params.require( :category_id ) )
    @picture = Picture.find( params.require( :picture_id ) )
    redirect_to picture_path( @picture )
  end

  private

  def picture_category_params
    params.require( :picture_category ).permit( :picture_id, :category_id )
  end
end
