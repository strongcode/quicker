class CreateMembershipStatusEmails < ActiveRecord::Migration
  def change
    create_table :membership_status_emails do |t|
      t.string :email
      t.string :membership_status
      t.timestamps
    end
  end
end
