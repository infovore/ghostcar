class AddSecondaryAccessTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :secondary_access_token, :string
    add_column :users, :secondary_foursquare_id, :string
  end

  def self.down
    remove_column :users, :secondary_access_token
    remove_column :users, :secondary_foursquare_id
  end
end
