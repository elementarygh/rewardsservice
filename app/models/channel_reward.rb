class ChannelReward < ActiveRecord::Base
  validates :channel, :reward, presence: true 
  scope :reward_search, ->(channels) { where(channel: channels).where.not(reward: 'NONE') }  
  
end
