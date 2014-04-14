class User < ActiveRecord::Base
  has_many :checkins, :order => :timestamp
  has_many :latest_checkins, :class_name => "Checkin", :order => "timestamp desc", :limit => 10

  def name
    "#{firstname} #{lastname}"
  end

  def photo_url(size_string="small")
    case size_string
    when 'tiny'
      size = "36x36"
    when 'small'
      size = "100x100"
    when 'medium'
      size = "300x300"
    when 'large'
      size = "500x500"
    when 'original'
      size = 'original'
    end
    photo_prefix + size + photo_suffix
  end


  def all_foursq_checkins(args = {})
    foursquare = GhostClient.foursquare_client(access_token)

    checkin_list = []
    per_page = 250
    offset = 0
    continue = true

    while continue
      next_checkins = foursquare.user_checkins({:limit => per_page, :offset => offset}.merge(args))
      
      checkin_list = checkin_list + next_checkins.items

      if next_checkins.items.size < per_page
        continue = false
      end

      offset = offset + per_page
    end

    checkin_list
  end

  def all_foursq_checkins_since(timestamp)
    all_foursq_checkins(:afterTimestamp => timestamp.to_s)
  end

  def next_checkin_after(t)
    checkins.where("timestamp >= #{t.to_i}").first
  end

end
