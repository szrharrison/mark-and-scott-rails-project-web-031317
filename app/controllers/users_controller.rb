class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :restrict_to_users, only: [:show, :edit, :update]
  before_action :authorize_user, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new( user_params )
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path( @user )
    else
      render :new
    end
  end

  private

  def set_user
    @user = User.find( params[:id] )
  end

  def user_params
    params.require( :user ).permit( :username, :password, :password_confirmation )
  end
end
