class CreateReTweets < ActiveRecord::Migration
  def self.up
    create_table :re_tweets do |t|
      t.integer :tweet_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :re_tweets
  end
end
