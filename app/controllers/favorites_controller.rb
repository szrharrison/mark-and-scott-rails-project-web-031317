class FavoritesController < ApplicationController
  before_action :restrict_to_users
  before_action :set_user
  before_action :set_picture

  def create
    @favorite = Favorite.new( favorited_by: @user, favorite_picture: @picture )
    @favorite.save
    redirect_to picture_path( @picture )
  end

  def destroy
    @picture_tag.destroy
    @picture = Picture.find( params[:picture_id] )
    redirect_to picture_path( @picture )
  end

  private

  def set_user
    @user = current_user
  end

  def set_picture
    @picture = Picture.find( params[:picture_id] )
  end
end
