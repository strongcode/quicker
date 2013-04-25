module Sidekick
  class PassionateSharesController < InheritedResources::Base
    InheritedResources.flash_keys = [:success, :failure]
    before_filter :authenticate_user!
    actions :all, :only => [:new, :create]
    defaults :resource_class => Share, :collection_name => 'shares', :instance_name => 'share'
    respond_to :html

    def create
      super {|format| format.html {}}
      create! do  |success, failure |
        success.html {redirect_to passionates_path}
        failure.html {render 'new'}
      end
    end

    private
    def begin_of_association_chain
      @passionate = current_user.passionates.find(params[:passionate_id])
    end
  end
end