require "spec_helper"

feature "Authorizing accounts" do
  scenario "against the social networks" do
    visit root_path

    click_on "Github"
    page.should have_content("Successfully authorized with Github")

    click_on "Twitter"
    page.should have_content("Successfully authorized with Twitter")
  end
end