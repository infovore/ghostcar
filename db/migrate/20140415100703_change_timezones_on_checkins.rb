class ChangeTimezonesOnCheckins < ActiveRecord::Migration
  def up
    add_column :checkins, :timezone_offset, :integer
    remove_column :checkins, :timezone
  end

  def down
    remove_column :checkins, :timezone_offset
    add_column :checkins, :timezone, :string
  end
end
