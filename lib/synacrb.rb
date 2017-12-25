require "msgpack"
require "openssl"
require "socket"

require "synacrb/common"
require "synacrb/encrypter"
require "synacrb/state"
require "synacrb/version"

module Synacrb
    # Get the mode bitmask for a user in a channel
    def self.get_mode(channel, user)
        if user.bot
            return channel.default_mode_bot unless user.modes.include? channel.id
            user.modes[channel.id]
        else
            return channel.default_mode_user unless user.modes.include? channel.id
            user.modes[channel.id]
        end
    end

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

        # Sends the login packet with specific password.
        # Read the result with `read`.
        # Warning: Strongly disencouraged. Use tokens instead, when possible.
        def login_with_password(bot, name, password)
            send Common::Login.new(bot, name, password, nil)
        end

        # Sends the login packet with specific token.
        # Read the result with `read`.
        def login_with_token(bot, name, token)
            send Common::Login.new(bot, name, nil, token)
        end

        # Transmit a packet over the connection
        def send(packet)
            id = Common.packet_to_id(packet)
            data = [id, [packet.to_a]].to_msgpack

            @stream.write Common.encode_u16(data.length)
            @stream.write data
        end

        # Read a packet from the connection
        def read()
            size_a = @stream.read 2
            size = Common.decode_u16(size_a)
            data = @stream.read size

            data = MessagePack.unpack data
            class_ = Common.packet_from_id data[0]
            class_.new *data[1][0]
        end

        # Close the connection
        def close()
            send(Common::Close)
            @stream.close
        end
    end
end
