require_relative "../../test_helper"

class BulkImportTest < ActiveSupport::TestCase
  describe ".bulk_import_members" do
    let(:group){groups(:fantastic_four) }
    let(:person_count){ Person.count }

    describe "with correctly formatted csv" do
      let(:csv) do
        "first_name,last_name,email,zip_code,phone\n" +
          "alice,foo,alice@anarchist.website,11111,222-222-2222\n" +
          "bob,foo,bob@anarchist.website,11111,222-222-2222,\n" +
          "carla,foo,carla@anarchist.website,11111,222-222-2222,\n"
      end

      before do
        person_count
        group.bulk_import_members(csv)
      end

      it "creates a person for each row" do
        Person.count.must_equal person_count + 3
      end

      it "makes each person a member of group" do
        Person.last(3).each do |person|
          person.is_member_of?(group).must_equal true
        end
      end

      it "does not create passwords for any person" do
        Person.last(3).each do |person|
          person.encrypted_password.must_be_empty
        end
      end

      it "stores contact info for each person" do
        Person.last(3).each do |person|
          [:primary_phone_number,
           :primary_email_address,
           :primary_personal_address
          ].each do |info|
            person.send(info).wont_be_nil
          end
        end
      end
    end

    describe "with omitted optional field" do
      let(:csv) do
        "first_name,last_name,email,zip_code,phone\n" +
          "alice,foo,alice@anarchist.website,11111,\n"
      end

      it "creates a person" do
        assert_difference ->{Person.count}, 1 do
          group.bulk_import_members(csv)
        end
      end
    end

    describe "with incorrectly formatted rows" do
      let(:csv) do
        "first_name,last_name,email,zip_code,phone\n" +
          # valid
          "alice,foo,alice@anarchist.website,11111,222-222-2222\n" +
          invalid_rows
      end

      let(:invalid_rows) do
        # missing first name
        ",foo,blah@anarchist.website,11111,222-222-2222\n" +
          # missing last name
          "alice,,blah2@anarchist.website,11111,222-222-2222\n" +
          # invalid email
          "bob,foo,invalid,11111,222-222-2222,\n" +
          # missing email
          "bob,foo,,11111,222-222-2222,\n" +
          # invalid zip
          "carla,foo,carla@anarchist.website,invalid,222-222-2222,\n" +
          # missing zip
          "carla,foo,carla@anarchist.website,,222-222-2222,\n" +
          # invalid phone
          "carla,foo,carla@anarchist.website,11111,invalid,\n"
      end

      it "imports correctly formatted rows" do
        assert_difference ->{Person.count}, 1 do
          begin
            group.bulk_import_members(csv)
          rescue
          end
        end
      end

      it "raises an error including incorrectly formatted rows" do
        ->{ group.bulk_import_members(csv) }
          .must_raise "#{BulkImport::MALFORMED_ROWS_MSG} #{invalid_rows}"
      end
    end

    describe "with incorrectly formatted headers" do
      let(:csv){ "foo,bar\nbaz,bam" }

      it "raises an error describing formatting errors" do
        ->{ group.bulk_import_members(csv) }
          .must_raise BulkImport::INVALID_HEADER_MSG
      end

      it "imports no people" do
        assert_no_difference ->{Person.count}, 0 do
          begin
            group.bulk_import_members(csv)
          rescue
          end
        end
      end
    end
  end
end
