require 'spec_helper'

describe DashboardController do
  context "GET#index" do
    it "is successful" do
      get :show
      response.should be_success
    end
  end
end
