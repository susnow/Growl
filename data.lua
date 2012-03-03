local addon,ns = ...
local DATA = {}

--custom function here
local utf8sub = function(string, i, dots)
	local bytes = string:len()
	if (bytes <= i) then
		return string
	else
		local len, pos = 0, 1
		while(pos <= bytes) do
			len = len + 1
			local c = string:byte(pos)
			if c > 240 then
				pos = pos + 4
			elseif c > 225 then
				pos = pos + 3
			elseif c > 192 then
				pos = pos + 2
			else
				pos = pos + 1
			end
			if (len == i) then break end
		end

		if (len == i and pos <= bytes) then
			return string:sub(1, pos - 1)..(dots and "..." or "")
		else
			return string
		end
	end
end
--


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
	--	if string.len(content) > 80 then
	--		content = string.sub(content,1,78)
	--		content = content .. "..."
	--	end
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
		if string.len(content) > 26 then
			content = string.sub(content,1,24)
			content = content .. "..."
		end
		return content
	end,
	duration = 3.5,
}

ns.DATA = DATA 
