module Synacrb
    class State
        def initialize
            @channels = {}
            @users    = {}
        end
        def channels
            @channels
        end
        def users
            @users
        end
        def update(packet)
            if packet.instance_of? Common::ChannelDeleteReceive
                unless packet.inner.instance_of? Common::Channel
                    packet.inner = Common::Channel.new(*packet.inner)
                end
                @channels.delete packet.inner.id
            elsif packet.instance_of? Common::ChannelReceive
                unless packet.inner.instance_of? Common::Channel
                    packet.inner = Common::Channel.new(*packet.inner)
                end
                @channels[packet.inner.id] = packet.inner
            elsif packet.instance_of? Common::UserReceive
                unless packet.inner.instance_of? Common::User
                    packet.inner = Common::User.new(*packet.inner)
                end
                @users[packet.inner.id] = packet.inner
            end
        end

        # Search for a private channel with user
        def get_private_channel(user)
            @users.keys
                .map { |channel| @channels[channel] }
                .compact
                .find { |channel| channel.private }
            # the server doesn't send PMs you don't have access to
        end

        # Search for the recipient in a private channel
        def get_recipient(channel)
            if channel.private
                return nil
            end
            get_recipient_unchecked channel.id
        end

        # Search for the recipient in a private channel.
        # If the channel isn't private, it returns the first user it can find
        # that has a special mode in that channel.
        # So you should probably make sure it's private first.
        def get_recipient_unchecked(channel_id)
            @users.values
                .find { |user| user.modes.keys
                    .any { |channel| channel == channel_id }}
        end
    end
end
