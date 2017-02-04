json.primary address.primary?
json.address_type address.address_type
json.venue address.venue
json.venue address.venue
json.locality address.locality
json.region address.region
json.postal_code address.postal_code
json.country address.country
json.language address.language
json.status address.status
# Following http://opensupporter.github.io/osdi-docs/people.html
# json.occupation person.occupation

json.location do
  address.latitude
  address.location_accuracy
  address.longitude
end
