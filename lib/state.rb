module Synacrb
    class State
        def initialize
            @channels = {}
            @groups   = {}
            @users    = {}
        end
        def channels
            @channels
        end
        def groups
            @groups
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
            elsif packet.instance_of? Common::GroupDeleteReceive
                unless packet.inner.instance_of? Common::Group
                    packet.inner = Common::Group.new(*packet.inner)
                end
                for id in @groups.each_key
                    if @groups[id].pos > packet.inner.pos
                        @groups[id].pos -= 1
                    end
                end
                @groups.delete packet.inner.id
            elsif packet.instance_of? Common::GroupReceive
                unless packet.inner.instance_of? Common::Group
                    packet.inner = Common::Group.new(*packet.inner)
                end
                if packet.new
                    unless @groups[packet.inner.id].nil?
                        pos = @groups[packet.inner.id].pos

                        if packet.inner.pos > pos
                            for id in @groups.each_key
                                if @groups[id].pos > pos && @groups[id].pos <= packet.inner.pos
                                    @groups[id].pos -= 1
                                end
                            end
                        elsif packet.inner.pos < pos
                            for group in @groups.each_key
                                if @groups[id].pos >= packet.inner.pos && @groups[id].pos < pos
                                    @groups[id].pos += 1
                                end
                            end
                        end
                    else
                        for group in @groups.each_key
                            if @groups[id].pos >= packet.inner.pos
                                @groups[id].pos += 1
                            end
                        end
                    end
                end
                @groups[packet.inner.id] = packet.inner
            end
        end
    end
end
