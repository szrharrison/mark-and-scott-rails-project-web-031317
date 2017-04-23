class PictureCategoriesController < ApplicationController
  before_action :restrict_to_users

  def destroy
    @picture_category = PictureCategory.find( params[:id] )
    @picture_category.destroy
    @picture = Picture.find( params.require( :picture_id ) )
    redirect_to picture_path( @picture )
  end
end
