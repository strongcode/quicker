class ReviewerOfTheDay < ActiveRecord::Base
  attr_accessible :user_id, :zip_code

  class << self
    
    def get_reviewer_of_the_day(zip_code)
      (find_by_zip_code zip_code) || (find_by_zip_code "999")
    end
    
  end

end
