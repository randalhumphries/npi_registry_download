require_relative '../../npi_download'

RSpec.describe "Querying the NPI Registry API" do


  it "returns results" do

    npi_request = NpiDownload.new

    npi_request.postal_code = '29909'

    response = npi_request.query

    expect(response['result_count']).to_not eq(0)

  end

  it "returns no more than the specified result limit" do

    npi_request = NpiDownload.new

    npi_request.postal_code = '29909'

    npi_request.limit = 10

    response = npi_request.query

    expect(response['result_count']).to be <= npi_request.limit

  end

end