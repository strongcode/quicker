class Language < ActiveRecord::Base
  attr_accessible :description,:spanishname, :language_sid

  validates :description, :language_sid, :presence => true, :uniqueness => true
end
