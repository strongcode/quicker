module Admins
  class ActivitiesController < ApplicationController
    layout 'admin'
    before_filter :authenticate_admin!
  
    def list
      @users = User.all
    end
    
  end
end
