class UserLinkedWith < ActiveRecord::Base
  # attr_accessible :title, :body
  belongs_to :user
  belongs_to :social_media
end
