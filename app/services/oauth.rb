class Oauth
  OAUTH_TYPES = %w[google facebook].freeze
  
  class << self
    def decrypt_token(oauth_hash)
      if token = oauth_hash.dig('credentials', 'token')
        OmniAuth::AuthHash.new(
          oauth_hash.merge(
            'credentials' => {
              'token' => Crypto.decrypt_with_nacl_secret(token)
            }
          )
        )
      end
    end

    def encrypt_token(auth)
      auth.merge(
        'credentials' => {
          'token' => Crypto.encrypt_to_nacl_secret(auth.credentials.token)
        }
      )
    end

    def is_oauth_signup?(signup_mode)
      OAUTH_TYPES.include? signup_mode
    end
  end
end