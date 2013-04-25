class MasterKeyword < ActiveRecord::Base
  attr_accessible :keyword, :goal_advice_id, :category

  belongs_to :goal_advice
  
end
