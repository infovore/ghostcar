class AddNewPhotoFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :photo_prefix, :string
    add_column :users, :photo_suffix, :string
    remove_column :users, :picture_url
  end
end
