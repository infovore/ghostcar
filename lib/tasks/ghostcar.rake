namespace :ghostcar do
  desc "Ingest latest checkins for all users"  
  task :ingest_all => :environment do
    users = User.all
    users.each do |user|
      starting_checkin_count = user.checkins.size
      Checkin.ingest_latest_checkins_for_user(user)
      user.reload
      new_checkin_count = user.checkins.size - starting_checkin_count
      puts "#{new_checkin_count} checkins ingested for #{user.name}"
    end
  end

  desc "Re-post any checkins (run once a minute under cron)"
  task :repost_checkins => :environment do
    Checkin.order(:timestamp).where(:reposted => false).each do |checkin|
      if Time.now.utc > checkin.echo_time.utc && checkin.echo_time.utc > Time.now.utc - 2.minutes
        checkin.repost!
        print "."
      end
    end
  end

  desc "Update photo URLs for all users"
  task :update_photo_urls => :environment do
    users = User.all
    users.each do |user|
      next unless user.access_token
      foursquare = GhostClient.foursquare_client(user.access_token)

      fs_user = foursquare.user('self')
      user.photo_prefix = fs_user.photo.prefix
      user.photo_suffix = fs_user.photo.suffix
      user.save
      puts "Updated #{user.name}"
    end
  end

end
