require 'roar/json/hal'

class Api::EntryPointRepresenter < Roar::Decorator
  include Roar::JSON::HAL

  property :namespace
  property :osdi_version
  property :product_name
  property :vendor_name

  link :self do
    {
      href: '/api/v1',
      title: 'root API entry point'
    }
  end

  link 'docs' do
    {
      href: 'https://github.com/wufm/osdi-docs',
      title: 'Documentation'
    }
  end

  link 'osdi:people' do
    '/api/v1/people'
  end
end
