class UserQuestion < ActiveRecord::Base
  attr_accessible :question_1, :question_2, :question_3, :question_4, :question_5, :user_id
  belongs_to :user


  class << self
    def image_populate
      all_images = [
        "american_restaurants.gif",
        "adventure.gif",
        "arts.gif",
        "",
        "automotive.gif",
        "baby_stores.gif",
        "bars.gif",
        "",
        "car_rental.gif",
        "",
        "cruises.gif",
        "dance.gif",
        "drycleaning.gif",
        "education.gif",
        "electronics.gif",
        "facial.gif",
        "financial_services.gif",
        "fitness_and_beauty.gif",
        "fitness_training.gif",
        "flights.gif",
        "fast_food.gif",
        "",
        "govt_services.gif",
        "grocery_stores.gif",
        "gym.gif",
        "home_services.gif",
        "hotel.gif",
        "kids_activities.gif",
        "kids_stores.gif",
        "landscaping.gif",
        "legal_services.gif",
        "lifeskills.gif",
        "",
        "massage.gif",
        "mens_clothing.gif",
        "mexican_restaurants.gif",
        "movies.gif",
        "nightlife.gif",
        "",
        "",
        "pet_stores.gif",
        "pharmacies.gif",
        "photography.gif",
        "pilates.gif",
        "professional_services.gif",
        "public_services.gif",
        "real_estate.gif",
        "religious_organizations.gif",
        "shoes.gif",
        "",
        "shows.gif",
        "spa.gif",
        "specialty_stores.gif",
        "sporting_goods.gif",
        "tanning.gif",
        "tattoos_piercings.gif",
        "theater.gif",
        "tours.gif",
        "",
        "",
        "vacation_packages.gif",
        "vacation_rentals.gif",
        "womens_clothing.gif",
        "yoga.gif",
      ]

      categories = Category.all.sort_by {|category| category.minor_category}
      categories.each_with_index do |category, index|
        category.photo = all_images[index]
        category.save
      end
    end
  end


end
