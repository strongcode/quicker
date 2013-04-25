module Sidekick
  class LocationSharesController < InheritedResources::Base
    InheritedResources.flash_keys = [:success, :failure]
    before_filter :authenticate_user!
    actions :all, :only => [:new, :create]
    defaults :resource_class => Share, :collection_name => 'shares', :instance_name => 'share'
    respond_to :html, :js

    def create
      super {|format| format.html {redirect_to root_url}}
    end

    private
    def begin_of_association_chain
      @location = Location.find(params[:location_id])
    end
  end
end