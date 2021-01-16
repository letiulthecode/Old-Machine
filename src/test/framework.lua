local Frame = {}


Frame.Settings = {
    BotCanUseOwnCmds = false,
}

Frame.Container = {
    Discordia = {
        message = nil,
        client = nil
    };
    Bot = {
        prefix = nil,
        --token = nil
    }
}

local function IsType(name, val, typ)
    if type(val) ~= typ then
        error("Type of "..name.." needs be type "..typ.."!")
    end
end


local client = Frame.Container.Discordia.Client
local prefix = Frame.Container.Bot.prefix

function Frame.DefineDisc(message, client)
    Frame.Container.Discordia.message = message
    Frame.Container.Discordia.Client = client
end

function Frame.DefinePrefix(prefix)
    Frame.Container.Bot.prefix = prefix
end

function Frame.Cooldown(n)
    local message = Frame.Container.Discordia.message
    for i=1, n do
        if i ~= n then
            message:reply("Command in cooldown...")
        end
    end
end

function Frame.ActivateSettings()
    local settings = Frame.Settings
    local message = Frame.Container.Discordia.message
    if settings.BotCanUseOwnCmds == false then
        if message.author.bot then return end
    else
    end
end

function Frame.NewCommand(command, func)
    IsType("command", command, "string")
    IsType("func", func, "function")
    local message = Frame.Container.Discordia.message
    local prefix = Frame.Container.Bot.prefix
    if message.content == prefix..command then
        func()
    end
end

function Frame.StartsWithPrefix(sb)
    IsType("sub", sb, "string")
    local message = Frame.Container.Discordia.message
    local prefix = Frame.Container.Bot.prefix
    local msg = prefix..sb
    return message.content:sub(1, #msg) == msg
end 

function Frame.BulkDelete(msg)
    local message = Frame.Container.Discordia.message
    local prefix = Frame.Container.Bot.prefix
    local ms = prefix..msg
    local repla = string.gsub(message.content, ms.." ", "")
    if repla:match('1234567890') == false then return false end
        if message.member:hasPermission('manageMessages') then
            message:delete()
            local cha = message.guild:getChannel(message.channel.id)
            cha:bulkDelete(message.channel:getMessagesBefore(message.id, repla))
        else
            message:reply("Sorry <@!"..message.author.id.."> you dont have perms to clean!")
        end
end

function Frame.NewIfCommand(command, condition, func)
    IsType("command", command, "string")
    IsType("condition", condition, "string")
    IsType("func", func, "function")
    local message = Frame.Container.Discordia.message
    local prefix = Frame.Container.Bot.prefix
    local msg = prefix..command
    if condition == "StartsWithPrefix" then
        if message.content:sub(1, #msg) == msg then
            func()
        end
    end
end

function Frame.NewEmbed(title, desc, color, finame, fival, iline)
    IsType("title", title, "string")
    IsType("description", desc, "string")
    IsType("color", color, "number")
    IsType("field name", finame, "string")
    IsType("field value", fival, "string")
    IsType("inline", iline, "boolean")
    local embed = {
        title = title,
        description = desc,
        color = color,
        fields = {
            {name = finame, value = fival, inline = iline}
        }
    }
    return embed
end

return Frame