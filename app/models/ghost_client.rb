class GhostClient
  def self.oauth_client
    client = OAuth2::Client.new(ENV['FOURSQUARE_CLIENT_ID'], ENV['FOURSQUARE_CLIENT_SECRET'], :site => 'https://foursquare.com', :authorize_url => '/oauth2/authorize', :token_url => '/oauth2/access_token')
  end

  def self.foursquare_client(access_token)
    foursquare_client = Foursquare2::Client.new(:oauth_token => access_token, :api_version => ENV['FOURSQUARE_API_VERSION'])
  end
end
