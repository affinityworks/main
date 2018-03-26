require_relative "../test_helper"

class Dashboard < FeatureTest
  # TODO: figure out selenium/capybara/headless browser tests!!

  # def teardown
  #   super
  #   # stub_request(:get, "http://127.0.0.1:9515/shutdown")
  #   #   .to_return(:status => 200, :body => "", :headers => {})
  #   Capybara.use_default_driver
  #   Capybara.use_default_driver
  #   WebMock.enable!
  # end

  # def setup
  #   super
  #   WebMock.disable!
  #   Capybara.current_driver = :selenium
  #   #Capybara.current_driver = :chrome
  # end

  # describe "when events feature toggle on" do
  #   let(:group){ groups(:fantastic_four) }
  #   before do
  #     #login_as people(:human_torch)
  #     visit "/admin/login"
  #     fill_in 'person_email', with: people(:human_torch).primary_email_address
  #     fill_in 'person_password', with: 'password'
  #     click_button "Log in"

  #     visit "groups/#{group.id}/dashboard"
  #   end

  #   it "shows the events tab" do
  #     page.must_have_content "Events"
  #     assert_link("Events", href: "groups/#{group.id}/events")
  #   end
  # end

  # describe "when events feature toggle off" do
  #   it "hides the events tab"
  # end
end
