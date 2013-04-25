module Sidekick
  class TrackersController < InheritedResources::Base
    InheritedResources.flash_keys = [ :success, :failure ]
    before_filter :authenticate_user!
    actions :all, :only => [:destroy]
    respond_to :html

    def destroy
      super {|format| format.html {redirect_to friends_location_lists_path}}
    end
  end
end