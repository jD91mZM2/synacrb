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
    end
end
