class PictureCategoriesController < ApplicationController

  def create
    @picture_category = PictureCategory.new( picture_category_params )
    if @picture_category.save
      redirect_to picture_category_path( @picture_category )
    else
      @picture = Picture.find( params.require( :picture_category ).require( :picture_id ) )
      render 'pictures/show'
    end
  end

  private

  def picture_category_params
    params.require( :picture_category ).permit( :picture_id, :category_id )
  end
end
