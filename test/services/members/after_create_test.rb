require_relative "../../test_helper"

class Members::AferCreateTest < ActiveSupport::TestCase
  let(:person){ double(Person) }
  let(:group){ double(Group) }
  let(:mailer_double){ double(deliver_later: nil) }

  describe ".call" do
    before do
      allow(GroupMailer).to receive(:join_group_email).and_return(mailer_double)
      allow(GoogleGroupJobs::AddNewMemberToGroupJob).to receive(:perform_later).and_return(nil)
    end

    describe "when gsuite toggle off" do
      before do
        allow(StaticFeatureToggle).to receive(:on?).and_return(false)
        Members::AfterCreate.call(member: person, group: group)
      end

      it "enqueues a welcome email" do
        expect(GroupMailer).to have_received(:join_group_email)
        expect(mailer_double).to have_received(:deliver_later)
      end

      it "does not enqueue a job to add person to google group" do
        expect(GoogleGroupJobs::AddNewMemberToGroupJob)
          .not_to have_received(:perform_later)
      end
    end

    describe "when gsuite feature toggled on " do
      before do
        allow(StaticFeatureToggle).to receive(:on?).and_return(true)
        Members::AfterCreate.call(member: person, group: group)
      end

      it "enques a job to add person to google group" do
        expect(GoogleGroupJobs::AddNewMemberToGroupJob)
          .to have_received(:perform_later)
          .with(member: person, group: group)
      end
    end
  end
end
