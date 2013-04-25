class SocialMedia < ActiveRecord::Base
  attr_accessible :name, :social_media_id

  validates :name, :presence => true, :uniqueness => true

  has_many :user_linked_withs
  has_many :users, :through => :user_linked_withs
end
