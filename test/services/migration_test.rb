class MigrationTest << ActiveSupport::TestCase

  describe "#update_networks" do

    describe "a new network w/ groups & organizers is added to config files" do
      it "creates the network"
      it "creates the group and adds it to the network"
      it "creates the organizers and adds them to the group"
      it "creates the email addresses and adds them to the organizers"
    end

    describe "a new group is added to an existing network in config files" do
      it "does not create a new network"
      it "creates the grou and adds it to the network"
    end

    describe "a new organizer is added to an existing group in the config files" do
      it "does not create a new network"
      it "does not create a new group"
      it "creates a new organizer and adds it to the group"
    end

    describe "a new email address is added to an existing organizer" do
      it "does not create a new network"
      it "does not create a new group"
      it "does not create a new organizer"
      it "creates a new email and adds it to the organizer"
    end
  end
end
