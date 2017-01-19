require 'csv'
require_relative 'npi_download'

npi = NpiDownload.new

def get_postal_code

  print "Enter the postal code for the NPI Registry search: "

  gets.chomp  
  
end

def search(object)

  object.build_results_hash(object.get_results)
  
end

puts "***NPI Registry Search/Download Utility***"

npi.postal_code = get_postal_code

puts "Searching the NPI Registry. Please wait..."

@search_results = search(npi)

if @search_results.count > 0

  puts "#{@search_results.count} values in the test array."

else

  puts "No results found. Exiting..."

  exit

end


print "Enter the full path to the destination CSV file: "

filename = gets.chomp

CSV.open(filename, "w") do |csv_file|

  puts "Saving results to the specified file. Please wait...\n"

  sleep(0.5)

  csv_file << @search_results.first.keys

  @search_results.each do |hash|

    csv_file << hash.values

  end

  puts "Results successfully saved to '#{filename}'."

end

