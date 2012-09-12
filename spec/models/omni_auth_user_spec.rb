require "spec_helper"

describe OmniAuthUser do
  context ".create" do
    let(:create_user) { OmniAuthUser.create(attributes) }

    shared_examples_for "from a specific session" do
      let(:user_id) { nil }
      let(:attributes) { OmniAuth.config.mock_auth[session.to_sym] }

      context "when a user already exist" do
        let!(:user) { User.create!("#{session}_uid" => attributes.uid) }

        it "does not create a new user" do
          expect {
            create_user
          }.to_not change { User.count }.by(1)
        end

        it "adds the tokens" do
          user = create_user
          user["#{session}_uid"].should == attributes.uid
          user["#{session}_token"].should == attributes.credentials.token
          user["#{session}_secret"].should == attributes.credentials.secret
        end
      end

      context "when a user doesn't exist" do
        it "create a new user" do
          expect {
            create_user
          }.to change { User.count }.by(1)
        end

        it "adds the github tokens" do
          user = create_user
          user["#{session}_uid"].should == attributes.uid
          user["#{session}_token"].should == attributes.credentials.token
          user["#{session}_secret"].should == attributes.credentials.secret
        end
      end
    end

    it_behaves_like "from a specific session" do
      let(:session) { "github" }
    end

    it_behaves_like "from a specific session" do
      let(:session) { "twitter" }
    end
  end
end