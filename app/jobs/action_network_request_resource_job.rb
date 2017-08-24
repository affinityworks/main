class ActionNetworkRequestResourceJob < ApplicationJob
  queue_as :default

  def perform(client,group,resource_class)
    puts "in perform #{next_uri}"
    logs = []
    logger.info "Api::ActionNetwork::Resource Delayed Job#import! from #{next_uri}"
    
    retries ||= 0

    
    client.get(uri: uri, as: 'application/json') do |request|
      request['OSDI-API-TOKEN'] = group.an_api_key
    end

    yield(resource) if block_given?
      resource
    rescue => e
    NewRelic::Agent.notice_error(e)
    logger.error e.inspect
    retry if (retries += 1) < 3
    nil
  end
end
