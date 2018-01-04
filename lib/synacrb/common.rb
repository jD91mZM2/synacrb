module Synacrb
    module Common
        DEFAULT_PORT = 8439
        RSA_LENGTH   = 3072
        TYPING_TIMEOUT = 10

        LIMIT_USER_NAME = 128
        LIMIT_CHANNEL_NAME = 128
        LIMIT_MESSAGE = 16384

        LIMIT_BULK = 64

        ERR_ALREADY_EXISTS     = 0
        ERR_LIMIT_REACHED      = 1
        ERR_LOGIN_BANNED       = 2
        ERR_LOGIN_BOT          = 3
        ERR_LOGIN_INVALID      = 4
        ERR_MAX_CONN_PER_IP    = 5
        ERR_MISSING_FIELD      = 6
        ERR_MISSING_PERMISSION = 7
        ERR_SELF_PM            = 8
        ERR_UNKNOWN_BOT        = 9
        ERR_UNKNOWN_CHANNEL    = 10
        ERR_UNKNOWN_MESSAGE    = 11
        ERR_UNKNOWN_USER       = 12

        PERM_READ              = 1
        PERM_WRITE             = 1 << 1

        PERM_MANAGE_CHANNELS   = 1 << 2
        PERM_MANAGE_MESSAGES   = 1 << 3
        PERM_MANAGE_MODES      = 1 << 4

        PERM_ALL = PERM_READ | PERM_WRITE | PERM_MANAGE_CHANNELS | PERM_MANAGE_MESSAGES | PERM_MANAGE_MODES;

        Channel = Struct.new(:default_mode_bot, :default_mode_user, :id, :name, :private)
        Message = Struct.new(:author, :channel, :id, :text, :timestamp, :timestamp_edit)
        User = Struct.new(:admin, :ban, :bot, :id, :modes, :name)

        # CLIENT PACKETS
        PACKET_ERR_ID               = 0;
        PACKET_RATELIMIT_ID         = 1;
        PACKET_CHANNELCREATE_ID     = 2;  ChannelCreate = Struct.new(:default_mode_bot, :default_mode_user, :name, :recipient)
        PACKET_CHANNELDELETE_ID     = 3;  ChannelDelete = Struct.new(:id)
        PACKET_CHANNELUPDATE_ID     = 4;  ChannelUpdate = Struct.new(:inner)
        PACKET_COMMAND_ID           = 5;  Command = Struct.new(:args, :recipient)
        PACKET_LOGIN_ID             = 6;  Login = Struct.new(:bot, :name, :password, :token)
        PACKET_LOGINUPDATE_ID       = 7;  LoginUpdate = Struct.new(:name, :password_current, :password_new, :reset_token)
        PACKET_MESSAGECREATE_ID     = 8;  MessageCreate = Struct.new(:channel, :text)
        PACKET_MESSAGEDELETE_ID     = 9;  MessageDelete = Struct.new(:id)
        PACKET_MESSAGEDELETEBULK_ID = 10; MessageDeleteBulk = Struct.new(:channel, :ids)
        PACKET_MESSAGELIST_ID       = 11; MessageList = Struct.new(:after, :before, :channel, :limit)
        PACKET_MESSAGEUPDATE_ID     = 12; MessageUpdate = Struct.new(:id, :text)
        PACKET_TYPING_ID            = 13; Typing = Struct.new(:channel)
        PACKET_USERUPDATE_ID        = 14; UserUpdate = Struct.new(:admin, :ban, :channel_mode, :id)

        # SERVER PACKETS
        PACKET_CHANNELDELETERECEIVE_ID = 15; ChannelDeleteReceive = Struct.new(:inner)
        PACKET_CHANNELRECEIVE_ID       = 16; ChannelReceive = Struct.new(:inner)
        PACKET_COMMANDRECEIVE_ID       = 17; CommandReceive = Struct.new(:args, :author)
        PACKET_LOGINSUCCESS_ID         = 18; LoginSuccess = Struct.new(:created, :id, :token)
        PACKET_MESSAGEDELETERECEIVE_ID = 19; MessageDeleteReceive = Struct.new(:id)
        PACKET_MESSAGELISTRECEIVED_ID  = 20; MessageListReceived = Struct.new(:id)
        PACKET_MESSAGERECEIVE_ID       = 21; MessageReceive = Struct.new(:inner, :new)
        PACKET_TYPINGRECEIVE_ID        = 22; TypingReceive = Struct.new(:author, :channel)
        PACKET_USERRECEIVE_ID          = 23; UserReceive = Struct.new(:inner)

        def self.encode_u16(input)
            (input >> 8).chr + (input % 256).chr
        end
        def self.decode_u16(input)
            (input[0].ord << 8) + input[1].ord
        end

        def self.packet_from_id(id)
            case id
            when PACKET_CHANNELCREATE_ID
                ChannelCreate
            when PACKET_CHANNELDELETE_ID
                ChannelDelete
            when PACKET_CHANNELUPDATE_ID
                ChannelUpdate
            when PACKET_COMMAND_ID
                Command
            when PACKET_LOGIN_ID
                Login
            when PACKET_LOGINUPDATE_ID
                LoginUpdate
            when PACKET_MESSAGECREATE_ID
                MessageCreate
            when PACKET_MESSAGEDELETE_ID
                MessageDelete
            when PACKET_MESSAGEDELETEBULK_ID
                MessageDeleteBulk
            when PACKET_MESSAGELIST_ID
                MessageList
            when PACKET_MESSAGEUPDATE_ID
                MessageUpdate
            when PACKET_TYPING_ID
                Typing
            when PACKET_USERUPDATE_ID
                UserUpdate
            when PACKET_CHANNELDELETERECEIVE_ID
                ChannelDeleteReceive
            when PACKET_CHANNELRECEIVE_ID
                ChannelReceive
            when PACKET_COMMANDRECEIVE_ID
                CommandReceive
            when PACKET_LOGINSUCCESS_ID
                LoginSuccess
            when PACKET_MESSAGEDELETERECEIVE_ID
                MessageDeleteReceive
            when PACKET_MESSAGELISTRECEIVED_ID
                MessageListReceived
            when PACKET_MESSAGERECEIVE_ID
                MessageReceive
            when PACKET_TYPINGRECEIVE_ID
                TypingReceive
            when PACKET_USERRECEIVE_ID
                UserReceive
            end
        end
        def self.packet_to_id(packet)
            if packet.instance_of? ChannelCreate
                PACKET_CHANNELCREATE_ID
            elsif packet.instance_of? ChannelDelete
                PACKET_CHANNELDELETE_ID
            elsif packet.instance_of? ChannelUpdate
                PACKET_CHANNELUPDATE_ID
            elsif packet.instance_of? Command
                PACKET_COMMAND_ID
            elsif packet.instance_of? Login
                PACKET_LOGIN_ID
            elsif packet.instance_of? LoginUpdate
                PACKET_LOGINUPDATE_ID
            elsif packet.instance_of? MessageCreate
                PACKET_MESSAGECREATE_ID
            elsif packet.instance_of? MessageDelete
                PACKET_MESSAGEDELETE_ID
            elsif packet.instance_of? MessageDeleteBulk
                PACKET_MESSAGEDELETEBULK_ID
            elsif packet.instance_of? MessageList
                PACKET_MESSAGELIST_ID
            elsif packet.instance_of? MessageUpdate
                PACKET_MESSAGEUPDATE_ID
            elsif packet.instance_of? PrivateMessage
                PACKET_PRIVATEMESSAGE_ID
            elsif packet.instance_of? Typing
                PACKET_TYPING_ID
            elsif packet.instance_of? UserUpdate
                PACKET_USERUPDATE_ID
            elsif packet.instance_of? ChannelDeleteReceive
                PACKET_CHANNELDELETERECEIVE_ID
            elsif packet.instance_of? ChannelReceive
                PACKET_CHANNELRECEIVE_ID
            elsif packet.instance_of? CommandReceive
                PACKET_COMMANDRECEIVE_ID
            elsif packet.instance_of? LoginSuccess
                PACKET_LOGINSUCCESS_ID
            elsif packet.instance_of? MessageDeleteReceive
                PACKET_MESSAGEDELETERECEIVE_ID
            elsif packet.instance_of? MessageListReceived
                PACKET_MESSAGELISTRECEIVED_ID
            elsif packet.instance_of? MessageReceive
                PACKET_MESSAGERECEIVE_ID
            elsif packet.instance_of? PMReceive
                PACKET_PMRECEIVE_ID
            elsif packet.instance_of? TypingReceive
                PACKET_TYPINGRECEIVE_ID
            elsif packet.instance_of? UserReceive
                PACKET_USERRECEIVE_ID
            end
        end
    end
end
