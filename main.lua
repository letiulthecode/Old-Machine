local discordia = require('discordia')
local client = discordia.Client()
local json = require('json')

--Please read README.md before you edit this--
--Open Source Version: 2.0--

local prefix = '>'

client:on('ready', function()
	print('Logged in as '.. client.user.username)
	client:setGame(">help || Test Annunciament!") --change the annunciament here
end)

client:on('messageCreate', function(message)
    if message.author.bot then return end

	if message.content:lower() == prefix..'mping' then
		message.channel:send('Pong!')
    end
    
	if message.content:lower()  == prefix..'rping' then
	   message:addReaction("🏓")
	end
    
    if message.content:lower()  == prefix..'dmping' then
	   message.member:send("Pong!")
	end
	
	if message.content:lower()== prefix..'patchnotes' then
	 message:reply{ 
	     embed = {
			 fields = {
			     {name = "v0.0 Patchnotes"; value = "No updates yet"; inline = false};
				};
			 color = discordia.Color.fromRGB(27,26,54).value;
		    }
	    }
	end
	
	if message.content:lower() == prefix..'sharebot' then
		message.channel:send('https://discord.com/api/oauth2/authorize?client_id=777887826561335327&permissions=8&scope=bot')
	end
	
	if message.content:lower() == prefix..'ct.brackets' then
		message.channel:send('Usage: >cooltest [mention] (if you dont mention anyone then will be yourself.)')
	end
	
	if message.content:lower() == prefix..'st.brackets' then
		message.channel:send('Usage: >stresstest [mention] (if you dont mention anyone then will be yourself.)')
	end
	
	if message.content:lower() == prefix..'githubsrc' then
		message.channel:send('Here, if you want make your own bot! (please read README.md) https://github.com/letiulthecode/Cyber.11-Source-Code')
	end
	
	if message.content:lower() == prefix..'rp.brackets' then
		message.channel:send("Usage: >report (automatticaly will send an request to owner's output, then he will add you and start the problem solving)")
	end
	
    if message.content:lower() == prefix..'report' then
		message.channel:send('Report sended!')
		print(message.author.tag.." Sended Report")
	end
	
	if message.content:lower() == prefix..'help' then
	   message:reply("<@!"..message.member.id.."> Check your DMs!")
       message.member:send{ 
	     embed = {
			 fields = {
			     {name = "Commands"; value = "Actual prefix = '>' \n \n mping: Sends 'pong' message (can be used to test discord latency) \n \n rping: React 🏓 on your message (can be used as same use to messageping) \n \n cooltest: Check cool %! \n \n stresstest: Check stress %! \n \n sharebot: Sends an link to you share the original bot to your friends! \n \n .brackets: See how use an determined comand \n \n flipcoin: Flip an coin! \n \n patchnotes: See news and update of this bot! \n \n luckynumber: Get an lucky number! \n \n githubsrc: Show an link to git hub with my source code! \n \n report: If you haved an error or something wierd with the bot, you can report here \n \n dmping: Send 'Pong!' on your dm\n \n**Thanks for reading!**"; inline = false};
				};
			 color = discordia.Color.fromRGB(27,26,54).value;
		    }
	    }
	end
	
    if message.content:lower():sub(1, #'>8ball') == prefix..'8ball' then
	   local random = math.random(1,3)
       
       if random == 1 then
          message.channel:send(":8ball: Maybe :8ball:")
       elseif random == 2 then
       	  message.channel:send(":8ball: Yes :8ball:")
       elseif random == 3 then 
       	  message.channel:send(":8ball: No :8ball:")
       end
	end
    
	if message.content:lower() == prefix..'flipcoin' then
	   local flip = math.random(1, 4)
	   
	   if flip >= 2 then
	       message.channel:send("Heads!")
		elseif flip <= 2 then
		   message.channel:send("Tails!")
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
	      message:reply("<@!"..mentioned[1][1]..">'s lucky number is: "..math.random(1, 9).." :four_leaf_clover:")
		elseif #mentioned == 0 then
	      message:reply("<@!"..message.member.id..">'s lucky number is: "..math.random(1, 9).." :four_leaf_clover:")
	   end
	end
end)

client:run('Bot (put your token here)')
