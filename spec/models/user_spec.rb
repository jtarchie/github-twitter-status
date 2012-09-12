require 'spec_helper'

describe User do
  describe "scopes" do
    describe ".active" do
      let!(:github_only) { User.create!(github_uid: "1234") }
      let!(:twitter_only) { User.create!(twitter_uid: "1234") }
      let!(:active) { User.create!(twitter_uid: "1234", github_uid: "1234") }

      it "only returns users with both Twitter and Github" do
        User.active.should == [active]
      end
    end
  end
end
