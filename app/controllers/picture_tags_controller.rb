class PictureTagsController < ApplicationController
  before_action :restrict_to_users
  before_action :set_picture_tag, only: [:show, :edit, :update, :destroy]
  def create
    @picture_tag = PictureTag.new( picture_tag_params )
    @picture = Picture.find( params.require( :picture_tag ).require( :picture_id ) )
    if @picture_tag.save
      redirect_to picture_path( @picture )
    else
      render 'pictures/show'
    end
  end

  def destroy
    @picture_tag.destroy
    @picture = Picture.find( params[:picture_id] )
    redirect_to picture_path( @picture )
  end

  private

  def set_picture_tag
    @picture_tag = PictureTag.find( params[:id] )
  end

  def picture_tag_params
    params.require( :picture_tag ).permit( :picture_id, :tag_id )
  end
end
