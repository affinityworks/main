module Crypto
  class << self
    # () -> binary-encoded String
    def nacl_secret
      ENV['NACL_SECRET_KEY'].decode_hex.encode_chars
    end

    # String -> hex-encoded String
    def encrypt_to_nacl_secret(plaintext)
      RbNaCl::SimpleBox
        .from_secret_key(nacl_secret)
        .encrypt(plaintext)
        .bytes
        .encode_hex
    end

    # String -> String
    def decrypt_with_nacl_secret(cyphertext)
      RbNaCl::SimpleBox
        .from_secret_key(nacl_secret)
        .decrypt(cyphertext
                   .decode_hex
                   .encode_chars)
    end
  end

  class ::String
    # hex string -> array<byte>
    def decode_hex
      [self].pack("H*").bytes
    end

    # string -> hex string
    def encode_hex
      self.unpack("H*").first
    end

    # hex string -> base64-encoded string
    def hex_to_base64
      [[self].pack('H*')].pack("m0")
    end
  end

  class ::Array
    # array<byte> -> hex string
    def encode_hex
      encode_chars.encode_hex
    end

    # array<byte> -> plaintext string
    def encode_chars
      self.map{ |b| b.chr }.join
    end
  end
end
