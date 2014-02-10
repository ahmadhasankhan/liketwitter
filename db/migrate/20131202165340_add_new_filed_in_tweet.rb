class AddNewFiledInTweet < ActiveRecord::Migration
  def self.up
    add_column :tweets, :is_private, :boolean
  end

  def self.down
    remove_column :tweets, :is_private
  end
end
