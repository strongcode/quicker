class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
      t.integer :user_id
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.string :description
      t.string :picture
      t.integer :language_id
      t.string :relationship_status
      t.string :locale
      t.string :timezone
      t.string :address
      t.string :street
      t.string :city
      t.string :zip
      t.string :country
      t.datetime :date_of_birth
      t.string :education
      t.string :interests
      t.integer :followers_count
      t.integer :friends_count
      t.integer :user_status_id
      t.datetime :deleted_at
      t.timestamps
    end
  end
end
