require "msgpack"
require "openssl"
require "socket"
require "synacrb/version"

module Synacrb
    class Session
        # Connect to the server
        def initialize(addr, hash, &callback)
            puts "1"
            tcp = TCPSocket.new addr, 8439
            puts "2"

            @hash = hash

            context = OpenSSL::SSL::SSLContext.new
            if callback.nil?
                callback = method(:verify_callback)
            end
            context.verify_callback = callback
            context.verify_mode = OpenSSL::SSL::VERIFY_PEER

            puts "5"
            @stream = OpenSSL::SSL::SSLSocket.new tcp, context
            @stream.connect
        end
        # OpenSSL verify callback used by initialize when optional callback argument isn't set.
        def verify_callback(_, cert)
            pem = cert.current_cert.public_key.to_pem
            sha256 = OpenSSL::Digest::SHA256.new
            hash = sha256.digest(pem).unpack("H*")

            hash[0].casecmp(@hash).zero?
        end



        # Close the connection
        def close()
            @stream.close
        end
    end
end
