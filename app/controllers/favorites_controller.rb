class FavoritesController < ApplicationController
  before_action :restrict_to_users
  before_action :set_user
  before_action :set_picture, only: :create

  def create
    @favorite = Favorite.new( favorited_by: @user, favorite_picture: @picture )
    @favorite.save
    redirect_to picture_path( @picture )
  end

  def destroy
    @favorite = Favorite.find( params[:id] )
    @favorite.destroy
    redirect_to user_path( @user )
  end

  private

  def set_user
    @user = current_user
  end

  def set_picture
    @picture = Picture.find( params[:picture_id] )
  end
end
