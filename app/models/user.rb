class User < ActiveRecord::Base
  require 'addressable/uri'
  require 'open-uri'

  has_many :checkins, :order => :timestamp
  has_many :latest_checkins, :class_name => "Checkin", :order => "timestamp desc", :limit => 10

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
    all_foursq_checkins("afterTimestamp" => timestamp.to_s)
  end

  def next_checkin_after(t)
    checkins.where("timestamp >= #{t.to_i}").first
  end
end
