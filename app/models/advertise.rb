class Advertise < ActiveRecord::Base
  attr_accessible :first_name, :last_name,:email,:message
  validates :email, :format => {:with => /^(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,6})$/i,
    :message => 'Please enter valid email ID',
    :if => proc { |user| user.email.present? }
  }
  validates :first_name, :last_name,:message, :presence => true
end
