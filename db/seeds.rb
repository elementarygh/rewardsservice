# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
ChannelReward.create(channel: 'SPORTS', reward: 'CHAMPIONS_LEAGUE_FINAL_TICKET')
ChannelReward.create(channel: 'KIDS', reward: 'NONE')
ChannelReward.create(channel: 'MUSIC', reward: 'KARAOKE_PRO_MICROPHONE')
ChannelReward.create(channel: 'NEWS', reward: 'NONE')
ChannelReward.create(channel: 'MOVIES', reward: 'PIRATES_OF_THE_CARIBBEAN_COLLECTION')
