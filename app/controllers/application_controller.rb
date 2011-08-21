class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user
  helper_method :current_gc_user
  
  private
  
  def require_user
    unless current_user
      redirect_to root_path
    end
  end

  def current_gc_user
    return nil if session[:access_token].blank?
    @user = User.find_by_access_token(session[:access_token])
  end

  def current_user
    return nil if session[:access_token].blank?
    begin
      foursquare = Foursquare::Base.new(session[:access_token])
      @current_user ||= foursquare.users.find("self")
    rescue Foursquare::InvalidAuth
      nil
    end
  end
  
  def foursquare
    unless current_user
      @foursquare ||= Foursquare::Base.new(FOURSQUARE_CLIENT_ID, FOURSQUARE_CLIENT_SECRET)
    else
      @foursquare ||= Foursquare::Base.new(session[:access_token])
    end
  end
  
end
