require_relative "../test_helper"

describe "submitting email signup form" do
    let(:input_groups){ CustomForm::INPUT_GROUPS.map{ |ig| form.send(ig) } }
    let(:person_count){ Person.count }
    let(:membership_count){ Membership.count }
    let(:new_member){ Person.last }

    before { person_count;  membership_count }

    describe "with no errors" do
      before do
        fill_out_form values_by_input(input_groups)
        click_button form.submit_text
      end

      it "creates a new person" do
        Person.count.must_equal person_count + 1
      end

      it "creates a new membership" do
        Membership.count.must_equal membership_count + 1
      end

      it "stores persons's contact info" do
        [:email_addresses, :phone_numbers, :personal_addresses].each do |msg|
          new_member.reload.send(msg).first.primary?.must_equal true
        end
      end

      it "redirects to member homepage" do
        current_path.must_equal "/home"
      end
    end

    describe "with invalid inputs" do
      before do
        fill_out_form(
          'Email Address*' =>  'invalid',
          'Password'       => 'password',
          'First Name*'    => 'foo',
          'Last Name*'     => '',
          'Phone Number'   => 'invalid',
          'Zip Code*'      => 'invalid'
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
          "Phone number invalid is not a valid phone number"
        )
      end

      it "shows an error for invalid postal code" do
        page.must_have_content(
          "Zip code invalid is not a valid postal code"
        )a
        dddddkdkdkdkdkkdkdk    ;lkaj;lkj;lkj  dlass JoiningGroup < FeatureTest
  let(:group){ groups(:fanstatic_four) }

  describe "as a first-time user" do
    describe "viewing join page" do
      before { visit "/groups/#{group.id}/signup/" }

      it "has a title" do
        page.must_have_content group.name
      end

      it "has a description" do
        page.must_have_content group.description
      end

      it "has a call to action" do
        page.must_have_text "join"
      end

      it "has a 'join with email' button" do
        assert page.has_link('join with email', href: '/groups/#{group.id}/join/email')
      end
    end
  end

  describe "choosing email signup path" do
    let(:submissions_by_input_label) do
      {'Email Address*' => 'serious@person.com',
       'Password'       => 'password',
       'First Name*'    => 'Serious',
       'Last Name*'     => 'Person',
       'Zip Code*'      => '11111',
       'Phone Number'   => '111-111-1111',}
    end

    describe "viewing email signup form" do
      it "has inputs for contact info" do
        submissions_by_input_label.keys.each do |label|
          page.must_have_content label
        end
      end

      it "specifies required fields"
    end

    describe "submitting email signup form" do
      let(:input_groups){ CustomForm::INPUT_GROUPS.map{ |ig| form.send(ig) } }
      let(:person_count){ Person.count }
      let(:membership_count){ Membership.count }
      let(:new_member){ Person.last }

      before { person_count;  membership_count }

      describe "with no errors" do
        before do
          fill_out_form values_by_input(input_groups)
          click_button form.submit_text
        end

        it "creates a new person" do
          Person.count.must_equal person_count + 1
        end

        it "creates a new membership" do
          Membership.count.must_equal membership_count + 1
        end

        it "stores persons's contact info" do
          [:email_addresses, :phone_numbers, :personal_addresses].each do |msg|
            new_member.reload.send(msg).first.primary?.must_equal true
          end
        end

        it "redirects to member homepage" do
          current_path.must_equal "/home"
        end
      end

      describe "with invalid inputs" do
        before do
          fill_out_form(
            'Email Address*' =>  'invalid',
            'Password'       => 'password',
            'First Name*'    => 'foo',
            'Last Name*'     => '',
            'Phone Number'   => 'invalid',
            'Zip Code*'      => 'invalid'
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
            "Phone number invalid is not a valid phone number"
          )
        end

        it "shows an error for invalid postal code" do
          page.must_have_content(
            "Zip code invalid is not a valid postal code"
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

          # fill out form!
          visit "/groups/#{fancy_group.id}/join/email"
          fill_out_form(
            'First Name*'    => 'Serious',
            'Last Name*'     => 'Person',
            'Email Address*' => 'serious@person.com',
            'Zip Code*'      => '11111',
            'Phone Number'   => '111-111-1111'
          )
          click_button form.submit_text
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
