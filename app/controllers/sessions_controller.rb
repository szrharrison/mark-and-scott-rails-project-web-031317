class SessionsController < ApplicationController

  def create
    @user = User.find_by( params.permit( :username ) )
    if !!@user && @user.authenticate( params.require( :password ) )
      session[:user_id] = @user.id
      redirect_to user_path( @user )
    else
      if !@user
        @user = User.new
        @user.errors[:username] << "not found"
      end
      render :new
    end
  end

  def destroy
    session.clear
    redirect_to root_path
  end
end
