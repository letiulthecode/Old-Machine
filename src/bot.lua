--Hello! My name is "Helpful comment", Im Here to help you to use this source to build your ver own bot!
--Everytime you seeing a "--" and in front a text, thats me helping you!

local discordia = require "discordia"-- We need require the Discordia Lib to use this bot
local client = discordia.Client() -- Also load the client, it will be very important
discordia.extensions()-- Load all helpful extentions

local warns = 0 -- ignore this
local prefix = ">" -- Define the prefix, like when a members send "!ping" the '!' its the prefix.
local commands = { -- Define commands its a table that will contain our commands
    [prefix..'ping'] = { -- Indexes can also be strings! So the string index it will concat our prefix and the command name!
        desc = 'Respond with a funny gif!', -- Description of our command...
        exec = function (message) -- And a function to our execute it!
            message.channel:send('https://tenor.com/view/cats-ping-pong-gif-8942945') --You can use message:reply('message'), its the same as message.channel:send
        end
    }; --Remember to put colon or semicolor when creating a new var (indenpedent if its a number, string, etc)
    --These other commands below i wont explane.
    [prefix..'coolness'] = {
        desc = 'See coolness of a person!',
        exec = function (message)
            local msg = prefix..'coolness'
            if message.content:sub(1, #msg) == msg then
                local mentioned = message.mentionedUsers
                if #mentioned == 1 then
                  message:reply("<@!"..mentioned[1][1].."> is "..math.random(0, 100).."% cool! :sunglasses:")
                elseif #mentioned == 0 then
                  message:reply("<@!"..message.author.id.."> is "..math.random(0, 100).."% cool! :sunglasses:")
                end
             end
        end
    };
    [prefix..'ban'] = {
        desc = 'Ban some out-laws, sherrif! (Requires banMember permission)',
        exec = function (message)
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
                    member:ban()
                  else
                    message:reply("That person its an admin or mod, i cant ban it.")
                  end
                end
            end
        end
    };
    [prefix..'warn'] = {
        desc = 'WIP | Warn people before doing a mess! (Requires administrator permission)',
        exec = function (message)
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
                  message:reply("That person its an admin or mod, i cant warn it.")
                end
            end
        end
    end
    };
    [prefix..'unwarn'] = {
      desc = 'WIP | UnWarn wrong people you warned! (Requires administrator permission)',
      exec = function (message)
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
    end
    };
    [prefix..'time'] = {
      desc = 'Reveals the current time!',
      exec = function (message)
        message:reply('Current UNIX Time: '..os.date("%F %T", os.time()))
      end
    };
    [prefix.."purge"] = {
    desc = "Start a purge to clean the chat! (Requies manageMessages permission)",
    exec = function(message)
      local msg = prefix..'purge'
      if message.content:sub(1, #msg) == msg then
        if message.member:hasPermission('manageMessages') then
          local repla = string.gsub(message.content, prefix.."purge ", "")
          local cha = message.guild:getChannel(message.channel.id)
          if not cha:bulkDelete(message.channel:getMessagesBefore(message.id, repla)) then
            message:delete()
            local reply = message:reply("Something went wrong whiling starting a purge...")
            discordia.Clock():waitFor("", 3000)
            reply:delete()
          else
            message:delete()
            local reply
            if repla == "1" then
              reply = message:reply("Chat purged by <@!"..message.author.id.."> (Purged "..repla.." Message)!")
            else
              reply = message:reply("Chat purged by <@!"..message.author.id.."> (Purged "..repla.." Messages)!")
            end
            discordia.Clock():waitFor("", 3000)
            reply:delete()
          end
        else
          message:reply("Sorry <@!"..message.author.id.."> you dont have perms to purge!")
        end
      end
    end
  };
  [prefix.."whois"] = {
    desc = "See information of a user!",
    exec = function(message)
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
    end
  };
  [prefix.."battle"] = {
    desc = "Fight someone!",
    exec = function(message)
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
    end
  };
  [prefix.."magicball"] = {
    desc = "Speak with a magic ball!",
    exec = function(message)
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
    end
  };
  [prefix.."quote"] = {
    desc = "Quote a message (Needs Message ID)",
    exec = function (message)
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
    end
  }
}

client:on("ready", function() -- Remember we made a client variable? We can use it now!
    -- So if the bot its ready, it will prints thats its online!
    -- Ignore os.date, os.time, \027[94m etc. its things that just make the message cool!
    -- NOTE: Remember every thing related with client, its related to the bot!
    print(os.date("%F %T", os.time()).." | \027[94m[BOT]\027[0m     | "..client.user.username.." Is online!")
    client:setGame("With Code | Shard "..tostring(client.totalShardCount)) -- Status message
end)

client:on('messageCreate', function(message) -- If someone sends a message, we gonna make a function with param "message".
  if message.author.bot then return end -- Prevent the bot to use thier own commands
  local args = message.content:split(" ") -- Split all arguments of the message content into a table

	local command = commands[args[1]] -- Use first index of the arguments
	if command then -- If one of the commands then execute it
    command.exec(message)
	end

  --Help command
	if args[1] == prefix.."help" then -- If first index of args its the prefix and help, then (bassicaly) display all the commands
		local stdout = {}
		for w, tbl in pairs(commands) do
			table.insert(stdout, w .. " - " .. tbl.desc)
		end

		if not message.member:send{embed = {title = "Old-Machine commands", description = table.concat(stdout, "\n\n"), color = discordia.Color.fromRGB(27,26,54).value;}} then --If cant send in the DMs then send on channel
      message:reply{embed = {title = "Old-Machine commands", description = table.concat(stdout, "\n\n"), color = discordia.Color.fromRGB(27,26,54).value;}}
    end
	end
end)

client:run("Bot TOKEN") --replace TOKEN with the bot token, running a second instance before/after can cause problems, regen the token to solve