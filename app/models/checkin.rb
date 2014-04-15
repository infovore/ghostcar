class Checkin < ActiveRecord::Base
  belongs_to :user

  scope :reposted, :conditions => {:reposted => true}

  def self.ingest_all_checkins_for_user(user)
    checkin_data = user.all_foursq_checkins
    checkin_data.each do |raw_checkin|
      create_for_user_from_mashie(user, raw_checkin)
    end
  end
  
  def self.ingest_latest_checkins_for_user(user)
    if user.checkins.any?
      latest_timestamp = user.checkins.last.timestamp
      # we add 1 to ignore the record we derived this from.
      latest_timestamp = latest_timestamp.to_i + 1

      checkin_data = user.all_foursq_checkins_since(latest_timestamp)
      checkin_data.each do |raw_checkin|
        create_for_user_from_mashie(user, raw_checkin)
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
    secondary_foursquare = GhostClient.foursquare_client(user.secondary_access_token)
      
    secondary_foursquare.add_checkin(:venueId => venue_id, :shout => shout)
    
    update_attribute(:reposted, true)
    # puts "Reposting a checkin to #{venue_name} (#{shout}) for #{user.name}"
  end

  private

  # TODO: use mashie here.
  #
  def self.create_for_user_from_mashie(user,mashie, initial=false)
    unless user.checkins.where(:checkin_id => mashie.id).any?
      if mashie.venue
        # TODO: we need to model Venues, maybe? Certainly extract latlong for
        # venues from the JSON.
        venue_id = mashie.venue.id
        venue_name = mashie.venue.name
      else
        # TODO: what sort of checkins don't have location?
        venue_id, venue_name = nil,nil
      end

      user.checkins.create(:checkin_id => mashie.id,
                           :timezone_offset => mashie.timeZoneOffset,
                           :timestamp => mashie.createdAt,
                           :shout => mashie.shout,
                           :venue_id => venue_id,
                           :venue_name => venue_name)
    end
  end
end
