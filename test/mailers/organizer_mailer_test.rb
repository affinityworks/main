require_relative "../test_helper"

class OrganizerMailerTest < ActionMailer::TestCase

  describe "new_subgroup_email" do
    let(:organizer){ people(:organizer) }
    let(:subgroup){ groups(:subgroup) }
    let(:signup_form){ forms(:group_signup) }
    let(:mail){ OrganizerMailer.new_subgroup_email(organizer, subgroup, signup_form) }
    let(:body){ mail.body.raw_source }

    it "mentions subgroup in subject" do
      mail.subject.must_match subgroup.name
    end

    it "is addressed to organizer" do
      mail.to.must_equal [organizer.primary_email_address]
    end

    it "links to signup form" do
      body.must_match "/groups/#{subgroup.id}/signup_forms/#{signup_form.id}/signups/new"
    end

    it "links to organizer profile page" do
      body.must_match "/profile"
    end

    it "provides help email" do
      body.must_match "help@affinity.works"
    end
  end
end
