require 'net/http'
require 'json'
# require 'sparsify'

class NpiDownload

  attr_accessor :npi_number,
                :enumeration_type,
                :taxonomy_description,
                :first_name,
                :last_name,
                :organization_name,
                :address_purpose,
                :city,
                :state,
                :postal_code,
                :country_code,
                :limit,
                :skip

  def get_results
    
    @result_count = 0

    @results = []

    json_response = self.query

    while true

      if json_response['result_count'] == 0
        self.skip= nil
        break
      end

      @result_count += json_response['result_count']

      @results << json_response['results']

      self.skip= @result_count

      json_response = self.query

      print "#"

    end

    puts "\nFound #{@result_count} results."
    return @results

  end

  def build_results_hash(results)

    @npi_array = []

    results.each do |result|

      result.each do |nested_result|

        @npi_hash = {}

        @npi_hash['npi'] = nested_result['number']
        @npi_hash['last_updated'] = nested_result['basic']['last_updated']
        @npi_hash['status'] = nested_result['basic']['status']
        @npi_hash['credential'] = nested_result['basic']['credential']
        @npi_hash['first_name'] = nested_result['basic']['first_name']
        @npi_hash['middle_name'] = nested_result['basic']['middle_name']
        @npi_hash['last_name'] = nested_result['basic']['last_name']
        @npi_hash['name'] = nested_result['basic']['name']
        @npi_hash['gender'] = nested_result['basic']['gender']

        nested_result['addresses'].each do |address|

          address['address_purpose'] == "LOCATION" ? key_prefix = 'location_' : key_prefix = 'mailing_'

          @npi_hash["#{key_prefix}telephone_number"] = address['telephone_number']
          @npi_hash["#{key_prefix}fax_number"] = address['fax_number']
          @npi_hash["#{key_prefix}address_1"] = address['address_1']
          @npi_hash["#{key_prefix}address_2"] = address['address_2']
          @npi_hash["#{key_prefix}city"] = address['city']
          @npi_hash["#{key_prefix}state"] = address['state']
          @npi_hash["#{key_prefix}postal_code"] = address['postal_code']
        
        end

        nested_result['taxonomies'].each do |taxonomy|

          if taxonomy['primary'] == true

            @npi_hash['taxonomy_code'] = taxonomy['code']
            @npi_hash['taxonomy_description'] = taxonomy['desc']

          end

          @npi_array.push(@npi_hash)
        
        end

      end

    end

    return @npi_array.uniq! { |value| value['npi'] }

  end

  def build_uri

    URI(
        "https://npiregistry.cms.hhs.gov/api/?"\
        "number=#{npi_number}"\
        "&enumeration_type=#{enumeration_type}"\
        "&taxonomy_description=#{taxonomy_description}"\
        "&first_name=#{first_name}"\
        "&last_name=#{last_name}"\
        "&organization_name=#{organization_name}"\
        "&address_purpose=#{address_purpose}"\
        "&city=#{city}"\
        "&state=#{state}"\
        "&postal_code=#{postal_code}"\
        "&country_code=#{country_code}"\
        "&limit=#{limit}"\
        "&skip=#{skip}"
      )
    
  end

  def query

    JSON.parse(Net::HTTP.get(self.build_uri))

  end

end