class Photo < ActiveRecord::Base
  include KudosPoints
  
  attr_accessible :image, :user_profile_id, :updated_at, :created_at, :image_cache

  mount_uploader :image, PhotoUploader
  mount_uploader :old_image, PhotoUploader

  default_scope order('created_at DESC')

  belongs_to :imageable, :polymorphic => true
  has_one :activity, :as => :activitable

  attr_accessor :kudos_score
  after_initialize :set_kudos_score
  after_create :create_goal_photo_activity

  def set_kudos_score
    @kudos_score = Goal::Kudos_Pts::Upload_Goal_Picture
  end

  def goal_photo_description
    object = eval(self.imageable_type).find_by_id self.imageable_id
    "#{self.imageable_type} Photo - #{object.description}"
  end

  def goal_photo_icon_path
    self.image_url(:standard_image)
  end

  def goal_action
    "Added"
  end

  def get_user_id
    object = eval(self.imageable_type).find_by_id self.imageable_id
    object.user.id
  end

  class << self
    
    def my_passionate_photo(imageable, object, current_user)
      passionate = current_user.passionate.present? && (current_user.passionate.location.id == object.id) ? (current_user.passionate) : (nil)
      where("imageable_type = ? AND imageable_id IN(?) AND image IS NOT NULL", imageable, passionate.present? ? (passionate.id) : (nil))
    end

    def my_suggestion_photo(imageable, object, current_user)
      suggestion = object.suggestions.where("location_id = ? AND user_id = ?", object.id, current_user.id).first
      where("imageable_type = ? AND imageable_id IN(?) AND image is NOT NULL", imageable, suggestion.present? ? ([suggestion.id]) : (nil))
    end
    
    def my_review_photo(imageable, object, current_user)
      review = current_user.reviews.where("location_id = ? ", object.id).first
      review.present? ? (where("imageable_type = ? AND imageable_id = ? AND image IS NOT NULL ", imageable, [review.id])) : (where('id IS NULL AND id IS NOT NULL'))
    end

    def friend_passionate_photo(imageable, object, current_user)
      passionates = Passionate.friends_passionates(object, current_user)
      where("imageable_type = ? AND imageable_id IN(?) AND image IS NOT NULL", imageable, passionates.map(&:id))
    end

    def friend_suggestion_photo(imageable, object, current_user)
      passionates = Suggestion.my_friends_suggestions(object, current_user)
      where("imageable_type = ? AND imageable_id IN(?) AND image IS NOT NULL", imageable, passionates.map(&:id))
    end

    def friend_review_photo(imageable, object, current_user)
      friends_reviews = Review.my_friends_reviews(object, current_user)
      where("imageable_type = ? AND imageable_id IN(?) AND image IS NOT NULL", imageable, friends_reviews.map(&:id))
    end

    def other_passionate_photo(imageable, object, current_user)
      passionates = Passionate.other_passionates(object, current_user)
      where("imageable_type = ? AND imageable_id IN(?) AND image IS NOT NULL", imageable, passionates.map(&:id))
    end

    def other_suggestion_photo(imageable, object, current_user)
      passionates = Suggestion.other_suggestions(object, current_user)
      where("imageable_type = ? AND imageable_id IN(?) AND image IS NOT NULL", imageable, passionates.map(&:id))
    end

    def other_review_photo(imageable, object, current_user)
      other_reviews = Review.other_reviews(object, current_user)
      where("imageable_type = ? AND imageable_id IN(?) AND image IS NOT NULL", imageable, other_reviews.map(&:id))
    end

    

    

  end

end
