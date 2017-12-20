module Synacrb
    module Common
        DEFAULT_PORT = 8439
        RSA_LENGTH   = 3072
        TYPING_TIMEOUT = 10

        LIMIT_USER_NAME = 128
        LIMIT_CHANNEL_NAME = 128
        LIMIT_MESSAGE = 16384

        LIMIT_BULK = 64

        ERR_LIMIT_REACHED      = 1
        ERR_LOGIN_BANNED       = 2
        ERR_LOGIN_BOT          = 3
        ERR_LOGIN_INVALID      = 4
        ERR_MAX_CONN_PER_IP    = 5
        ERR_MISSING_FIELD      = 6
        ERR_MISSING_PERMISSION = 7
        ERR_NAME_TAKEN         = 8
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

        Channel = Struct.new(:default_mode_bot, :default_mode_user, :id, :name)
        Message = Struct.new(:author, :channel, :id, :text, :timestamp, :timestamp_edit)
        User = Struct.new(:admin, :ban, :bot, :id, :modes, :name)

        # CLIENT PACKETS
        PACKET_CLOSE_ID             = 0;  Close = Class.new
        PACKET_ERR_ID               = 1;
        PACKET_RATELIMIT_ID         = 2;
        PACKET_CHANNELCREATE_ID     = 3;  ChannelCreate = Struct.new(:default_mode_bot, :default_mode_user, :name)
        PACKET_CHANNELDELETE_ID     = 4;  ChannelDelete = Struct.new(:id)
        PACKET_CHANNELUPDATE_ID     = 5;  ChannelUpdate = Struct.new(:inner)
        PACKET_COMMAND_ID           = 6;  Command = Struct.new(:args, :recipient)
        PACKET_LOGIN_ID             = 7;  Login = Struct.new(:bot, :name, :password, :token)
        PACKET_LOGINUPDATE_ID       = 8;  LoginUpdate = Struct.new(:name, :password_current, :password_new, :reset_token)
        PACKET_MESSAGECREATE_ID     = 9;  MessageCreate = Struct.new(:channel, :text)
        PACKET_MESSAGEDELETE_ID     = 10; MessageDelete = Struct.new(:id)
        PACKET_MESSAGEDELETEBULK_ID = 11; MessageDeleteBulk = Struct.new(:channel, :ids)
        PACKET_MESSAGELIST_ID       = 12; MessageList = Struct.new(:after, :before, :channel, :limit)
        PACKET_MESSAGEUPDATE_ID     = 13; MessageUpdate = Struct.new(:id, :text)
        PACKET_PRIVATEMESSAGE_ID    = 14; PrivateMessage = Struct.new(:text, :recipient)
        PACKET_TYPING_ID            = 15; Typing = Struct.new(:channel)
        PACKET_USERUPDATE_ID        = 16; UserUpdate = Struct.new(:admin, :ban, :channel_mode, :id)

        # SERVER PACKETS
        PACKET_CHANNELDELETERECEIVE_ID = 17; ChannelDeleteReceive = Struct.new(:inner)
        PACKET_CHANNELRECEIVE_ID       = 18; ChannelReceive = Struct.new(:inner)
        PACKET_COMMANDRECEIVE_ID       = 19; CommandReceive = Struct.new(:args, :author)
        PACKET_LOGINSUCCESS_ID         = 20; LoginSuccess = Struct.new(:created, :id, :token)
        PACKET_MESSAGEDELETERECEIVE_ID = 21; MessageDeleteReceive = Struct.new(:id)
        PACKET_MESSAGERECEIVE_ID       = 22; MessageReceive = Struct.new(:inner, :new)
        PACKET_PMRECEIVE_ID            = 23; PMReceive = Struct.new(:author, :text)
        PACKET_TYPINGRECEIVE_ID        = 24; TypingReceive = Struct.new(:author, :channel)
        PACKET_USERRECEIVE_ID          = 25; UserReceive = Struct.new(:inner)

        def self.encode_u16(input)
            (input >> 8).chr + (input % 256).chr
        end
        def self.decode_u16(input)
            (input[0].ord << 8) + input[1].ord
        end

        def self.packet_from_id(id)
            case id
            when PACKET_CLOSE_ID
                Close
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
            when PACKET_PRIVATEMESSAGE_ID
                PrivateMessage
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
            when PACKET_MESSAGERECEIVE_ID
                MessageReceive
            when PACKET_PMRECEIVE_ID
                PMReceive
            when PACKET_TYPINGRECEIVE_ID
                TypingReceive
            when PACKET_USERRECEIVE_ID
                UserReceive
            end
        end
        def self.packet_to_id(packet)
            if packet.instance_of? Close
                PACKET_CLOSE_ID
            elsif packet.instance_of? ChannelCreate
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
