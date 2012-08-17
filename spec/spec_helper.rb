require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'fixtures'
  config.hook_into :webmock
  config.default_cassette_options = { serialize_with: :syck }
end
