require 'test_helper'

class ChannelRewardTest < ActiveSupport::TestCase
  def test_invalid_without_channel
    channel = ChannelReward.new
    channel.reward = 'KARAOKE_PRO_MICROPHONE'
    assert !channel.valid?
  end

  def test_invalid_without_reward
    channel = ChannelReward.new
    channel.channel = 'MOVIES'
    assert !channel.valid?
  end

  def test_invalid_with_blank_channel
    channel = ChannelReward.new
    channel.channel = ''
    channel.reward = 'KARAOKE_PRO_MICROPHONE'
    assert !channel.valid?
  end

  def test_invalid_with_blank_reward
    channel = ChannelReward.new
    channel.channel = 'MOVIES'
    channel.reward = ''
    assert !channel.valid?
  end

  def test_valid_with_channel_and_reward
    channel = ChannelReward.new
    channel.channel = 'MOVIES'
    channel.reward = 'KARAOKE_PRO_MICROPHONE'
    assert channel.valid?
  end

  def test_reward_search_excludes_none
    channels = ['MOVIES','SPORTS','KIDS','MUSIC','NEWS']
    reward_search_channels = ChannelReward.reward_search(channels)

    reward_search_channels.each do |channel_reward|
      assert channel_reward.reward != 'NONE'
    end
  end

end
