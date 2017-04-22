class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :restrict_to_users, only: [:edit, :update]
  before_action :authorize_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new( user_params )
    if @user.save
      session[:user_id] = @user.id
      redirect_to user_path( @user )
    else
      redirect_to new_user_path, notice: @user.errors.full_messages
    end
  end

  def update
    if @user.update( user_params )
      redirect_to user_path( @user )
    else
      redirect_to edit_user_path( @user ), notice: @user.errors.full_messages
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
