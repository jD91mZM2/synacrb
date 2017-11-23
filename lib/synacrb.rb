require "packets.rb"

require "msgpack"
require "openssl"
require "socket"
require "synacrb/version"

module Synacrb
    class Session
        # Connect to the server
        def initialize(addr, hash, &callback)
            tcp = TCPSocket.new addr, 8439

            @hash = hash

            context = OpenSSL::SSL::SSLContext.new
            if callback.nil?
                callback = method(:verify_callback)
            end
            context.verify_callback = callback
            context.verify_mode = OpenSSL::SSL::VERIFY_PEER

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

        # Returns inner connection
        def inner_stream()
            @stream
        end

        # Transmit a packet over the connection
        def send(packet)
            id = Common.packet_to_id(packet)
            data = [id, [packet.to_a]].to_msgpack
            size1 = data.length >> 8
            size2 = data.length % 256

            @stream.write [size1, size2].pack("U*")
            @stream.write data
        end

        # Read a packet from the connection
        def read()
            size_a = @stream.read 2
            size = (size_a[0].ord << 8) + size_a[1].ord
            data = @stream.read size

            data = MessagePack.unpack data
            class_ = Common.packet_from_id data[0]
            class_.new *data[1][0]
        end

        # Close the connection
        def close()
            @stream.close
        end
    end
end
