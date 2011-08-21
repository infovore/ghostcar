class User < ActiveRecord::Base
  require 'addressable/uri'
  require 'open-uri'

  has_many :checkins, :order => :timestamp

  def name
    "#{firstname} #{lastname}"
  end

  def all_foursq_checkins(options = {})
    checkins_url = "https://api.foursquare.com/v2/users/self/checkins"
    count = 100
    offset = 0
    items = []
    while count == 100
      uri = Addressable::URI.new
      uri.query_values = {:oauth_token => access_token, :limit => count.to_s, :offset => offset.to_s}.merge(options)
      full_path = checkins_url + "?" + uri.query
      raw_json = open(full_path).read
      data = JSON.parse(raw_json)
      actual_data = data["response"]["checkins"]["items"]
      items += actual_data
      count = actual_data.count
      offset = offset + count
    end
    items
  end

  def all_foursq_checkins_since(timestamp)
    all_foursq_checkins("afterTimestamp" => t.to_s)
  end
end