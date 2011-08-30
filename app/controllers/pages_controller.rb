class PagesController < ApplicationController
  def index
    @authorize_url = foursquare.authorize_url(callback_session_url)
    if current_gc_user
      t = Time.now - 1.year
      @last_year = current_gc_user.next_checkin_after(t)
    end
  end
end
