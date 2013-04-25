module Insider
  class SuggestionSharesController < InheritedResources::Base
    InheritedResources.flash_keys = [:success, :failure]
    before_filter :authenticate_user!
    actions :all, :only => [:new, :create]
    defaults :resource_class => Share, :collection_name => 'shares', :instance_name => 'share'
    respond_to :html

    def new
      @suggestion = Suggestion.find(params[:suggestion_id])
      @share = current_user.shares.build
      @friends = Tracker.non_shared_friends(@suggestion, current_user)
    end

    def create
      create! do  |success, failure |
        success.html {redirect_to insider_offers_path}
        failure.js {@friends = Tracker.non_shared_friends(@suggestion, current_user)}
        failure.html do
          @friends = Tracker.non_shared_friends(@suggestion, current_user)
          render 'new'
        end
      end
    end

    private
    def begin_of_association_chain
      @suggestion = Suggestion.find_by_id params[:suggestion_id]
    end
  end
end