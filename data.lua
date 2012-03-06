--[[
USEAGE:
you can create DATA object as a table like the sample:
DATA.xxx = {
	EVENT = "XXXXXXXX", --Growl object will register this event 
	source = "XXXXXXX", --the source will effect the object's click function, "PLAYER" will send whisper message to the whisper  , "ITEM" will open the Gametooltip of the item ,and others won't do anything   
	title = function(...)  	
		return title_text  --in the function you should set your title_text as a string object 
	end,
	content = function(...)
		return content_text 
		-- in the function you should set your content_text as a string object 
		--FIXME 2012/03/06 if you need to control the timming of animation show when the event fired, you should create judge in your function  and when the function return true it will be done,you can see the example codes in LOOT_INFO
		-- elseif you needn't control animation,let it show when the event is firing, you just need return the string object in your function and it equivalent to return true 
	end,
	delay = 1, -- how long does the Growl object display , it must be a int object or float object
}

when you create the DATA object , create the same name data object in config.lua and set it true or false if you wanna enable it or not 

GG HF
]]
local addon,ns = ...
local DATA = {}

DATA.STATUS_CHANGE = {
	EVENT = "PLAYER_FLAGS_CHANGED",
	source = "SYSTEM",
	title = function(...) 
		return "Status changed" 
	end,
	content = function(...) 
		local isAfk = UnitIsAFK("player")
		local isDnd = UnitIsDND("player")
		local isResting = IsResting()
		local content = ""
		if isAfk then
			content = "You're AFK now" 
		elseif isDnd then
			content = "You're DND now" 
		elseif isResting then
			content = "You're Resting now"
		else 
			content = "Leave from AFK,DND or resting"
		end
		return content 
	end,
	delay = 2,
}

DATA.WHISPER = {
	EVENT = "CHAT_MSG_WHISPER",
	source = "PLAYER",
	title = function(...)  
		local sender = select(2,...)
		local isMyFriend = false
		for i = 1, GetNumFriends() do
			local name = GetFriendInfo(i)
			if name == sender then
				isMyFriend = true
			end
		end
		local title = ""
		if isMyFriend then
			title = "Whisper from friend"
		elseif not isMyFriend and sender ~= UnitName("player") then
			title = "Whisper from stranger"
		elseif not isMyFriend and sender == UnitName("player") then
			title = "Whisper from me"
		end
		return title
	end,
	content = function(...)
		local msg,sender = ...
		sender = UnitName(sender) == UnitName("player") and "me" or sender
		local content = string.format("%s:%s",sender,msg)
		return content
	end,
	delay = 3.5,
}

DATA.BN_WHISPER = {
	EVENT = "CHAT_MSG_BN_WHISPER",
	source = "PLAYER",
	title = function(...)  
		local sender = select(2,...)
		local title = "Whisper from BN RealID" 
		return title
	end,
	content = function(...)
		local msg,sender = ...
		local content = string.format("%s:%s",sender,msg)
		return content
	end,
	delay = 3.5,
}

DATA.NEW_MAIL = {
	EVENT = "UPDATE_PENDING_MAIL",
	source = "SYSTEM",
	title = function(...)
		local title = "You get a new mail"
		return title
	end,
	content = function(...)
		local content = "Go the nearest mail box to recieve it"
		return content
	end,
	delay = 3.5,
}

DATA.LOOT_INFO = {
	EVENT = "CHAT_MSG_LOOT",
	source = "ITEM",
	title = function(...)
		local title = "You loot item"
		return title
	end,
	content = function(...)
		local msg = ...
		local op1,op2 = "%[","%]"
		local cs = "获得了物品"
		if not string.find(msg,cs) then 
			return false 
		else
			local index1,index2 = string.find(msg,cs)
			local looter = string.sub(msg,1,index1-1)
			local op1s,op1e = string.find(msg,op1)
			local op2s,op2e = string.find(msg,op2)
			local lootItem = string.sub(msg,op1e+1,op2e-1)
			local content = ""
			content = lootItem 
			if looter == "你" then
				return content
			else 
				return false
			end
		end
	end,
	delay = 3.5,
}

ns.DATA = DATA 
