require_relative "../test_helper"

class GroupMailerTest < ActionMailer::TestCase

  describe "join_group_email" do
    let(:person){ people(:organizer) }
    let(:group){ groups(:subgroup) }
    let(:mail){ GroupMailer.join_group_email(person, group) }
    let(:body){ mail.body.raw_source }

    describe "email data frame" do
      it "mentions group in subject" do
        mail.subject.must_match group.name
      end

      it "is addressed to person" do
        mail.to.must_equal [person.primary_email_address]
      end
    end

    describe "email body" do
      it "mentions group name" do
        body.must_match group.name
      end

      it "greets person by first name" do
        body.must_match person.given_name
      end

      it "links to login page" do
        body.must_match "/admin/login"
      end

      it "links to dashboard" do
        body.must_match "/groups/#{group.id}/dashboard"
      end

      it "links to join page" do
        body.must_match "/groups/#{group.id}/join"
      end

      it "provides help email" do
        body.must_match "help@affinity.works"
      end
    end
  end
end
