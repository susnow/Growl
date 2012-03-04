--[[
how to use
DATA.xxx = {
	EVENT = "XXXXXXXX", --Growl object will show when the EVENT fire
	title = function(...)  	
		return title_text  --in the function you should set your title_text as a string object 
	end,
	content = function(...)
		return content_text -- in the function you should set your content_text as a string object
	end,
	duration = 1, -- how long does the Growl object display , it must be a int object or float object
}

when you create the DATA object , create the same name data object in config.lua and set it true or false if you wanna enable it or not 
]]
local addon,ns = ...
local DATA = {}

DATA.STATUS_CHANGE = {
	EVENT = "PLAYER_FLAGS_CHANGED",
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
	duration = 2,
}

DATA.WHISPER = {
	EVENT = "CHAT_MSG_WHISPER",
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
	duration = 3.5,
}

DATA.BN_WHISPER = {
	EVENT = "CHAT_MSG_BN_WHISPER",
	title = function(...)  
		local sender = select(2,...)
		local title = "Whisper from BN RealID" 
		return title
	end,
	content = function(...)
		local msg,sender = ...
		local content = string.format("%s%:%s",sender,msg)
		return content
	end,
	duration = 3.5,
}

ns.DATA = DATA 
