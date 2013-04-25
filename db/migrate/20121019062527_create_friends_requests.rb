class CreateFriendsRequests < ActiveRecord::Migration
  def change
    create_table :friends_requests do |t|
      t.string :friend_request_id
      t.integer :friend_from_id
      t.integer :friend_to_id
      t.string :friend_from_message
      t.string :friend_request_status
      t.timestamps
    end
  end
end
