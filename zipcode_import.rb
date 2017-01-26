require 'CSV'
CSV::Converters[:blank_to_nil] = lambda do |field|
  field && field.empty? ? nil : field
end

File.open('./output.rb', 'w') { |file|
  CSV.foreach("./public/democrats/app/zips/free-zipcode-database-Primary.csv", :headers => true, :header_converters => :symbol, :converters => [ :blank_to_nil]) do |row|
    #puts row[0].class

    if row[5] && row[6] then
      file.write("Zipcode.create(zipcode: \'#{row[0]}\', zipcode_type: \'#{row[1]}\', city: \'#{row[2]}\', state: \'#{row[3]}\', location_type: \'#{row[4]}\', lat: #{row[5]}, long: #{row[6]}, location: \'#{row[7]}\', decommisioned: #{row[8]}, tax_returns_filed: #{row[9].nil? ? 0 : row[9]}, estimated_population: \'#{row[10]}\', total_wages: \'#{row[11]}\')
      ")
    end
  end
}
