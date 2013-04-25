class RenameColumnFriendRequestStatus < ActiveRecord::Migration
  def change
    rename_column :friends_requests, :friend_request_status, :state
    remove_column :friends_requests, :friend_request_id
  end
end
