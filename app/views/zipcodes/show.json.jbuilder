json.extract! @zipcode, :zipcode, :lat, :long
json.url zipcode_url(@zipcode, format: :json)
