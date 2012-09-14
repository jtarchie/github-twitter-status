require 'spec_helper'

describe DashboardController do
  context "GET#index" do
    it "renders successfully" do
      get :show
      response.should be_success
    end

    context "with a user session" do
      let(:user_id) { 1 }
      let(:user) { double(:user) }

      before { session[:user_id] = user_id }

      it "loads the user" do
        User.should_receive(:find_by_id).with(user_id).and_return(user)
        get :show
        assigns(:user).should == user
      end
    end

    context "without a user session" do
      it "inits a new user" do
        get :show
        assigns(:user).should be_new_record
      end
    end
  end
end
