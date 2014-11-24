require 'rails_helper'

RSpec.describe ChannelReward do
  before(:each) { @new_channel_reward = ChannelReward.new }
  
  it "has no initial channel" do
    expect(@new_channel_reward.channel).to eq(nil)
  end

  it "has no initial reward" do
    expect(@new_channel_reward.reward).to eq(nil)
  end

  it "cannot save without channel" do
    @new_channel_reward.channel = "SOME_CHANNEL"
    @new_channel_reward.reward = ""
    expect(@new_channel_reward.save).to eq(false)
  end

  it "cannot save without reward" do
    @new_channel_reward.channel = ""
    @new_channel_reward.reward = "SOME_REWARD"
    expect(@new_channel_reward.save).to eq(false)
  end

  it "can save with channel and reward" do
    @new_channel_reward.channel = "SOME_CHANNEL"
    @new_channel_reward.reward = "SOME_REWARD"
    expect(@new_channel_reward.save).to eq(true)
  end
  
  it "does not appear in rewards_search if none reward" do
    all_channels = ['MOVIES','SPORTS','KIDS','MUSIC','NEWS']
    reward_search_channels = ChannelReward.reward_search(all_channels)
    all_channels_count = ChannelReward.all.count
    no_reward_channels_count = ChannelReward.where(reward: 'NONE').count
  
    expect(reward_search_channels.count).to eq(all_channels_count - no_reward_channels_count)    
    reward_search_channels.each do |channel_reward|
      expect(channel_reward.reward).not_to eq('NONE')
    end
  end

end