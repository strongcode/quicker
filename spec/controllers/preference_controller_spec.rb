require 'spec_helper'

describe PreferenceController do

  describe "GET 'pref_page'" do
    it "returns http success" do
      get 'pref_page'
      response.should be_success
    end
  end

end
