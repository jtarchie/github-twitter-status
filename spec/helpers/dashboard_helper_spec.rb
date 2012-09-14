require "spec_helper"

describe DashboardHelper do
  context "#authorize_button" do
    let(:service) { "service" }
    let(:user) { double(:user, github_uid: github_uid) }

    subject { Capybara.string(helper.authorize_button(user, service)) }

    context "when the user has not activated the service" do
      let(:github_uid) { nil }

      it { should have_css("a[href='/auth/#{service}']") }
      it { should have_css("a.btn.btn-primary.btn-large")}
      it { should have_content(service.capitalize) }
      it { should have_css("a i.icon-plus-sign.icon-white")}
    end

    context "when user has actived the service" do
      let(:github_uid) { "token" }

      it { should have_css("a[href='/auth/#{service}']") }
      it { should have_css("a.btn.btn-primary.btn-large")}
      it { should have_content(service.capitalize) }
      it { should have_css("a i.icon-ok.icon-white")}
    end
  end
end