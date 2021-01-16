-- Machine is a Command Manager, a dependency for this bot

local discordia = require "discordia"
local class = discordia.class
local client = discordia.Client()
local Machine = class("Machine")
discordia.extensions()

CMD = {}

AliasCMD = {}

--// Method Section
--New Commands
function Machine:__init(name, handle)
    self.name = name
    self.handle = handle
    
    return self
end

function Machine:NewDesc(desc)
    self.desc = desc

    return self
end

function Machine:NewCategory(cat)
    self.category = cat

    return self
end

function Machine:NewAlias(alias)
    AliasCMD[alias] = self.name

    return self
end

--Get Commands

function Machine:GetName()
    return self.name
end

function Machine:GetDesc()
    return (self.desc ~= nil and self.desc or nil)
end

function Machine:GetCat()
    return (self.category ~= nil and self.category or nil)
end

function Machine:Execute(...)
    return self.handle(...)
end

--// Misc Section
function GetAllCmds()
    return CMD
end

function IsReady()
    client:on("ready", function()
        print(os.date("%F @ %T", os.time()).."| [MACHINE] | "..client.user.username.." Is online!")
    end)
end

function ExistCmd(cmd)
    return (CMD[cmd] ~= nil)
end
