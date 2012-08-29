class Checkin < ActiveRecord::Base
  belongs_to :user

  scope :reposted, :conditions => {:reposted => true}

  def self.ingest_all_checkins_for_user(user)
    checkin_data = user.all_foursq_checkins
    checkin_data.each do |raw_checkin|
      create_for_user_from_json(user, raw_checkin)
    end
  end
  
  def self.ingest_latest_checkins_for_user(user)
    if user.checkins.any?
      latest_timestamp = user.checkins.last.timestamp
      # we add 1 to ignore the record we derived this from.
      latest_timestamp = latest_timestamp.to_i + 1

      checkin_data = user.all_foursq_checkins_since(latest_timestamp)
      checkin_data.each do |raw_checkin|
        create_for_user_from_json(user, raw_checkin)
      end
    else
      self.ingest_all_checkins_for_user(user)
    end
  end

  def time
    Time.at(timestamp)
  end

  def echo_time
    Time.at(timestamp) + 1.year
  end

  def venue_url
    "http://foursquare.com/venue/#{venue_id}"
  end

  def repost!
    # send it to foursquare
    RestClient.post 'https://api.foursquare.com/v2/checkins/add',
                    :oauth_token => user.secondary_access_token,
                    :venueId => venue_id,
                    :shout => shout
    update_attribute(:reposted, true)
    # puts "Reposting a checkin to #{venue_name} (#{shout}) for #{user.name}"
  end

  private

  def self.create_for_user_from_json(user,json)
    unless user.checkins.where(:checkin_id => json['id']).any?
      if json['venue']
        venue_id = json['venue']['id']
        venue_name = json['venue']['name']
      else
        venue_id, venue_name = nil,nil
      end

      user.checkins.create(:checkin_id => json['id'],
                           :timezone => json['timeZone'],
                           :timestamp => json['createdAt'],
                           :shout => json['shout'],
                           :venue_id => venue_id,
                           :venue_name => venue_name)
    end
  end
end
