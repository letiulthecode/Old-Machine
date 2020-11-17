local discordia = require('discordia')
local client = discordia.Client()
local coro = require('coro-http')
local json = require('json')

--commands with double '-' are unused commands.



local prefix = '>'

client:on('ready', function()
	print('Logged in as '.. client.user.username)
end)

client:on('messageCreate', function(message)
    if message.author.bot then return end
    
	if message.content == prefix..'messageping' then
		message.channel:send('Pong!')
		
	--[[if message.content:sub(1, 4) == '>ban' then
     local author = message.guild:getMember(message.author.id)
     local member = message.mentionedUsers.first

     if not member then
      message:reply("Please mention someone to ban!")
     return
      elseif not author:hasPermission("banMembers") then
      message:reply("You do not have permissions enough to ban someone!")
      return
    end

    for user in message.mentionedUsers:iter() do
      member = message.guild:getMember(user.id)
      if author.highestRole.position > member.highestRole.position then
        member:ban()
          end
       end
	end]]--
	
		
		
	elseif message.content == prefix..'reactionping' then
	   message:addReaction("🏓")
	end
	
	if message.content == prefix..'qtod' then
		message.channel:send("Welcome to QTOD! Ask me questions with >qtod!(Question)")
	end
	
	if message.content == prefix.."qtod!Your language" then
	   message.channel:send("<@!"..message.member.id.."> Well i talk english, but my programming language its Lua!")
	end
	
	if message.content == prefix.."qtod!Your born date" then
	   message.channel:send("<@!"..message.member.id.."> My official born date its 2020/11/16!")
	end
	
	if message.content == prefix.."qtod!Why you are an protogen mask" then
	   message.channel:send("<@!"..message.member.id.."> Just maybe, im my owner's mask? :eyes:")
	end
	
	if message.content == prefix..'patchnotes' then
		message.channel:send('Added this command \n reformed help command. \n Added luckynumber and flipcoin \n We are preparing to lauch ban command and github source.')
	end
	
	if message.content == prefix..'sharebot' then
		message.channel:send('If you want support us, send this link to your friends! https://discord.com/api/oauth2/authorize?client_id=777887826561335327&permissions=8&scope=bot')
	end
	
	if message.content == prefix..'ct.brackets' then
		message.channel:send('Usage: >cooltest [mention] (if you dont mention anyone then will be yourself.)')
	end
	
	if message.content == prefix..'st.brackets' then
		message.channel:send('Usage: >stresstest [mention] (if you dont mention anyone then will be yourself.)')
	end
	
	if message.content == prefix..'qtod.brackets' then
		message.channel:send('Usage: >qtod![Question] (Avable Questions:Your language, Your born date and Why you are an protogen mask)')
	end
	
	if message.content == prefix..'help' then
       message:reply{ 
	     embed = {
			 fields = {
			     {name = "Commands"; value = "Actual prefix = '>' \n \n messageping: Sends 'pong' message (can be used to test discord latency) \n \n reactionping: React 🏓 on your message (can be used as same use to messageping) \n \n cooltest: check cool %! \n \n stresstest: Check stress %! \n \n sharebot: sends an link to you share the bot to your friends! \n \n .brackets: see how use an determined comand \n \n flipcoin: flip an coin! \n \n patchnotes: see news and update of this bot! \n \n luckynumber: get an lucky number! \n \n qtod: Talk something about me and i will respond!\n \n **Problems? talk with my owner: just an protogen#7094**"; inline = false};
				};
			 color = discordia.Color.fromRGB(100,100,255).value;
		    }
	    }
	end
	
	if message.content == prefix..'flipcoin' then
	   local tails = 1
	   local heads = 2
	   local flip = math.random(tails, heads)
	   
	   if flip == tails then
	      message.channel:send("Flipped tails!")
	   else
	      message.channel:send("Flipped heads!")
	   end
	end
	
	if message.content:lower():sub(1, #'>cooltest') == prefix..'cooltest' then
	   local mentioned = message.mentionedUsers
	   if #mentioned == 1 then
	      message:reply("<@!"..mentioned[1][1].."> is "..math.random(0, 100).."% cool! :sunglasses:")
		elseif #mentioned == 0 then
	      message:reply("<@!"..message.member.id.."> is "..math.random(0, 100).."% cool! :sunglasses:")
	   end
	end
	
	if message.content:lower():sub(1, #'>stresstest') == prefix..'stresstest' then
	   local mentioned = message.mentionedUsers
	   if #mentioned == 1 then
	      message:reply("<@!"..mentioned[1][1].."> is "..math.random(1, 100).."% stressed! :triumph:")
		elseif #mentioned == 0 then
	      message:reply("<@!"..message.member.id.."> is "..math.random(1, 100).."% stressed! :triumph:")
	   end
	end
	
    if message.content:lower():sub(1, #'>luckynumber') == prefix..'luckynumber' then
	   local mentioned = message.mentionedUsers
	   if #mentioned == 1 then
	      message:reply("<@!"..mentioned[1][1]..">'s lucky number is: "..math.random(1, 10).." :four_leaf_clover:")
		elseif #mentioned == 0 then
	      message:reply("<@!"..message.member.id..">'s lucky number is: "..math.random(1, 10).." :four_leaf_clover:")
	   end
	end
	

end)

client:run('Bot Nzc3ODg3ODI2NTYxMzM1MzI3.X7J-fg.m8SchTZFc3_5n8jv2g7tejYbVD8')