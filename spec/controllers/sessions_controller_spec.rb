require 'spec_helper'

describe SessionsController do
  context "GET#create" do
    let(:user) { double(:user, id: 1234) }

    before do
      request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]
      OmniAuthUser.stub(:create).and_return(user)
      OmniAuthUser.stub(:update).and_return(user)
    end

    it "redirects to root" do
      get :create, provider: "twitter"
      response.should redirect_to root_path
    end

    it "creates an OmniAuthUser and sets session id of the user" do
      OmniAuthUser.should_receive(:create).with(OmniAuth.config.mock_auth[:twitter]).and_return(user)

      get :create, provider: "twitter"
      session[:user_id].should == user.id
      flash[:authorized_with].should == "twitter"
    end

    context "with an already sessioned user" do
      before { session[:user_id] = user.id }

      it "creates an OmniAuthUser and sets session id of the user" do
        OmniAuthUser.should_receive(:update).with(session[:user_id], OmniAuth.config.mock_auth[:twitter]).and_return(user)

        get :create, provider: "twitter"
        session[:user_id].should == user.id
        flash[:authorized_with].should == "twitter"
      end
    end
  end
end
