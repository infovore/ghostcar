class MakeTimestampAnInt < ActiveRecord::Migration
  def self.up
    change_column :checkins, :timestamp, :bigint
  end

  def self.down
    change_column :checkins, :timestamp, :string
  end
end
