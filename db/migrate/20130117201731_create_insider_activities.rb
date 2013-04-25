class CreateInsiderActivities < ActiveRecord::Migration
  def change
    create_table :insider_activities do |t|
      t.integer   :user_id
      t.integer   :offer_id
      t.string    :activity_type
      t.datetime  :presented
      t.integer   :no_of_times_presented
      t.datetime  :snapped
      t.timestamps
    end
  end
end
