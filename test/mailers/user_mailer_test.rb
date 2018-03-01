class OrganizerMailerTest < ActionMailer::TestCase

  describe "new_subgroup_email" do
    let(:organizer){ people(:organizer) }
    let(:subgroup){ groups(:one) }
    let(:signup_form){ forms(:group_signup) }
    let(:mail){ OrganizerMailer.new_subgroup_email(organizer, subgroup, signup_form) }
    let(:body){ mail.body.raw_source }

    it "mentions subgroup in subject" do
      mail.subject.must_match subgroup.name
    end

    it "is addressed to organizer" do
      mail.to.must_equal organizer.primary_email_address
    end

    it "links to signup form" do
      body.must.match "/groups/#{group.id}/signup_forms/#{signup_form.id}/new"
    end

    it "links to organizer profile page" do
      body.must.match "/profile"
    end

    it "provides help email" do
      body.must.match "help@affinity.works"
    end
  end
end
