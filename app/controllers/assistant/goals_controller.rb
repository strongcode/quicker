module Assistant
  class GoalsController < InheritedResources::Base
    InheritedResources.flash_keys = [ :success, :failure ]
    before_filter :authenticate_user!
    #before_filter :check_for_guide, :only => [:index]
    actions :all
    respond_to :html, :except => [:except]
    respond_to :js, :only => [:update, :show]
    defaults :route_prefix => 'assistant'

    def create
      create! do |success, failure|
          success.html {redirect_to assistant_goals_path}
          failure.html { render 'new'}
        end
    end

    def update
      @goals ||= end_of_association_chain.not_completed.page(params[:page]).per(1)
      @finished_goals ||= end_of_association_chain.unscoped.finished(current_user).page(params[:completed_goal_page]).per(2)
      @goal = current_user.goals.find params[:id]
      if params[:goal] && params[:goal][:status_percentage] && params[:goal][:status_percentage].to_i == 100 
        unless @goal.completed?
          if @goal.end_date > Time.zone.now
            @goal.started_date = Time.zone.now
          end
          @goal.ended_date = Time.zone.now
          @goal.completed = 1
          update! 
        end
      else
        update! do |success, failure|
          success.html {redirect_to "#{assistant_goals_path}?page=#{params[:page]}&completed_goal_page=#{params[:completed_goal_page]}"}
          failure.html { render 'edit'}
        end
      end
      
    end

    protected
    def begin_of_association_chain
      current_user
    end

    def collection
      @goals ||= end_of_association_chain.not_completed.page(params[:page]).per(1)
      @finished_goals ||= end_of_association_chain.unscoped.finished(current_user).page(params[:completed_goal_page]).per(2)
      @trackers = current_user.trackers.goals.order('created_at DESC').page(params[:friends_goal_page]).per(2)
    end

  end
end

