class PagesController < ApplicationController
  def index
    @authorize_url = foursquare.authorize_url(callback_session_url)
  end
end
