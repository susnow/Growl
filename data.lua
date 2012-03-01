local addon,growl = ...
local data = {}

data.STATUS_CHANGE = {
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

data.WHISPER = {
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
			title = "Whiper from friend"
		elseif not isMyFriend and sender ~= UnitName("player") then
			title = "Whisper from stranger"
		elseif not isMyFriend and sender == UnitName("player") then
			title = "Whiper from me"
		end
		return title
	end,
	content = function(...)
		local msg,sender = ...
		sender = UnitName(sender) == UnitName("player") and "me" or sender
		local content = string.format("%s:%s",sender,msg)
		if string.len(content) > 26 then
			content = string.sub(content,1,24)
			content = content .. "..."
		end
		return content
	end,
	duration = 3.5,
}

data.BN_WHISPER = {
	EVENT = "CHAT_MSG_BN_WHISPER",
	title = function(...)  
		local sender = select(2,...)
		local title = "Whisper from BN RealID" 
		return title
	end,
	content = function(...)
		local msg,sender = ...
		local content = string.format("%s:%s",sender,msg)
		if string.len(content) > 26 then
			content = string.sub(content,1,24)
			content = content .. "..."
		end
		return content
	end,
	duration = 3.5,
}

growl.data = data
