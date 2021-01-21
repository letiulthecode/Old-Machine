local Bread = require "./Bread"
local discordia = Bread.Discordia()
local client = Bread.Client()

Bread:NewClient("Token.", ">")

local prefix = Bread.Data.Prefix
local warns = 0

Bread:Command("ping", "Responds with a funny gif", function (message)
    message:reply('https://tenor.com/view/cats-ping-pong-gif-8942945')
end)

Bread:Command("coolness", "Check coolness of a user", function (message)
    local msg = prefix..'coolness'
        if message.content:sub(1, #msg) == msg then
        local mentioned = message.mentionedUsers
        if #mentioned == 1 then
            message:reply("<@!"..mentioned[1][1].."> is "..math.random(0, 100).."% cool! :sunglasses:")
        elseif #mentioned == 0 then
            message:reply("<@!"..message.author.id.."> is "..math.random(0, 100).."% cool! :sunglasses:")
        end
    end
end)

Bread:Command("ban", "Ban some outlaws, sherrif! (Requires banMember permission)", function (message)
    local msg = prefix..'ban'
    if message.content:sub(1, #msg) == msg then
        local author = message.guild:getMember(message.author.id)
        local member = message.mentionedUsers.first

        if not member then
          message:reply("Please mention someone to ban!")
          return
        elseif not author:hasPermission("administrator") then
          message:reply("You do not have permissions to ban!")
          return
        end

        for user in message.mentionedUsers:iter() do
          member = message.guild:getMember(user.id)
          if author.highestRole.position > member.highestRole.position then
            message:reply("Member Banned!")
            if not member:ban() then
                message:reply("Error while trying to ban")
            end
          else
            message:reply("That person its an admin or mod, i cant ban it.")
          end
        end
    end
end)

Bread:Command("warn", "WIP | Warn people before doing a mess! (Requires administrator permission)", function (message)
    local msg = prefix..'warn'
    if message.content:sub(1, #msg) == msg then
      local author = message.guild:getMember(message.author.id)
      local member = message.mentionedUsers.first

      if not member then
        message:reply("Please mention someone to warn!")
        return
      elseif not author:hasPermission("administrator") then
        message:reply("You do not have permissions to warn!")
        return
      end
    
      for user in message.mentionedUsers:iter() do
        member = message.guild:getMember(user.id)
        if author.highestRole.position > member.highestRole.position then
            warns = warns + 1
            message:reply("Member "..user.username.." Warned! (Now "..warns..' Warns.)')
            else
                message:reply("That person's role its higher than yours")
            end
        end
    end
end)

Bread:Command("unwarn", "WIP | UnWarn wrong people you warned! (Requires administrator permission)", function (message)
    local msg = prefix..'unwarn'
    if message.content:sub(1, #msg) == msg then
      local author = message.guild:getMember(message.author.id)
      local member = message.mentionedUsers.first

      if not member then
        message:reply("Please mention someone to warn!")
        return
      elseif not author:hasPermission("administrator") then
        message:reply("You do not have permissions to warn!")
        return
      end
    
      for user in message.mentionedUsers:iter() do
        member = message.guild:getMember(user.id)
        if author.highestRole.position > member.highestRole.position then
          warns = warns - 1
          if warns <= -1 then
            warns = 0
            message:reply("This member dont have any warns.")
            return
          end
          message:reply("Member "..user.username.." UnWarned! (Now "..warns..' Warns.)')
        end
      end
    end
end)

Bread:Command("time", "Reveal current UNIX time", function (message)
    message:reply('Current UNIX Time: '..os.date("%F %T", os.time()))
end)

Bread:Command("purge", "Start a purge to clean the chat! (Requies manageMessages permission)", function (message)
    if message.member:hasPermission("manageMessages") then
      local msg = prefix..'purge'
      if message.content:sub(1, #msg) == msg then
        if message.member:hasPermission('manageMessages') then
          local repla = string.gsub(message.content, prefix.."purge ", "")
          local cha = message.guild:getChannel(message.channel.id)
          if not cha:bulkDelete(message.channel:getMessagesBefore(message.id, repla)) then
            message:delete()
            local reply = message:reply("Something went wrong whiling starting a purge...")
            Bread.WaitFor(3, function()
              reply:delete()
            end)
          else
            message:delete()
            local reply
            if repla == "1" then
              reply = message:reply("Chat purged by <@!"..message.author.id.."> (Purged "..repla.." Message)!")
            else
              reply = message:reply("Chat purged by <@!"..message.author.id.."> (Purged "..repla.." Messages)!")
            end
            Bread.WaitFor(3, function()
              reply:delete()
            end)
          end
        else
          message:reply("Sorry <@!"..message.author.id.."> you dont have perms to purge!")
        end
      end
    end
end)

Bread:Command("whois", "Check user information", function(message)
        local member = message.mentionedUsers
      if #member == 0 then
          message:reply("Please, mention someone to check!")
          return
      elseif #member == 1 then
        for user in message.mentionedUsers:iter() do
            member = message.guild:getMember(user.id)
            message:reply {
            embed = {
              thumbnail = {url = member.avatarURL},
			        fields = {
				      {name = 'Nick & Tag', value = member.tag, inline = true},
              {name = 'ID', value = member.id, inline = true},
              {name = 'Highest Role', value = member.highestRole.name, inline = true},
				      {name = 'Boosted Since', value = member.premiumSince or "Dont Boosted", inline = true},
				      {name = 'Joined Server At', value = member.joinedAt and member.joinedAt:gsub('%..*', ''):gsub('T', ' ') or '?', inline = true},
				      {name = 'Joined Discord At', value = discordia.Date.fromSnowflake(member.id):toISO(' ', ''), inline = true},
            },
            color = discordia.Color.fromRGB(255, 0, 0).value
          }
        }
      end
    elseif #member >= 2 then
      message:reply("I cannot check "..#member.." users or more at same time.")
      return
    end
end)

Bread:Command("battle", "Battle someone!", function (message)
  local enemy = message.mentionedUsers
  local author = message.author.id
  local winner = math.random(1, 100)

  local rounds = math.random(1, 20)
    if #enemy == 1 then
        for user in message.mentionedUsers:iter() do
          enemy = user.id
          if enemy == author then
              message:reply("You cannot beat yourself!")
              return
          end
          local winnedby= {
            'Punching him to death',
            'Using Shadow clone jutso',
            'Stopping time and throwing knifes',
            'Cutting him with a Powerful Sword',
            'Giving him a head-shot with a sniper',
            'Making him rage-quit',
            'Abusing of bugs',
            'Find and kill him in a manhunt',
            'Using Uno Reverse card',
            'Killing him in front of a crewmate'
          }
          if winner >= 50 then
            message:reply("<@!"..enemy.."> won the battle in "..rounds.." rounds by: "..winnedby[math.random(1, #winnedby)].."!")
          elseif winner <= 50 then
            message:reply("<@!"..author.."> won the battle in "..rounds.." rounds by: "..winnedby[math.random(1, #winnedby)].."!")
          end
        end
  elseif #enemy >= 2 then
    message:reply("I cant make you fight against "..#enemy.." people!")
  else
    message:reply("Please metion someone to battle!")
  end
end)

Bread:Command("magicball", "Tell something to the ball!", function(message)
  local answers = {
    'Yes',
    'No',
    'Maybe',
    'I dont know',
    'Im dont gonna answer this.',
    'I will think.',
    'Probably yes.',
    'Probably no.'
  }
  message:reply {
    embed = {
      title = ":8ball: Magic Ball",
      description = "Question:\n"..message.content:gsub(prefix.."magicball ", ""),
      fields = {
        {name = "Answer:", value = answers[math.random(1, #answers)]}
      };
      color = discordia.Color.fromRGB(27,26,54).value
    }
  }
end)

Bread:Command("quote", "Quote a message (Needs message ID)", function (message)
  local MsgID = message.content:gsub(prefix.."quote ", "")
  local Msg = message.channel:getMessage(MsgID)
  local Channel = message.guild:getChannel(message.channel.id)
  if not Msg then
      message:reply("Couldn't find the quote you looking for.")
  else
      message:reply{
        embed = {
          author = {
            name = Msg.author.username,
            icon_url = Msg.author.avatarURL
          },
          description = Msg.content,
          footer = {
            text = string.format("#%s in %s", Channel.name, message.guild.name)
          },
          timestamp = Msg.timestamp,
          color = discordia.Color.fromRGB(27,26,54).value
        }
      }
  end
end)

client:on("ready", function ()
    client:setGame("With code | Shard "..tostring(client.totalShardCount))
end)

Bread:Help(true)

Bread:Eat()