class UsersController < ApplicationController
  before_filter :scope_to_user, :except => :index

  private

  def scope_to_user
    @user = User.find(params[:id])
  end
end
