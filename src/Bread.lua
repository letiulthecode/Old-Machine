local discordia = require "discordia"
local Bread = {}

local up = string.upper
local rep = string.rep
local form = string.format
local date = os.date
local time = os.time
local insert = table.insert

Bread.Color = {
    esc = "\027",
    reset = "[0m",
    black = '[30m',
    red = '[31m',
    green = '[32m',
    yellow = '[33m',
    blue = '[34m',
    magenta = '[35m',
    cyan = '[36m',
    white = '[37m',
}


local client = discordia.Client()
Bread.__init = Bread
discordia.extensions()

local function LockArray(tbl)
    if not tbl then tbl = {} end
    return setmetatable(tbl, {
      __newindex = function(table, key, value)
            error("Attempt to modify a value in a locked array")
        end,
      __metatable = false
    })
end

local function UnLockArray(tbl)
    if not tbl then tbl = {} end
    return setmetatable(tbl, {
        __metatable = false
    })
end

---Declare token and prefix
function Bread:NewClient(token, prefix)
    self.Commands = {}
    self.Data = {}
    self.Data.Token = token
    self.Data.Prefix = prefix

    LockArray(self.Data)

    return self
end

function Bread.Discordia()
    return discordia
end

function Bread.Client()
    return client
end

--Checks if str starts with ptrn
function Bread.StartsWith(str, ptrn)
    return str:sub(1, #ptrn) == ptrn
end

--Log in the output
function Bread.Log(lvl, lvlcolor, msg)
    return form(date("%F %T", time()).." | \27"..lvlcolor.."[%s]\27[0m"..rep(" ", #lvl).."| %s ", up(lvl), msg)
end

--Easy bulk-delete method
function Bread.BulkDel(message, amount)
    local cha = message.guild:getChannel(message.channel.id)
    cha:bulkDelete(message.channel:getMessagesBefore(message.id, amount))
end

--Wait for some secodns to a callback start
function Bread.WaitFor(seconds, callback)
    discordia.Clock():waitFor("", seconds * 1000)
    if type(callback) == "function" then
        callback()
    else
        error("Callback must be a function")
    end
end

--Makes a new command
function Bread:Command(cmd, desc, func)
    local prefix = self.Data.Prefix
    self.Commands[prefix..cmd] = {
        desc = desc,
        exec = function(message)
            if type(func) == "function" then
                func(message)
            else
                error("The func param needs be function type.")
            end
        end
    }
    return self
end

--Makes a Help command
function Bread:Help(embedtoggle)
    Bread:Command("help", "Displays all commands", function(message)
    if embedtoggle == false then
            local output = {}
            for word, tbl in pairs(Bread.Commands) do
                insert(output, word .. " - " .. tbl.desc .. "\n")
            end

            message:reply("Help\n"..table.concat(output, "\n\n"))
    elseif embedtoggle == true then
        local output = {}
        for word, tbl in pairs(Bread.Commands) do
            insert(output, word .. " - " .. tbl.desc .. "\n")
        end

        message:reply{
            embed = {
                title = "Help",
                description = table.concat(output, "\n")
            }
        }
    else
        error("You need toggle if the help message will be an embed or not.")
    end
    end)
end

--Starts Everything
function Bread:Eat()
    client:on("ready", function()
        print(Bread.Log("info", Bread.Color.green, client.user.username.." Is online!"))
    end)

    client:on("messageCreate", function(message)
        if message.author.bot then return end
        local args = message.content:split(" ")

	    local command = self.Commands[args[1]]
	    if command then
		    command.exec(message)
        end
    end)

    client:run("Bot "..self.Data.Token)
    LockArray(self)
end

return Bread