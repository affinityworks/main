require_relative "../test_helper"

class AggregateErrorTest < ActiveSupport::TestCase

  describe "#initialize" do
    it "returns an empty array if no errors" do
      group = Group.new
      AggregateError.new(objects: [group]).errors.must_equal []
    end

    it "returns an array of messages for one object" do
      group = Group.new
      group.errors.add(:name)
      group.errors.add(:description)
      AggregateError.new(objects: [group]).errors.must_equal ["Name is invalid", "Description is invalid"]
    end

    it "returns an array of messages for multiple objects" do
      group = Group.new
      group.errors.add(:name)
      person = Person.new
      person.errors.add(:given_name)
      AggregateError.new(objects: [group, person]).errors.must_equal ["Name is invalid", "Given name is invalid"]
    end
  end
end