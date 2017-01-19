require_relative '../../npi_download'

RSpec.describe "Creating an NPI Registry Query" do

  it "is a type of NpiDownload" do

    npi_request = NpiDownload.new

    expect(npi_request).to be_kind_of(NpiDownload)

  end

  it "includes the NPI Registry URL in the uri host string" do

    npi_request = NpiDownload.new

    npi_request.postal_code = '29910'

    uri = npi_request.build_uri

    expect(uri.host).to include("npiregistry.cms.hhs.gov")

  end

  it "includes the specified query criteria in the API uri" do

    npi_request = NpiDownload.new

    npi_request.postal_code = '29910'

    uri = npi_request.build_uri

    expect(uri.query).to include(npi_request.postal_code)

  end

end