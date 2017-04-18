class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?, :authorize_user, :restrict_to_users

  private
  def logged_in?
    session[:user_id].present?
  end

  def restrict_to_users
    unless logged_in?
      redirect_to login_path
    end
  end

  def authorize_user
    unless params[:id].to_i == session[:user_id]
      redirect_to pictures_path
    end
  end

  def current_user
    @current_user ||= User.find( session[:user_id] )
  end
end
