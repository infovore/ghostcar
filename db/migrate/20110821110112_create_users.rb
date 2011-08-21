class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :access_token
      t.string :firstname
      t.string :lastname
      t.string :picture_url
      t.string :foursquare_id
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end
