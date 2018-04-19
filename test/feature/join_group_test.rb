require_relative "../test_helper"

class JoinGroupTest < FeatureTest
  let(:group){ groups(:fantastic_four) }

  describe "as a first time user" do
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
    end

    describe "picking a signup path" do
      before do
        visit "/groups/#{group.id}/join"
        click_link "Join with email"
      end

      it "navigates to the email path when i click the email button" do
        current_url.must_equal(
          "http://www.example.com/groups/#{group.id}/members/new?signup_mode=email"
        )
      end
    end

    describe "email signup path" do
      let(:submissions_by_input_label) do
        {'Email*' => 'serious@person.com',
         'Password*'       => 'password',
         'First Name*'    => 'Serious',
         'Last Name*'     => 'Person',
         'Zip Code*'      => '11111',
         'Phone'   => '111-111-1111',}
      end
      let(:labels){ submissions_by_input_label.keys }
      let(:required_labels){ labels.select{ |l| l.include?("*") } }

      before { visit "/groups/#{group.id}/members/new?signup_mode=email" }

      describe "viewing the signup form" do
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
      end

      describe "going back" do
        before { click_link 'Cancel'}

        it "returns to join page when i click 'cancel'" do
          current_path.must_equal "/groups/#{group.id}/join"
        end
      end

      describe "submitting the signup form" do
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
        end

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
        end

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
        end
      end
    end
  end
end
