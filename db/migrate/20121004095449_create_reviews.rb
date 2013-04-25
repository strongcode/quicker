class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.integer :user_id
      t.integer :location_id
      t.boolean :review_status
      t.integer :review_been_seen
      t.integer :review_approvals
      t.float   :user_quick_star
      t.boolean :allow_personal_offers
      t.text    :review_details
      t.integer :kudos_points
      t.timestamps
    end
  end
end
