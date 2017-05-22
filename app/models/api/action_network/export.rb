module Api::ActionNetwork::Export
  def export_single_resource(element, group, uri)
    client = representer_class.new(element)
    client.post(uri: uri, as: 'application/json') do |request|
      request['OSDI-API-TOKEN'] = group.an_api_key
    end
  end
end
