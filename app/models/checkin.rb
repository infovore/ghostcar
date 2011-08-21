class Checkin < ActiveRecord::Base
  belongs_to :user

  def self.ingest_checkins_for_user(user)
    checkin_data = user.all_foursq_checkins
    checkin_data.each do |raw_checkin|
      user.checkins.create(:checkin_id => raw_checkin['id'],
                           :timezone => raw_checkin['timeZone'],
                           :timestamp => raw_checkin['createdAt'],
                           :shout => raw_checkin['shout'],
                           :venue_id => raw_checkin['venue']['id'],
                           :venue_name => raw_checkin['venue']['name'])
    end
  end
end
