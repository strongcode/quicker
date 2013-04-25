require 'spec_helper'

describe KickController do

  describe "GET 'side_kick'" do
    it "returns http success" do
      get 'side_kick'
      response.should be_success
    end
  end

end
