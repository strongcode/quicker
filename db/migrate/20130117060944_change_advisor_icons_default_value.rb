class ChangeAdvisorIconsDefaultValue < ActiveRecord::Migration
  def up
    change_column_default :user_profiles, :insider_icon_img, :default => "insider_male_d6c4c2_ffd8b6"
    change_column_default :user_profiles, :sidekick_icon_img, :default => "sidekick_male_d6c4c2_ffd8b6"
    change_column_default :user_profiles, :assistant_icon_img, :default => "assistant_male_d6c4c2_ffd8b6"
    UserProfile.update_all("insider_icon_img = 'insider_male_d6c4c2_ffd8b6', sidekick_icon_img = 'sidekick_male_d6c4c2_ffd8b6' , assistant_icon_img = 'assistant_male_d6c4c2_ffd8b6'")
  end

  def down
  end
  
end
