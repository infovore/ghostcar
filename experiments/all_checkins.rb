require 'rubygems'
require 'json'
require 'open-uri'
require 'addressable/uri'
require 'openssl'
require 'pp'

module OpenSSL
  module SSL
    remove_const :VERIFY_PEER
  end
end
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

authtoken = File.read("auth_token")

checkins_url = "https://api.foursquare.com/v2/users/self/checkins"

count = 100
offset = 0
items = []
while count == 100
  uri = Addressable::URI.new
  uri.query_values = {:oauth_token => authtoken, :limit => count.to_s, :offset => offset.to_s}
  full_path = checkins_url + "?" + uri.query
  raw_json = open(full_path).read
  data = JSON.parse(raw_json)
  actual_data = data["response"]["checkins"]["items"]
  items += actual_data
  count = actual_data.count
  offset = offset + count
  puts "Count is #{count}, Offsetis #{offset}"
end
puts "#{items.size} items"
