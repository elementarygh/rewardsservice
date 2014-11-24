class CreateChannelRewards < ActiveRecord::Migration
  def change
    create_table :channel_rewards do |t|
      t.string :channel
      t.string :reward

      t.timestamps
    end
  end
end
