module Assistant
  class TrackersController < InheritedResources::Base
    InheritedResources.flash_keys = [ :success, :failure ]
    before_filter :authenticate_user!
    actions :all, :only => [:destroy]
    respond_to :html
    defaults :route_prefix => 'assistant'

    def destroy
      super {|format| format.html {redirect_to assistant_goals_path}}
    end
  end
end