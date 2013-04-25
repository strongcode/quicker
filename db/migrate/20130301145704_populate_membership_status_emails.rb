class PopulateMembershipStatusEmails < ActiveRecord::Migration
  def up
    Rake::Task['db:populate_member_emails'].invoke
  end

  def down
  end
end
