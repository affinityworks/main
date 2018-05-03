require_relative "../test_helper"

class JoinGroupTest < FeatureTest
  let(:group){ groups(:fantastic_four) }
  let(:organizer){ people(:organizer) }

  # facebook fixtures
  let(:facebook_token) do
    "UwlcA5KfBMIfSXx8dYmTusAs5FNmqBDQ13L6upHh84mBua5TR7sK7eGYm9FSGz6pTdfv7xzz"+
      "iIKnPQLOEEw6icFuIFjrjSxQxHfxLpQEYWgz6zzs2U209liTg5JFRm9u7RmRzpxEaaWI9M"+
      "9u61CAh7psEMkjqsfRBFi4hm89iJ91tACuiQGxtZhKr"
  end
  let(:mock_facebook_auth) do
    OmniAuth::AuthHash.new(
      { "provider"     => "facebook",
        "uid"          => "100174124183958",
        "credentials"  =>
        { "token"        => facebook_token ,
          "expires_at"   => "1529880563",
          "expires"      => "true" },
        "info"         =>
        { "email"        => "testy@affinity.works",
          "name"         => "Testy McGee",
          "image"        => "http://graph.facebook.com/v2.6/"+
                            "100174124183958/picture" }
      }
    )
  end
  let(:mock_facebook_auth_existing_user) do
    mock_facebook_auth.merge(
      "info" => {
        "email" => "organizer@admin.com",
        "name"  => "DifferentlyNamed Organizer",
        "image" => mock_facebook_auth['image']
      }
    )
  end
  let(:facebook_authorization_double){ double(Facebook::Authorization) }
  let(:stub_long_lived_access_token_request) do
    -> do
      allow(Facebook::Authorization)
        .to receive(:new)
              .and_return(facebook_authorization_double)
      allow(facebook_authorization_double)
        .to receive(:request_long_lived_token)
              .and_return(facebook_token)
    end
  end

  # google fixtures
  let(:google_token) do
    "ya29.GluqBT22iW1wYDxF1U295fvAkjpwtOBmp_Yym7rHmj0HIc3KcauH8f4a3Rdkc7SB"+
      "xcU1h9lUJjeP-PgMpLhGzpoK-W43-Q53UCqMUJjxf82qJEtjm6byTgAILyWn"
  end
  let(:mock_google_auth) do
    OmniAuth::AuthHash.new(
      { "provider"     => "google",
        "uid"          => "106985388443100843978",
        "credentials"  =>
        { "token"        => google_token ,
          "expires_at"   => "1524802515",
          "expires"      => "true" },
        "info"         =>
        { "email"        => "testy@affinity.works",
          "name"         => "Testy McGee",
          "image"        => "https://lh6.googleusercontent.com/-nw_wxuaEA_0"+
                            "/AAAAAAAAAAI/AAAAAAAAAAc/jASoGVsZEYI/photo.jpg" },
      }
    )
  end
  let(:mock_google_auth_existing_user) do
    mock_google_auth.merge(
      mock_google_auth.fetch("info").merge(
        "email" => "organizer@admin.com",
        "name"  => "Test Organizer",
      )
    )
  end

  describe "as a logged-in user" do
    let(:organizer){ people(:human_torch) }
    let(:fantastic_four){ groups(:fantastic_four) }
    let(:ohio_chapter){ groups(:ohio_chapter) }

    before { login_as organizer }

    describe "who is already a member of the group" do
      before do
        fantastic_four.members.must_include organizer
        visit "/groups/#{fantastic_four.id}/join"
      end

      it "does not show a join button" do
        page.wont_have_button "Join"
      end

      it "shows a notification that user has already joined" do
        page.must_have_content "already joined"
      end

      it "links to group's dashboard" do
        page.must_have_link fantastic_four.name,
                            href: "/groups/#{fantastic_four.id}/dashboard"
      end
    end

    describe "who is not a member of the group" do
      before do
        ohio_chapter.members.wont_include organizer
        visit "/groups/#{ohio_chapter.id}/join"
      end

      describe "viewing the join page" do
        it "has a 'Join' button" do
          page.must_have_button "Join"
        end
      end

      describe "clicking 'Join'" do
        let(:person_count){ Person.count }
        let(:membership_count){ Membership.count }

        describe "with no errors" do
          before do
            person_count; membership_count
            click_button "Join"
          end

          it "does not create a new person" do
            Person.count.must_equal person_count
          end

          it "creates a new membership" do
            Membership.count.must_equal membership_count + 1
          end

          it "makes user a member of the group" do
            organizer
              .memberships.last
              .attributes.slice('group_id', 'role')
              .must_equal('group_id' => ohio_chapter.id,
                          'role' => 'member')
          end

          it "forwards user to the group's dashboard" do
            current_path.must_equal "/groups/#{ohio_chapter.id}/dashboard"
          end
        end

        describe "when membership could not be created" do
          before do
            allow(Membership).to receive(:create).and_return(nil)
            click_button "Join"
          end

          it "redirects user to home page" do
            current_path.must_equal "/home"
          end
        end
      end
    end
  end

  describe "logged out" do
    # basic fixtures
    let(:group){ groups(:fantastic_four) }
    let(:organizer){ people(:organizer) }

    # facebook fixtures
    let(:fb_token) do
      "UwlcA5KfBMIfSXx8dYmTusAs5FNmqBDQ13L6upHh84mBua5TR7sK7eGYm9FSGz6pTdfv7xzz"+
        "iIKnPQLOEEw6icFuIFjrjSxQxHfxLpQEYWgz6zzs2U209liTg5JFRm9u7RmRzpxEaaWI9M"+
        "9u61CAh7psEMkjqsfRBFi4hm89iJ91tACuiQGxtZhKr"
    end
    let(:mock_facebook_auth) do
      OmniAuth::AuthHash.new(
        { "provider"     => "facebook",
          "uid"          => "100174124183958",
          "credentials"  =>
          { "token"        => fb_token ,
            "expires_at"   => "1529880563",
            "expires"      => "true" },
          "info"         =>
          { "email"        => "testy@affinity.works",
            "name"         => "Testy McGee",
            "image"        => "http://graph.facebook.com/v2.6/"+
                              "100174124183958/picture" }
        }
      )
    end
    let(:mock_facebook_auth_existing_user) do
      mock_facebook_auth.merge(
        "info" => {
          "email" => "organizer@admin.com",
          "name"  => "DifferentlyNamed Organizer",
          "image" => mock_facebook_auth['image']
        }
      )
    end
    let(:stub_long_lived_access_token_response) do
      -> do
        stub_request(
          :get,
          "https://graph.facebook.com/v2.9/oauth/access_token"+
          "?client_id="+
          "&client_secret="+
          "&fb_exchange_token=UwlcA5KfBMIfSXx8dYmTusAs5FNmqBDQ13L6upH"+
          "h84mBua5TR7sK7eGYm9FSGz6pTdfv7xzziIKnPQLOEEw6icFuIFjrjSxQx"+
          "HfxLpQEYWgz6zzs2U209liTg5JFRm9u7RmRzpxEaaWI9M9u61CAh7psEMk"+
          "jqsfRBFi4hm89iJ91tACuiQGxtZhKr&grant_type=fb_exchange_token"
        ).to_return(:status => 200)
      end
    end

    # google fixtures
    let(:google_token) do
      "ya29.GluqBT22iW1wYDxF1U295fvAkjpwtOBmp_Yym7rHmj0HIc3KcauH8f4a3Rdkc7SB"+
        "xcU1h9lUJjeP-PgMpLhGzpoK-W43-Q53UCqMUJjxf82qJEtjm6byTgAILyWn"
    end
    let(:mock_google_auth) do
      OmniAuth::AuthHash.new(
        { "provider"     => "google",
          "uid"          => "106985388443100843978",
          "credentials"  =>
          { "token"        => google_token ,
            "expires_at"   => "1524802515",
            "expires"      => "true" },
          "info"         =>
          { "email"        => "testy@affinity.works",
            "name"         => "Testy McGee",
            "image"        => "https://lh6.googleusercontent.com/-nw_wxuaEA_0"+
                              "/AAAAAAAAAAI/AAAAAAAAAAc/jASoGVsZEYI/photo.jpg" },
        }
      )
    end
    let(:mock_google_auth_existing_user) do
      mock_google_auth.merge(
        mock_google_auth.fetch("info").merge(
          "email" => "organizer@admin.com",
          "name"  => "Test Organizer",
        )
      )
    end

    describe "as a first time user" do
      before do
        OmniAuth.config.mock_auth[:facebook] = mock_facebook_auth
        OmniAuth.config.mock_auth[:google_oauth2] = mock_google_auth
      end

      describe "viewing the join page" do
        before { visit "/groups/#{group.id}/join" }

        it "has a title" do
          page.must_have_content group.name
        end

        it "has a description" do
          page.must_have_content group.description
        end

        it "has a call to action" do
          page.must_have_text "Join"
        end

        it "has a button for joining with email" do
          page.must_have_link('Join with email',
                              href: "/groups/#{group.id}/members/new?signup_mode=email")
        end

        describe "picking email path" do

          before { click_link "Join with email" }

          it "navigates to the new members form" do
            current_path.must_equal "/groups/#{group.id}/members/new"
          end

          it "it sets the signup mode to email" do
            current_params['signup_mode'].must_equal 'email'
          end

          describe "viewing email signup form" do
            let(:submissions_by_input_label) do
              {'Email*'      => 'serious@person.com',
               'Password*'   => 'password',
               'First Name*' => 'Serious',
               'Last Name*'  => 'Person',
               'Zip Code*'   => '11111',
               'Phone'       => '111-111-1111',}
            end
            let(:labels){ submissions_by_input_label.keys }
            let(:required_labels){ labels.select{ |l| l.include?("*") } }

            it "has fields for missing contact info" do
              labels.each do |label|
                page.find("input[placeholder='#{label}']").wont_be_nil
              end
            end

            it "has correct required organizer fields" do
              required_labels.each do |label|
                "input[placeholder='#{label}'][required='required']"
              end
            end

            describe "going back" do
              before { click_link 'Cancel'}

              it "returns to join page when i click 'cancel'" do
                current_path.must_equal "/groups/#{group.id}/join"
              end
            end # going back

            describe "submitting email signup form" do
              let(:person_count){ Person.count }
              let(:membership_count){ Membership.count }

              describe "with no errors" do
                before do
                  person_count; membership_count
                  fill_out_form submissions_by_input_label
                  click_button 'Submit'
                end

                it "creates a new person" do
                  Person.count.must_equal person_count + 1
                end

                it "creates a new membership" do
                  Membership.count.must_equal membership_count + 1
                end

                it "stores persons's contact info" do
                  [:email_addresses, :phone_numbers, :personal_addresses].each do |msg|
                    Person.last.send(msg).first.primary?.must_equal true
                  end
                end

                it "redirects to member homepage" do
                  current_path.must_equal "/home"
                end
              end # with no errors

              describe "with invalid inputs" do
                before do
                  fill_out_form(
                    submissions_by_input_label.merge(
                      'Email*'    => 'invalid',
                      'Phone'     => 'invalid',
                      'Zip Code*' => 'invalid'
                    )
                  )
                  click_button "Submit"
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
                let(:authentication_double){ double(Google::Auth::ServiceAccountCredentials) }
                let(:directory_service_double){ double(Google::Apis::AdminDirectoryV1::DirectoryService)}
                let(:google_group_double) do
                  double(Google::Apis::AdminDirectoryV1::Group,
                         id: 1,
                         email: google_group_email,
                         non_editable_aliases: [google_group_group_key]
                        )
                end
                let(:google_group_member_double){ double(Google::Apis::AdminDirectoryV1::Member)}

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

                  # fetching group
                  allow(directory_service_double)
                    .to receive(:get_group).and_return(google_group_double)

                  # adding member
                  allow(Google::Apis::AdminDirectoryV1::Member)
                    .to receive(:new).and_return(google_group_member_double)
                  allow(directory_service_double).to receive(:insert_member)

                  perform_enqueued_jobs do
                    # fill out form!
                    visit "/groups/#{fancy_group.id}/members/new?signup_mode=email"
                    fill_out_form(submissions_by_input_label)
                    click_button "Submit"
                  end
                end

                it "adds member to group's google group" do
                  expect(Google::Apis::AdminDirectoryV1::Member)
                    .to have_received(:new).with(email: Person.last.email,
                                                 role: GoogleAPI::Roles::MEMBER)

                  expect(directory_service_double)
                    .to have_received(:insert_member).with(google_group_double.id,
                                                           google_group_member_double)
                end
              end # with google integrations enabled
            end # submitting email signup form
          end # viewing email signup form
        end # picking email path

        describe "picking facebook path" do
          before { click_link "Join with Facebook" }

          it "navigates to new members form" do
            current_path.must_equal "/groups/#{group.id}/members/new"
          end

          it "sets the signup mode to facebook" do
            current_params['signup_mode'].must_equal 'facebook'
          end

          it "passes non-sensitive oauth data as cleartext params" do
            {
              "provider" => current_params["person[oauth][provider]"],
              "uid" => current_params["person[oauth][uid]"],
              "credentials" => {
                # omit token from this test
                "expires_at" => current_params["person[oauth][credentials][expires_at]"],
                "expires" => current_params["person[oauth][credentials][expires]"],
              },
              "info" => {
                "email" => current_params["person[oauth][info][email]"],
                "name" => current_params["person[oauth][info][name]"],
                "image" => current_params["person[oauth][info][image]"],
              }
            }.must_equal(
              mock_facebook_auth.to_hash.merge(
                "credentials" => mock_facebook_auth
                                   .to_hash
                                   .fetch('credentials')
                                   .except('token')
              )
            )
          end

          it "passes oauth token as encrypted param" do
            Crypto.decrypt_with_nacl_secret(
              current_params["person[oauth][credentials][token]"]
            ).must_equal mock_facebook_auth.dig('credentials', 'token')
          end

          describe "viewing facebook signup form" do

            let(:submissions_by_input_label) do
              {'Zip Code*'   => '11111',
               'Phone'       => '111-111-1111',}
            end
            let(:labels){ submissions_by_input_label.keys }
            let(:required_labels){ labels.select{ |l| l.include?("*") } }
            let(:supressed_fields) do
              ['Email*', 'Password*', 'Fist Name*', 'Last Name*']
            end

            it "has fields for missing contact info" do
              labels.each do |label|
                page.find("input[placeholder='#{label}']").wont_be_nil
              end
            end

            it "has correct required fields" do
              required_labels.each do |label|
                "input[placeholder='#{label}'][required='required']"
              end
            end

            it "does not show suppressed fields" do
              supressed_fields.each do |label|
                page.all("input[placeholder='#{label}']").must_be_empty
              end
            end

            describe "filling out facebook signup form" do
              # we don't test for submission errors here: covered in email branch
              let(:person_count){ Person.count }
              let(:membership_count){ Membership.count }
              let(:identity_count){ Identity.count }

              describe "with no errrors" do
                before do
                  person_count; membership_count; identity_count
                  stub_long_lived_access_token_response.call
                  fill_out_form submissions_by_input_label
                  click_button 'Submit'
                end

                it "creates a new person" do
                  Person.count.must_equal person_count + 1
                end

                it "creates a new membership" do
                  Membership.count.must_equal membership_count + 1
                end

                it "creates a new identity" do
                  Identity.count.must_equal identity_count + 1
                end

                it "stores persons's contact info" do
                  [:email_addresses, :phone_numbers, :personal_addresses].each do |msg|
                    Person.last.send(msg).first.primary?.must_equal true
                  end
                end

                it "stores person's facebook identity" do
                  Identity.last.attributes.slice('uid', 'provider', 'access_token')
                    .must_equal('uid'          => mock_facebook_auth['uid'],
                                'provider'     => mock_facebook_auth['provider'],
                                'access_token' => mock_facebook_auth['credentials']['token'])
                end

                it "redirects to member homepage" do
                  current_path.must_equal "/home"
                end
              end # with no errors

              describe "with invalid inputs" do
                before do
                  fill_out_form(
                    submissions_by_input_label.merge(
                      'Zip Code*' => 'invalid',
                      'Phone'     => 'invalid',
                    )
                  )
                  click_button "Submit"
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
            end # filling out facebook signup form
          end # viewing facebook signup form
        end # picking facebook path

        describe "picking google path" do

          before { click_link "Join with Google" }

          it "navigates to new members form" do
            current_path.must_equal "/groups/#{group.id}/members/new"
          end

          it "sets the signup mode to google" do
            current_params['signup_mode'].must_equal 'google'
          end

          it "passes non-sensitive oauth data as cleartext params" do
            {
              "provider" => current_params["person[oauth][provider]"],
              "uid" => current_params["person[oauth][uid]"],
              "credentials" => {
                # omit token from this test
                "expires_at" => current_params["person[oauth][credentials][expires_at]"],
                "expires" => current_params["person[oauth][credentials][expires]"],
              },
              "info" => {
                "email" => current_params["person[oauth][info][email]"],
                "name" => current_params["person[oauth][info][name]"],
                "image" => current_params["person[oauth][info][image]"],
              }
            }.must_equal(
              mock_google_auth.to_hash.merge(
                "credentials" => mock_google_auth
                                   .to_hash
                                   .fetch('credentials')
                                   .except('token')
              )
            )
          end

          it "passes oauth token as encrypted param" do
            Crypto.decrypt_with_nacl_secret(
              current_params["person[oauth][credentials][token]"]
            ).must_equal mock_google_auth.dig('credentials', 'token')
          end

          describe "viewing google signup form" do

            let(:submissions_by_input_label) do
              {'Zip Code*'   => '11111',
               'Phone'       => '111-111-1111',}
            end
            let(:labels){ submissions_by_input_label.keys }
            let(:required_labels){ labels.select{ |l| l.include?("*") } }
            let(:supressed_fields) do
              ['Email*', 'Password*', 'Fist Name*', 'Last Name*']
            end

            it "has fields for missing contact info" do
              labels.each do |label|
                page.find("input[placeholder='#{label}']").wont_be_nil
              end
            end

            it "has correct required fields" do
              required_labels.each do |label|
                "input[placeholder='#{label}'][required='required']"
              end
            end

            it "does not show suppressed fields" do
              supressed_fields.each do |label|
                page.all("input[placeholder='#{label}']").must_be_empty
              end
            end

            describe "filling out google signup form" do
              # we don't test for submission errors here: covered in email branch
              let(:person_count){ Person.count }
              let(:membership_count){ Membership.count }
              let(:identity_count){ Identity.count }

              describe "with no errrors" do
                before do
                  person_count; membership_count; identity_count
                  fill_out_form submissions_by_input_label
                  click_button 'Submit'
                end

                it "creates a new person" do
                  Person.count.must_equal person_count + 1
                end

                it "creates a new membership" do
                  Membership.count.must_equal membership_count + 1
                end

                it "does creates a new identity" do
                  Identity.count.must_equal identity_count + 1
                end

                it "stores persons's contact info" do
                  [:email_addresses, :phone_numbers, :personal_addresses].each do |msg|
                    Person.last.send(msg).first.primary?.must_equal true
                  end
                end

                it "stores person's google identity" do
                  Identity.last.attributes.slice('uid', 'provider', 'access_token')
                    .must_equal('uid'          => mock_google_auth['uid'],
                                'provider'     => mock_google_auth['provider'],
                                'access_token' => mock_google_auth['credentials']['token'])
                end

                it "redirects to member homepage" do
                  current_path.must_equal "/home"
                end
              end # with no errors

              describe "with invalid inputs" do
                before do
                  fill_out_form(
                    submissions_by_input_label.merge(
                      'Zip Code*' => 'invalid',
                      'Phone'     => 'invalid',
                    )
                  )
                  click_button "Submit"
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
            end # filling out google signup form
          end # viewing google signup form
        end # picking google path
      end # viewing the join page
    end # as a first time user

    describe "as user with an affinity account" do
      before do
        OmniAuth.config.mock_auth[:facebook] = mock_facebook_auth_existing_user
        OmniAuth.config.mock_auth[:google_oauth2] = mock_google_auth_existing_user
        visit "/groups/#{group.id}/join"
      end

      describe "picking facebook path" do
        let(:person_count){ Person.count }
        let(:membership_count){ Membership.count }
        let(:identity_count){ Identity.count }

        before do
          person_count; membership_count; identity_count
          stub_long_lived_access_token_response.call
          click_link "Join with Facebook"
          fill_out_form({'Zip Code*'   => '11111',
                         'Phone'       => '111-111-1111',})
          click_button "Submit"
        end

        it "does not create a new person" do
          Person.count.must_equal person_count
        end

        it "creates a new membership" do
          Membership.count.must_equal membership_count + 1
        end

        it "creates a new identity" do
          Identity.count.must_equal identity_count + 1
        end

        it "does not change person's name" do
          organizer.given_name.must_equal("Test")
        end

        it "stores persons's contact info" do
          [:email_addresses, :phone_numbers, :personal_addresses].each do |msg|
            organizer.send(msg).first.primary?.must_equal true
          end
        end

        it "stores person's facebook identity" do
          Identity.last.attributes.slice('person_id', 'uid', 'provider', 'access_token')
            .must_equal('person_id'    => organizer.id,
                        'uid'          => mock_facebook_auth['uid'],
                        'provider'     => mock_facebook_auth['provider'],
                        'access_token' => mock_facebook_auth['credentials']['token'])
        end

        it "redirects to member homepage" do
          current_path.must_equal "/home"
        end
      end # picking facebook path
    end # as user with an affinity account
  end # logged out
end # JoinGroupTest
