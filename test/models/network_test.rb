require_relative '../test_helper'

class NetworkTest < ActiveSupport::TestCase
  let(:network){ networks(:swing_left_network) }
  let(:the_avengers){ networks(:the_avengers) }

  describe "associations"do
    specify { network.members.first.must_be_instance_of Group }
  end

  describe "validations" do
    it "forbids dupe names" do
      refute Network.new(name: network.name).valid?
    end

    it "forbids changing name from original value" do
      network.assign_attributes(name: "new name")
      refute network.valid?
    end
  end

  describe "class methods" do

    it "finds a network by snakecase name" do
      Network.find_by_snakecase_name("the_avengers").
        must_equal the_avengers
    end

    describe "importing a gsuite key" do
      describe "with valid json filename" do
        after { FileUtils.rm_r the_avengers.credentials_dir }

        it "writes gsuite key to json file in the correct (md5 hash) path" do
          fixture_path = "test/fixtures/files/the_avengers_google_gsuite_key.json"
          imported_path = Network.import_gsuite_key(fixture_path)

          imported_path.must_equal the_avengers.google_gsuite_key_path
          read_json(imported_path).must_equal(read_json(fixture_path))
        end
      end

      describe "with invalid json filename" do
        it "raises usage error" do
          assert_raises RuntimeError do
            Network.import_gsuite_key("foobar")
          end
        end
      end
    end
  end

  describe "instance methods" do

    it "returns an md5 hash of the network's snakecased name" do
      the_avengers.name_as_md5_hash.
        must_equal "a8abe5cf472eeb43f9df921eadf882e2"
    end

    it "returns the path to the network's credentials directory" do
      the_avengers.credentials_dir.
        must_equal "lib/network_credentials/" +
                   "a8abe5cf472eeb43f9df921eadf882e2"
    end

    it "returns the path to the network's google gsuite key" do
      the_avengers.google_gsuite_key_path.
        must_equal "lib/network_credentials/" +
                   "a8abe5cf472eeb43f9df921eadf882e2/" +
                   "google_gsuite_key.json"
    end
  end
end
