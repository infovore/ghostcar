class AddIndexOnUnpostedToCheckins < ActiveRecord::Migration
  def change
    add_index :checkins, :reposted
  end
end
