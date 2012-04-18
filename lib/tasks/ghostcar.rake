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
      end
    end
  end
end