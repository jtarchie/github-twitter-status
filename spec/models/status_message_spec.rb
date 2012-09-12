require "spec_helper"

describe StatusMessage do
  context "#generate" do
    let(:date_range) { 7.days.ago..Time.now }
    let(:github_token) { "github_token" }
    let(:twitter_token) { "twitter_token" }
    let(:twitter_secret) { "twitter_secret" }
    let(:generate!) { StatusMessage.new(user, date_range).generate! }
    let(:user) { double(:user, github_token: github_token, twitter_token: twitter_token, twitter_secret: twitter_secret) }

    context "collecting status from Github" do
      let!(:client) { Github.new }
      let(:github_user) { {'login' => 'username'} }
      let(:events) { [] }

      before do
        Github.stub(:new).and_return(client)
        client.stub_chain(:events, :performed, :each_page).and_yield(events)
        client.stub_chain(:users, :get).and_return(github_user)
        Twitter::Client.any_instance.stub(:update)
      end

      it "inits the Github client with the user" do
        Github.should_receive(:new).with(oauth_token: github_token).and_return(client)
        generate!
      end

      context "when there there are events for a user" do
        let(:events) do
          [
            { 'type' => "FakeEvent" },
            { 'type' => "PushEvent", "created_at" => (date_range.first - 1.day).to_s, 'repo' => {'id' => '1'} },
            { 'type' => "PushEvent", "created_at" => date_range.first.to_s, 'repo' => {'id' => '2'} },
            { 'type' => "PushEvent", "created_at" => (date_range.last + 1.day).to_s, 'repo' => {'id' => '4'} }
          ]
        end

        it "sends a tweet with the stats" do
          Twitter::Client.any_instance.should_receive(:update).with("I have 1 commit over 1 repo this past week.")
          generate!
        end

        context "with plurization" do
          it "sends a tweets with the stats" do
            events << { 'type' => "PushEvent", "created_at" => date_range.last.to_s, 'repo' => {'id' => '3'} }
            Twitter::Client.any_instance.should_receive(:update).with("I have 2 commits over 2 repos this past week.")
            generate!
          end
        end
      end
    end
  end
end