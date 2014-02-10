class AddToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :isadmin, :boolean
  end

  def self.down
    remove_column :users, :isadmin
  end
end
