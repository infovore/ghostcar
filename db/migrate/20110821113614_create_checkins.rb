class CreateCheckins < ActiveRecord::Migration
  def self.up
    create_table :checkins do |t|
      t.string :user_id
      t.string :checkin_id
      t.string :shout
      t.string :timestamp
      t.string :venue_id
      t.string :timezone
      t.string :venue_name
      t.timestamps
    end
  end

  def self.down
    drop_table :checkins
  end
end
