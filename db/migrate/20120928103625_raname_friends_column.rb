class RanameFriendsColumn < ActiveRecord::Migration
  def up
    rename_column :user_preferences, :friend_on_sidekick, :friends_on_sidekick
  end

  def down
  end
end
