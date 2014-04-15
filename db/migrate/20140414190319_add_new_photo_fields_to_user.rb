class AddNewPhotoFieldsToUser < ActiveRecord::Migration
  def up
    add_column :users, :photo_prefix, :string
    add_column :users, :photo_suffix, :string
    remove_column :users, :picture_url
  end

  def down
    remove_column :users, :photo_prefix
    remove_column :users, :photo_suffix
    add_column :users, :picture_url, :string
  end
end
