class ChangeColumnRepeatExpericesDefaultValue < ActiveRecord::Migration
  def up
    change_column :user_profiles, :repeat_experiences, :boolean, :default => true
  end

  def down
    change_column :user_profiles, :repeat_experiences, :boolean, :default => nil
  end
end
