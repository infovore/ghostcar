class SessionsController < ApplicationController
  def new
    return redirect_to user_path(current_gc_user) if current_user
    @authorize_url = foursquare.authorize_url(callback_session_url)
  end

  def callback
    code = params[:code]
    if !current_gc_user
      @access_token = foursquare.access_token(code, callback_session_url)
      session[:access_token] = @access_token

      @user = User.find_or_create_by_access_token(@access_token)
      u = current_user
      if @user.foursquare_id.blank?
        @user.update_attributes(:firstname => u.first_name,
                                :lastname => u.last_name,
                                :foursquare_id => u.id,
                                :picture_url=> u.photo)
      end 
    else
      # we're authenticating the second account
      @user = current_gc_user

      @secondary_access_token = foursquare.access_token(code, callback_session_url)
      @user.secondary_access_token = @secondary_access_token

      secondary_foursquare= Foursquare::Base.new(@secondary_access_token)
      @secondary_user = secondary_foursquare.users.find("self")
      
      @user.secondary_foursquare_id = @secondary_user.id

      @user.save
    end
    redirect_to pages_path
  end


  def logout
    session[:access_token] = nil
    redirect_to "/"
  end
end
