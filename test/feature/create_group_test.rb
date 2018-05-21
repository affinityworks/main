require_relative "../test_helper"
require_relative "../helpers/oauth_fixtures"
#require 'minitest/mock'

class CreateGroupTest < FeatureTest
  # shared fixtures
  include OAuthFixtures
  RESOURCES = %w[group address person membership phone_number email_address].freeze
  let(:group){ groups(:one) }
  let(:group_count){ Group.count }
  let(:address_count){ Address.count }
  let(:person_count){ Person.count }
  let(:phone_number_count){ PhoneNumber.count }
  let(:email_address_count){ EmailAddress.count }
  let(:membership_count){ Membership.count }
  let(:signup_form_count){ SignupForm.count }
  let(:last_person){ Person.last }
  let(:deliveries_count){ ActionMailer::Base.deliveries.size }

  describe "for logged-out person" do
    before { visit "/groups/#{group.id}/subgroups/new" }

    describe "viewing group creation form" do
      let(:group_values_by_input) do
        { 'Name*'       => 'Jawbreaker',
          'Zip Code'    => '90210',
          'Description' => 'I want to be a boat' }
      end

      it "has parent group's name in title" do
        page.must_have_content group.name
      end

      it "has fields for creating a group" do
        ['Name*', 'Zip Code'].each do |label|
          page.find("input[placeholder='#{label}']").wont_be_nil
        end
      end

      it "has a large description text area for group" do
        page.find(
          "textarea[placeholder='Description']"
        ).wont_be_nil
      end

      it "has correct required group fields" do
        page.find("input[placeholder='Name*'][required='required']").wont_be_nil
      end

      it "has button for creating with facebook signup" do
        page.must_have_button "Create with Facebook"
      end

      it "has button for creating with email signup" do
        page.must_have_button "Create with Email"
      end

      describe "creating subgroup" do
        describe "as a first-time use" do
          before do
            OmniAuth.config.mock_auth[:facebook] = mock_facebook_auth
          end

          describe "via facebook signup" do
            before do 
              fill_out_form group_values_by_input
              click_button 'Create with Facebook'
            end

            it "redirects to signup form" do
              current_path.must_equal "/groups/#{group.id}/subgroups/oauth_signup"
            end

            describe "viewing signup form" do
              it "has inputs for creating an organizer" do
                ['Zip Code*',
                 'Phone'].each do |label|
                  page.find("input[placeholder='#{label}']").wont_be_nil
                end
              end

              it "has correct required fields" do
                ['Zip Code*'].each do |label|
                  "input[placeholder='#{label}'][required='required']"
                end
              end
            end # viewing signup form

            describe "clicking 'Cancel" do
              before { click_link 'Cancel' }
              it "returns to subgroup creation page" do
                current_path.must_equal "/groups/#{group.id}/subgroups/new"
              end
            end

            describe "submitting signup form" do
              describe "with no errors" do
                before do
                  RESOURCES.each { |r| send("#{r}_count") }
                  deliveries_count; 
                  stub_long_lived_access_token_request.call
                  perform_enqueued_jobs do
                    fill_out_form(
                      'Zip Code*' => '90211',
                      'Phone' => '2128675309'
                    )
                    click_button "Submit"
                  end
                end

                it "creates a new group" do
                  Group.count.must_equal group_count + 1
                end

                it "creates a new person" do
                  Person.count.must_equal person_count + 1
                end

                it "makes person organizer of the group" do
                  Membership.last.role.must_equal "organizer"
                end

                it "sends a welcome email" do
                  ActionMailer::Base
                    .deliveries.size.must_equal(deliveries_count + 1)
                end
              end

              describe "with invalid entries" do
                before do
                  RESOURCES.each { |r| send("#{r}_count") }
                  stub_long_lived_access_token_request.call
                  fill_out_form(
                    'Phone'     => 'invalid',
                    'Zip Code*' => 'invalid'
                  )
                  click_button "Submit"
                end

                it "re-renders signup page" do
                  page.must_have_content "Organizer Signup"
                end

                it "does not create any resources" do
                  RESOURCES.each do |resource|
                    resource.camelize.constantize.count.must_equal(send("#{resource}_count"))
                  end
                end

                it "shows an error for invalid phone number" do
                  page.must_have_content(
                    "Phone number 'invalid' is not a valid phone number"
                  )
                end

                it "shows an error for invalid postal code" do
                  page.must_have_content(
                    "Zip code 'invalid' is not a valid zip code"
                  )
                end
              end
            end # subgmiting signup form
          end # via facbeook signup

          describe "via email signup" do
            before do
              fill_out_form group_values_by_input
              click_button "Create with Email"
            end

            it "redirects to signup form" do
              current_path.must_equal "/groups/#{group.id}/subgroups/signup"
            end

            describe "viewing signup form" do
              it "has inputs for creating an organizer" do
                ['Email*',
                 'Password*',
                 'First Name*',
                 'Last Name*',
                 'Zip Code*',
                 'Phone'].each do |label|
                  page.find("input[placeholder='#{label}']").wont_be_nil
                end
              end

              it "has correct required fields" do
                ['Email*',
                 'Password*',
                 'First Name*',
                 'Last Name*',
                 'Zip Code*'].each do |label|
                  "input[placeholder='#{label}'][required='required']"
                end
              end # has correct fields
            end # viewing signup form
            describe "clicking 'Cancel'" do
              before { click_link 'Cancel' }
              it "returns to subgroup creation page" do
                current_path.must_equal "/groups/#{group.id}/subgroups/new"
              end
            end
            describe "submitting signup form" do
              describe "with no errors" do
                before do
                  RESOURCES.each { |r| send("#{r}_count") }
                  deliveries_count
                  perform_enqueued_jobs do
                    fill_out_form(
                      'Email*' => 'foo@bar.com',
                      'Password*' => 'password',
                      'First Name*' => 'herbert',
                      'Last Name*' => 'stencil',
                      'Zip Code*' => '90211',
                      'Phone' => '212-867-5309'
                    )
                    click_button "Submit"
                  end
                end

                RESOURCES.each do |resource|
                  it "creates new #{resource}(s)" do
                    if resource === "address"
                      Address.count.must_equal(address_count + 2)
                    else
                      resource.camelize.constantize.count.must_equal(
                        send("#{resource}_count") + 1
                      )
                    end
                  end
                end

                it "redirects to the group's dashboard" do
                  page.current_path.must_equal "/groups/#{Group.last.id}/dashboard"
                end

                it "saves group info" do
                  Group.last.attributes.slice(*%w[name description]).must_equal(
                    'name' =>  "Jawbreaker",
                    'description' => 'I want to be a boat'
                  )
                end

                it "saves group location"  do
                  Group.last.location.postal_code.must_equal "90210"
                end

                it "saves organizer info" do
                  Person.last.attributes.slice(*%w[given_name family_name]).must_equal(
                    'given_name' => 'herbert',
                    'family_name' => 'stencil'
                  )
                end

                it "saves organizer password" do
                  last_person.encrypted_password.wont_be_nil
                  last_person.valid_password?("password")
                end

                it "saves organizer contact info" do
                  last_person.email_addresses.last.address.must_equal 'foo@bar.com'
                  last_person.phone_numbers.last.number.must_equal '212-867-5309'
                  last_person.personal_addresses.last.postal_code.must_equal '90211'
                end

                it "saves contact infos as 'primary'" do
                  last_person.primary_email_address.must_equal 'foo@bar.com'
                  last_person.primary_phone_number.must_equal '212-867-5309'
                  last_person.primary_personal_address.postal_code.must_equal '90211'
                end

                it "sends a welcome email (asynchronously)" do
                  ActionMailer::Base
                    .deliveries.size.must_equal(deliveries_count + 1)
                end
              end # with no errors

              describe "omitting optional fields" do
                before do
                  group_count; person_count;
                  fill_out_form(
                    'Email*'    => 'foo@bar.com',
                    'Zip Code*' => '11111'
                  )
                  click_button "Submit"
                end

                it "creates a new group" do
                  Group.count.must_equal group_count + 1
                end

                it "creates a new person" do
                  Person.count.must_equal person_count + 1
                end
              end

              describe "with invalid inputs" do
                before do
                  RESOURCES.each { |r| send("#{r}_count") }
                  fill_out_form(
                    'Email*'    => 'invalid',
                    'Phone'     => 'invalid',
                    'Zip Code*' => 'invalid'
                  )
                  click_button "Submit"
                end

                it "re-renders signup page" do
                  page.must_have_content "Organizer Signup"
                end

                it "does not create any resources" do
                  RESOURCES.each do |resource|
                    resource.camelize.constantize.count.must_equal(send("#{resource}_count"))
                  end
                end

                it "shows an error for invalid email address" do
                  page.must_have_content(
                    "Email address 'invalid' is not a valid email address"
                  )
                end

                it "shows an error for invalid phone number" do
                  page.must_have_content(
                    "Phone number 'invalid' is not a valid phone number"
                  )
                end

                it "shows an error for invalid postal code" do
                  page.must_have_content(
                    "Zip code 'invalid' is not a valid zip code"
                  )
                end
              end # with invalid inputs

              describe "with google group integration enabled" do
                let(:fancy_group){ groups(:ohio_chapter) }
                let(:google_group_email){ 'ohio-chapter@nationalnetwork.com' }
                let(:google_group_group_key){ "#{google_group_email}.test-google-a.com" }
                let(:google_group_url){ "https://groups.google.com/a/nationalnetwork.com/forum/#!forum/ohio-chapter" }
                let(:authentication_double){ double(Google::Auth::ServiceAccountCredentials) }
                let(:directory_service_double){ double(Google::Apis::AdminDirectoryV1::DirectoryService)}
                let(:google_group_double) do
                  double(Google::Apis::AdminDirectoryV1::Group,
                         id: "0279ka6516ngz0s",
                         email: google_group_email
                        )
                end
                let(:group_settings_double){ double(Google::Apis::GroupssettingsV1::Groups) }
                let(:settings_service_double){ double(Google::Apis::GroupssettingsV1::GroupssettingsService) }
                let(:google_group_member_double){ double(Google::Apis::AdminDirectoryV1::Member)}
                let(:google_group_count){ GoogleGroup.count }

                before do
                  # authentication
                  allow(Google::Auth::ServiceAccountCredentials)
                    .to receive(:make_creds).and_return(authentication_double)
                  allow(authentication_double)
                    .to receive(:sub=)
                  allow(Google::Auth::ServiceAccountCredentials)
                    .to receive(:sub=)

                  # connecting to directory service
                  allow(Google::Apis::AdminDirectoryV1::DirectoryService)
                    .to receive(:new).and_return(directory_service_double)
                  allow(directory_service_double)
                    .to receive(:authorization=)

                  # creating group
                  allow(Google::Apis::AdminDirectoryV1::Group)
                    .to receive(:new).and_return(google_group_double)
                  allow(directory_service_double)
                    .to receive(:insert_group).and_return(google_group_double)

                  # setting group group permissions
                  allow(Google::Apis::GroupssettingsV1::Groups)
                    .to receive(:new).and_return(group_settings_double)
                  allow(group_settings_double).to receive(:authorization=)
                  allow(Google::Apis::GroupssettingsV1::GroupssettingsService)
                    .to receive(:new).and_return(settings_service_double)
                  allow(settings_service_double).to receive(:authorization=)
                  allow(settings_service_double).to receive(:update_group) # <- expect!

                  # adding member
                  allow(Google::Apis::AdminDirectoryV1::Member)
                    .to receive(:new).and_return(google_group_member_double)
                  allow(directory_service_double).to receive(:insert_member)

                  # count google groups
                  google_group_count

                  # finally interact with page!
                  visit "/groups/#{fancy_group.id}/subgroups/new"
                  perform_enqueued_jobs do
                    # fill out group form
                    fill_out_form(
                      'Name*'       => 'Jawbreaker',
                      'Description' => 'I want to be a boat',
                      'Zip Code'    => '90210',
                    )
                    click_button "Create with Email"
                    # fill out organizer signup form
                    fill_out_form(
                      'Email*' => 'foo@bar.com',
                      'Password*' => 'password',
                      'First Name*' => 'herbert',
                      'Last Name*' => 'stencil',
                      'Zip Code*' => '90211',
                      'Phone' => '212-867-5309',
                    )
                    click_button "Submit"
                  end
                end

                it "creates a google group" do
                  expect(Google::Apis::AdminDirectoryV1::Group)
                    .to have_received(:new).with(email: Group.last.build_google_group_email,
                                                 name: Group.last.name,
                                                 description: GoogleAPI::CreateGoogleGroup::DESCRIPTION)

                  expect(directory_service_double)
                    .to have_received(:insert_group).with(google_group_double)
                end

                it "adds permissive settings to google group" do
                  expect(settings_service_double)
                    .to have_received(:update_group).with(google_group_email,
                                                          group_settings_double)
                end

                it "adds member to google group" do
                  expect(Google::Apis::AdminDirectoryV1::Member)
                    .to have_received(:new).with(email: Person.last.email,
                                                 role: GoogleAPI::Roles::OWNER)

                  expect(directory_service_double)
                    .to have_received(:insert_member).with(google_group_double.id,
                                                           google_group_member_double)
                end

                it "stores a record of the new google group" do
                  GoogleGroup.count.must_equal(google_group_count + 1)
                end

                it "saves the google group's important attributes" do
                  GoogleGroup.last.attributes.slice(*%w[group_id group_key email url])
                    .must_equal(
                      'group_id'  => Group.last.id,
                      'group_key' => google_group_double.id,
                      'email'     => google_group_email,
                      'url'       => google_group_url
                    )
                end
              end # with google group integration enabled
            end # submitting signup form
          end # via email signup
        end # as a first-timeuser
      end # creating subgroup
    end # viewing group-creation form
  end # for logged-out person

  describe "for logged-in person" do
    let(:person){ people(:human_torch) }
    before do
      login_as person
      visit "/groups/#{group.id}/subgroups/new"
    end

    describe "viewing page" do
      it "should not show organizer info fields" do
        page.wont_have_content "Organizer Info"
      end
    end

    describe "filling out form" do
      describe "with no errors" do
        before do
          RESOURCES.each { |r| send("#{r}_count") }
          deliveries_count
          perform_enqueued_jobs do
            fill_out_form(
              'Name*' => 'Jawbreaker',
              'Description' => 'I want to be a boat',
              'Zip Code' => '90210'
            )
            click_button "Submit"
          end
        end

        it "creates new subgroup" do
          Group.count.must_equal group_count + 1
        end

        it "makes subgroup an affiliate of parent group" do
          group.affiliates.must_include Group.last
        end

        it "does not create new person" do
          Person.count.must_equal person_count
        end

        it "makes person a member of subgroup" do
          Group.last.members.must_include person
        end

        it "redirects to subgroup's dashboard" do
          current_path.must_equal "/groups/#{Group.last.id}/dashboard"
        end

        it "sends a welcome email" do
          ActionMailer::Base.deliveries.size.must_equal deliveries_count + 1
        end
      end # with no errors
    end # filling out form
  end # for logged-in person
end # CreateGroupTest
