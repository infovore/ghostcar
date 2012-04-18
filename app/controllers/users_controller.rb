class UsersController < ApplicationController
  before_filter :scope_to_user, :except => :index
  before_filter :require_user

  def update_checkins
    current_checkin_count = @user.checkins.size
    Checkin.ingest_latest_checkins_for_user(@user)
    @user.reload
    new_checkin_count = @user.checkins.size - current_checkin_count
    
    flash[:success] = "#{new_checkin_count} checkins imported."
    redirect_to "/"
  end
  private

  def scope_to_user
    @user = User.find(params[:id])
  end
end
