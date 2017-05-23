class Facebook::ApiAgent
  include HTTParty

  HOST='https://graph.facebook.com'
  API_VERSION='v2.9'
  SUCCESS = 200

  base_uri  "#{HOST}/#{API_VERSION}"

  def get(endpoint, options)
    response = self.class.get(endpoint, query: options)
    parsed_response = response.parsed_response

    if response.code == SUCCESS
      parsed_response
    else
      raise FacebookRequestError.new(parsed_response['error']['message'])
    end
  end

  class FacebookRequestError < StandardError;  end
end
