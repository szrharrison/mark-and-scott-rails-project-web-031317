class UserLeadersController < ApplicationController
  before_action :restrict_to_users

  def create
    @user_leader = UserLeader.find_or_create_by( user_id: session[:user_id], leader_id: params[:leader_id] )
    @leader = @user_leader.leader
    redirect_to user_path( @leader )
  end

  def destroy
    @user_leader = UserLeader.find( params[:id] )
    @user_leader.destroy
    @picture = Picture.find( params[:picture_id] )
    redirect_to picture_path( @picture )
  end
end
