json.extract! @zipcode, :zipcode, :lat, :long, :city, :state, :location_type, :location, :estimated_population
json.url zipcode_url(@zipcode, format: :json)
