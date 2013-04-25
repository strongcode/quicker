class Category < ActiveRecord::Base
  attr_accessible :photo, :deal_site_category, :major_category, :minor_category, :description

  scope :preference_category, proc {|category| where("major_category like '%#{category}%'").order("photo")}
  scope :matching_category, proc {|minor_category, major_category| where("major_category like '%#{major_category.split(' ')[0]}%' AND minor_category like '%#{minor_category}%'")}

  class << self
    def get_business_category
      category = where("minor_category like 'business%'").first
      category.present? ? (category) : ("")
    end

    def get_lifestyle_category
      category = where("minor_category like 'lifestyle%'").first
      category.present? ? (category) : ("")
    end

    def get_sorted_minor_categories(major_category_string)
      minor_categories = Category.where("major_category like ?", "%#{major_category_string}%").order("description asc")
      duplicate_major_category = minor_categories.detect{|categ| categ.major_category.downcase == categ.minor_category.downcase }
      final_minor_categories = [duplicate_major_category] + (minor_categories - [duplicate_major_category])
      final_minor_categories
    end

    def you_deserve_it_set(user_profile)
      category_1 = where("id = ?", user_profile.you_deserve_it_category).first
      individual_category_set(category_1)
    end

    def user_preference_categories(user_profile)
      category_1 = where("id = ?", user_profile.offer_category_1).first
      category_2 = where("id = ?", user_profile.offer_category_2).first
      category_3 = where("id = ?", user_profile.offer_category_3).first
      get_category_set(category_1, category_2, category_3)
    end

    def user_suggestion_categories(user_profile)
      category_1 = where("id = ?", user_profile.suggestion_category_1).first
      category_2 = where("id = ?", user_profile.suggestion_category_2).first
      category_3 = where("id = ?", user_profile.suggestion_category_3).first
      get_category_set(category_1, category_2, category_3)
    end

    def get_category_set(category_1, category_2, category_3)
      individual_category_set(category_1) + individual_category_set(category_2) + individual_category_set(category_3)
    end

    def individual_category_set(category)
      if category.present?
        if /#{category.major_category}/i.match(category.minor_category)
          where("major_category like ?", category.minor_category).map(&:id)
        else
          [category.id]
        end
      else
        []
      end

    end

  end
end
