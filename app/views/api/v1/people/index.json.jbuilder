json.self do
  json.href api_v1_people_url
end

json.set! '_embedded' do
  json.set! 'osdi:people' do
    json.array! @people do |person|
      json.identifiers [osdi_identifier(person)]
      json.created_date person.created_at
      json.modified_date person.updated_at

      json.id person.id

      json.email_address do
        # OSDI specs many emails per person. Our current schema has one.
        json.array! Array.wrap(person.email_address) do |email_address|
          json.primary email_address.primary?
          json.address email_address.address
        end
      end

      json.postal_addresses do
        json.partial! 'api/v1/addresses/address', collection: person.personal_addresses, as: :address
      end

      if person.employer_address
        json.employer_address do
          json.partial! 'api/v1/addresses/address', address: person.employer_address, as: :address
        end
      end

      json.phone_numbers do
        json.partial! person.phone_numbers
      end

      json.profiles do
        json.partial! person.profiles
      end

      json.additional_name person.additional_name
      json.birthdate person.birthdate
      json.employer person.employer
      json.ethnicities person.ethnicities
      json.family_name person.family_name
      json.gender person.gender
      json.gender_identity person.gender_identity
      json.given_name person.given_name
      json.honorific_prefix person.honorific_prefix
      json.honorific_suffix person.honorific_suffix
      json.languages_spoken person.languages_spoken
      json.party_identification person.party_identification
      json.source person.source

      json.custom_fields person.custom_fields
    end
  end
end

json.set! '_links' do
  json.self do
    json.href api_v1_people_url
  end

  unless @people.first_page?
    json.previous do
      json.href api_v1_people_path(page: @people.prev_page)
    end
  end

  unless @people.last_page?
    json.next do
      json.href api_v1_people_path(page: @people.next_page)
    end
  end
end

json.page @people.current_page
json.total_pages @people.size
json.total_records @people.total_count
