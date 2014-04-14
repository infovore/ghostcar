class PagesController < ApplicationController
  def index
    client = GhostClient.oauth_client

    @authorize_url = client.auth_code.authorize_url(:redirect_uri => callback_session_url)

    if current_gc_user
      t = Time.now - 1.year
      @last_year = current_gc_user.next_checkin_after(t)
      if params[:show] == "all"
        @show_all = true
        @checkins = Checkin.where(:user_id => current_gc_user.id).page(params[:page])
      else
        @checkins = current_gc_user.latest_checkins
      end
      
    end
  end
end
