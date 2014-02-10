class User < ActiveRecord::Base
  acts_as_authentic
  has_many :addresses
  has_many :followers
  has_many :tweets
  has_many :re_tweets
  attr_accessor :old_password, :change_password
  validate :verify_old_password, :on => :update, :if => :change_password

  def verify_old_password
    unless old_password && valid_password?(old_password)
      errors.add(:old_password, "is incorrect")
    end
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    UserMailer.deliver_password_reset_instructions(self).deliver
  end

  def get_retweed_list
    @list_retweets = Array.new
    retweets=self.re_tweets

    if !retweets.blank?
      retweets.each do |retweet|
        @list_retweets.push(retweet.tweet)
      end
    end
    @list_retweets
  end


end