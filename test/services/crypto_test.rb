require_relative "../test_helper"

class CryptoTest < ActiveSupport::TestCase

  describe "encryption" do

    it "retrieves the nacl secret key" do
      # don't worry! this is a dummy key that only exists in test environment!
      Crypto.nacl_secret.bytes
        .must_equal(("X\x8Ag\xA6\x12\xD7\xE0\x0E\x8D{\x93\xC9x/@\xF5\xD3J\x9F"+
                     "/\xE9\xEA\xFE@\xCA\xA4\x99\x10{$\xF5\xB2").bytes)

    end

    it "encrypts and decrypts a message using the nacl secret key" do
      plaintext = "UwlcA5KfBMIfSXx8dYmT"

      Crypto.decrypt_with_nacl_secret(
        Crypto.encrypt_to_nacl_secret(plaintext)
      ).must_equal plaintext
    end
  end

  describe "encoding" do
    describe "strings" do
      it "decodes a hex string to a byte array" do
        "49276d".decode_hex.must_equal [73, 39, 109]
        "49276d".decode_hex.must_equal [0b01001001, 0b00100111, 0b01101101]
      end

      it "encodes a string as a hex string" do
        "I'm".encode_hex.must_equal  "49276d"
      end

      it "transcodes a hex string to a base64 string" do
        "49276d".hex_to_base64.must_equal "SSdt"
      end
    end

    describe "byte arrays" do
      it "encodes a byte array as a hex string" do
        [73, 39, 109].encode_hex.must_equal "49276d"
        [0b01001001, 0b00100111, 0b01101101].encode_hex.must_equal "49276d"
      end

      it "encodes a byte array as a plaintext character string" do
        [73, 39, 109].encode_chars.must_equal "I'm"
        [0b01001001, 0b00100111, 0b01101101].encode_chars.must_equal "I'm"
      end
    end
  end
end
