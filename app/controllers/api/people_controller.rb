module Api
  class PeopleController < ApplicationController
    respond_to :json

    def index
      respond_to do |format|
        format.json do
          @people = Person.all
          render(json: {
            page: 1,
            per_page: @people.size,
            total_records: @people.size,
            self: {
              href: request.url
            },
            "_links": {
              "self": {
                "href": request.url
              }
            },
            "_embedded" => {
              "osdi:people" => [
                {
                  "email_addresses": [
                    {
                      "primary": true,
                      "address": nil
                    }
                  ],
                  "identifiers": [
                    "osdi:person-#{@people.first.id}"
                  ],
                  "id": @people.first.id,
                  "created_date": @people.first.created_at,
                  "modified_date": @people.first.updated_at,
                  "custom_fields": {},
                  "postal_addresses": [],
                  "phone_numbers": [],
                  "_embedded": {
                    "osdi:tags": []
                  }
                },
                "_links": {
                  "addresses": {
                    "href": "#{request.url}/#{@people.first.id}/addresses"
                  },
                  "question_answers": {
                    "href": "#{request.url}/#{@people.first.id}/question_answers"
                  },
                  "self": {
                    "href": "#{request.url}/#{@people.first.id}"
                  },
                  "osdi:tags": {
                    "href": "#{request.url}/#{@people.first.id}/tags"
                  }
                }
              ]
            }
          })
        end
      end
    end
  end
end
