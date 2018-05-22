module BulkImport
  extend ActiveSupport::Concern
  VALID_HEADERS = ['first_name', 'last_name', 'email', 'zip_code', 'phone'].freeze
  REQUIRED_INDICES = (0..3)
  INVALID_HEADER_MSG = "Invalid CSV headers. Required: #{VALID_HEADERS}"
  MALFORMED_ROWS_MSG = "Failed to import the following malformed rows:\n"

  included do
    # String -> String|Error
    def bulk_import_members(csv_str)
      # USAGE FROM CONSOLE:
      # > group = Group.find(1)
      # > csv = <paste_csv_here>
      # > group.bulk_import_members(csv)
      headers, *rows = CSV.parse(csv_str)
      raise INVALID_HEADER_MSG unless headers == VALID_HEADERS
      invalid_rows = try_import_members(rows)
      raise "#{MALFORMED_ROWS_MSG} #{invalid_rows}" unless invalid_rows.empty?
      "ok"
    end

    private

    # Array<String> -> Array<String>
    def try_import_members(rows)
      # import valid rows, return array of invalid rows
      rows
        .map{ |row| try_import_member(row) }
        .compact
        .map{ |row| row.join(", ") }
        .join("\n")
    end

    # String -> String?
    def try_import_member(row)
      return unless well_formed?(row)
      person = Person.create(parse_attributes(row))
      person.valid? ? nil : row
    end

    # String -> Boolean
    def well_formed?(row)
      #binding.remote_pry
      REQUIRED_INDICES.map{ |i| row[i].present? }.all?
    end

    # Array<String> -> Hash<PersonAttributes>
    def parse_attributes(row)
      {
        given_name:  row[0],
        family_name: row[1],
        memberships_attributes: [
          { group: self, role: 'member' }
        ],
        email_addresses_attributes: [
          { primary: true, address: row[2] }
        ],
        personal_addresses_attributes: [
          { primary: true, postal_code: row[3] }
        ],
        phone_numbers_attributes: row[4] ? [
          { primary: true, number:  row[4]}
        ] : []
      }
    end
  end
end
