class AddRepostedToCheckins < ActiveRecord::Migration
  def self.up
    add_column :checkins, :reposted, :boolean, :default => false
  end

  def self.down
    remove_column :checkins, :reposted
  end
end
