--[[
USEAGE:
you can create DATA object as a table like the sample:
DATA.xxx = {
	EVENT = "XXXXXXXX", --Growl object will register this event 
	icon = "xxxxx", --the icon's textrues, this value must be same named with media textrue's name 
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

DATA.WELCOME = {
	EVENT = "PLAYER_LOGIN",
	source = "SYSTEM",
	icon = "QB",
	title = function(...)
		return "Welcome use Growl for WoW"
	end,
	content = function(...)
		return "僕と契約して、魔法少女になってよ"
	end,
	delay = 3.5,
}

DATA.STATUS_CHANGE = {
	EVENT = "PLAYER_FLAGS_CHANGED",
	source = "SYSTEM",
	title = function(...) 
		return "Status changed" 
	end,
	icon = "eye",
	content = function(...) 
		local isAfk = UnitIsAFK("player")
		local isDnd = UnitIsDND("player")
		local isResting = IsResting()
		local content = ""
		if UnitAffectingCombat("player") then 
			return false
		else
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
		end
	end,
	delay = 2,
}

DATA.WHISPER = {
	EVENT = "CHAT_MSG_WHISPER",
	source = "PLAYER",
	icon = "msg",
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
	icon = "phone",
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
	icon = "mail",
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
	icon = "loot",
	source = "ITEM",
	title = function(...)
		local title = "You get an item"
		return title
	end,
	content = function(...)
		local msg = ...
		local op1,op2 = "%[","%]"
		local cs = "获得了物品" or "得到了物品"
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

DATA.CURRENCY_INFO = {
	EVENT = "CHAT_MSG_CURRENCY",
	icon = "heart",
	source = "SYSTEM",
	title = function(...)
		local title = "You recieve currency"
		return title
	end,
	content = function(...)
		local msg = ... 
		local content = ""
		local op = {"%[","%]","x","%。"}
		local ops = {}
		for i =1, 4 do
			ops[i] = {string.find(msg,op[i])}
		end
		local currencyIDbyType = {
			["正义点数"] = 395,
			["勇气点数"] = 396,
		}
		local currencyType = string.sub(msg,ops[1][2]+1,ops[2][1]-1) -- cut the string between "[" and "]"            "[justice points]" will return "justice points"
		local currencyPoints = string.sub(msg,ops[3][2],ops[4][1]-1) -- cut the number between "x" and "."          "x77." will return "77"
		if currencyType == "勇气点数" then 
			local _,allCP,_,curCP = GetCurrencyInfo(currencyIDbyType[currencyType])	
			content = string.format("%s:%s,%s:%s,%s:%s","获取"..currencyType,currencyPoints,"本周上限",curCP.."/1000","总计",allCP)
		elseif currencyType == "正义点数" then
			local allCP = select(2,GetCurrencyInfo(currencyIDbyType[currencyType]))
			content = string.format("%s:%s,%s:%s","获取"..currencyType,currencyPoints,"总计",allCP)
		else 
			content = ""	
		end
		if content == "" then return false end
		return content
	end,
	delay = 3.5,
}

ns.DATA = DATA 
