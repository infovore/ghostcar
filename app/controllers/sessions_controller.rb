class SessionsController < ApplicationController
  def new
    return redirect_to user_path(current_gc_user) if current_user
    client = GhostClient.oauth_client

    @authorize_url = client.auth_code.authorize_url(:redirect_uri => callback_session_url)
  end

  def callback
    code = params[:code]
    if !current_gc_user
      @access_token = client.auth_code.get_token(code, :redirect_uri => callback_session_url)

      session[:access_token] = @access_token.token

      @user = User.find_or_create_by_access_token(@access_token.token)
      u = current_user
      if @user.foursquare_id.blank?
        @user.update_attributes(:firstname => u.firstName,
                                :lastname => u.lastName,
                                :foursquare_id => u.id,
                                :photo_prefix => u.photo.prefix,
                                :photo_suffix => u.photo.suffix)

        @user.update_attributes(:firstname => u.first_name,
                                :lastname => u.last_name,
                                :foursquare_id => u.id,
                                :picture_url=> u.photo)
      end 
    else
      # we're authenticating the second account
      @user = current_gc_user

      @secondary_access_token = foursquare.access_token(code, callback_session_url)
      @user.secondary_access_token = @secondary_access_token.token

      secondary_foursquare= GhostClient.foursquare_client(@secondary_access_token.token)
      @secondary_user = secondary_foursquare.user("self")
      
      @user.secondary_foursquare_id = @secondary_user.id

      @user.save

      # now ingest for that new user
      Checkin.ingest_latest_checkins_for_user(@user)
      @user.reload
    
      flash[:success] = "Welcome to Ghostcar! #{@user.checkins.size} checkins imported."
    end
    redirect_to pages_path
  end


  def logout
    session[:access_token] = nil
    redirect_to "/"
  end
end
