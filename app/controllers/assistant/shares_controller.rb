module Assistant
  class SharesController < InheritedResources::Base
    InheritedResources.flash_keys = [ :success, :failure ]
    before_filter :authenticate_user!
    actions :all, :only => [:new, :create]
    respond_to :html
    defaults :route_prefix => 'assistant'

    def new
      @share = current_user.shares.build
      @goal = current_user.goals.find(params[:goal_id])
      @friends = Tracker.non_shared_friends(@goal, current_user)
    end
    
    def create
      
      create! do  |success, failure |
        success.html {redirect_to assistant_goals_path}
        failure.js {}
        failure.html do
          @friends = Tracker.non_shared_friends(@goal, current_user)
          render 'new'
        end
      end
    end
  
    private

    def begin_of_association_chain
      @goal = current_user.goals.find(params[:goal_id])
    end
    
  end
end