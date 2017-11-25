module Synacrb
    # Encrypt `input` with `rsa` instance.
    # The difference between just encrypting it normally
    # is that this has a larger max-length and is
    # following the standard synac format.
    def self.encrypt(input, rsa)
        cipher = OpenSSL::Cipher.new "AES-256-CBC"
        cipher.encrypt
        key = cipher.random_key
        iv  = cipher.random_iv

        encrypted_aes = cipher.update(input) + cipher.final
        size_aes = encrypted_aes.bytesize

        keyiv = key + iv
        encrypted_rsa = rsa.public_encrypt keyiv
        size_rsa = encrypted_rsa.bytesize

        Common.encode_u16(size_rsa) +
            Common.encode_u16(size_aes) +
            encrypted_rsa +
            encrypted_aes
    end

    # Decrypt `input` with `rsa` instance.
    # The difference between just decrypting it normally
    # is that this has a larger max-length and is
    # following the standard synac format.
    def self.decrypt(input, rsa)
        size_rsa = Common.decode_u16(input.byteslice(0, 2));
        size_aes = Common.decode_u16(input.byteslice(2, 4));

        input = input.byteslice(4, input.bytesize)

        keyiv = rsa.private_decrypt input.byteslice(0, size_rsa)

        cipher = OpenSSL::Cipher.new "AES-256-CBC"
        cipher.decrypt
        cipher.key = keyiv.byteslice(0, 32)
        cipher.iv  = keyiv.byteslice(32, 32+16)
        cipher.update(input.byteslice(size_rsa, input.bytesize)) + cipher.final
    end
end
