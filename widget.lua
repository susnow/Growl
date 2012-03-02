local addon,ns = ...
local Growl = CreateFrame("Frame")
local Growls = {}
local CFG = ns.CFG
local DATA = ns.DATA
local tex = "Interface\\Buttons\\WHITE8X8"

function Growl:New(point,obj,index)
	if not index then 
		index = #Growls+1
	end

	--main button
	obj = obj or CreateFrame("Button", "Growl"..index, UIParent)
	obj:SetSize(280, 70)
	local SETPOINT = {
		TOPLEFT = function(obj) 
			if index == 1 then
				obj:SetPoint("TOPLEFT", UIParent, 20, -20)
			elseif index > 1 then
				obj:SetPoint("TOPLEFT", "Growl"..index - 1, "BOTTOMLEFT", 0, -20)
			end
		end,
		BOTTOMLEFT = function(obj)
			if index == 1 then
				obj:SetPoint("BOTTOMLEFT", UIParent, 20, 20)
			elseif index > 1 then
				obj:SetPoint("BOTTOMLEFT", "Growl"..index - 1, "TOPLEFT", 0 , 20)
			end
		end,
		TOPRIGHT = function(obj)
			if index == 1 then
				obj:SetPoint("TOPRIGHT", UIParent, -20, -20)
			elseif index > 1 then
				obj:SetPoint("TOPRIGHT", "Growl"..index - 1, "BOTTOMRIGHT", 0 , -20)
			end
		end,
		BOTTOMRIGHT = function(obj)
			if index == 1 then
				obj:SetPoint("BOTTOMRIGHT", UIParent, -20, 20)
			elseif index > 1 then
				obj:SetPoint("BOTTOMRIGHT", "Growl"..index - 1, "TOPRIGHT", 0 , 20)
			end
		end,
	}
	do
		SETPOINT[point](obj)
	end
	obj.tex = obj:CreateTexture(nil, "BACKGROUND")
	obj.tex:SetAllPoints(obj)
	obj.tex:SetTexture(tex)
	obj.tex:SetVertexColor(.1, .1, .1, .7)

	--close button
	obj.close = CreateFrame("Button", "Growl"..index.."CloseButton", obj)
	obj.close:SetFrameLevel(obj:GetFrameLevel()+1)
	obj.close:SetSize(20, 20)
	obj.close:SetPoint("TOPRIGHT", obj, -5, -5)
	obj.close.text = obj.close:CreateFontString(nil,"OVERLAY")
	obj.close.text:SetFontObject(ChatFontNormal)
	do
		local font,size,flag = obj.close.text:GetFont()
		obj.close.text:SetFont(font, 18, flag)
	end
	obj.close.text:SetPoint("CENTER", obj.close)
	obj.close.text:SetText("x")
	obj.close.text:SetTextColor(.5, .5, .5, 1)

	--tex icon
	obj.icon = CreateFrame("Frame", "Growl"..index.."Icon",obj)
	obj.icon:SetSize(obj:GetHeight()-20, obj:GetHeight()-20)
	obj.icon:SetPoint("TOPLEFT", obj, 10, -10)
	obj.icon.tex = obj.icon:CreateTexture(nil, "OVERLAY")
	obj.icon.tex:SetTexture(tex)
	obj.icon.tex:SetAllPoints(obj.icon)
	obj.icon.tex:SetVertexColor(1, 1, 1, .2)

	--title
	obj.title = CreateFrame("Frame", "Growl"..index.."Title", obj)
	obj.title:SetSize(obj:GetWidth() - obj.icon:GetWidth(), obj:GetHeight()/5)
	obj.title:SetPoint("TOPLEFT", obj.icon, "TOPRIGHT", 10, -10)
	obj.title.text = obj.title:CreateFontString(nil, "OVERLAY")
	obj.title.text:SetFontObject(ChatFontNormal)
	do 
		local font,size,flag = obj.title.text:GetFont()
		obj.title.text:SetFont(font, 18, "OUTLINE")
	end
	obj.title.text:SetText("test")
	obj.title.text:SetPoint("LEFT",obj.title)

	--content
	obj.content = CreateFrame("Frame","Growl"..index.."Content",obj)
	obj.content:SetSize(obj:GetWidth() - obj.icon:GetWidth(), obj:GetHeight() - obj.title:GetHeight()-5)
	obj.content:SetPoint("TOPLEFT", obj.title, "BOTTOMLEFT", 0, -4)
	obj.content.text = obj.content:CreateFontString(nil,"OVERLAY")
	obj.content.text:SetFontObject(ChatFontNormal)
	obj.content.text:SetPoint("TOPLEFT",obj.content)
	obj.content.text:SetWidth(obj.content:GetWidth()-26)
	obj.content.text:SetJustifyH("LEFT")
	obj.content.text:SetJustifyV("TOP")
	obj.content.text:SetHeight(obj.content:GetHeight()-5)
	obj.content.text:SetText("test content")

	obj:SetAlpha(0)
	obj:Hide()
	obj.nextUpdate = 0
	table.insert(Growls,obj)
end

function Growl:OnShow(obj,time,isOnEnter)
	obj:Show()
	local oldTime = time or GetTime()
	if isOnEnter then
		obj:Show()
		obj:SetAlpha(1)
		obj:SetScript("OnUpdate",nil)
		return
	end
	obj:SetScript("OnUpdate",function(self,elapsed)
		self.nextUpdate = self.nextUpdate + elapsed
		if self.nextUpdate > 0.01 then
			local newTime = GetTime()	
			if (newTime - oldTime) < 1 then
				local tempAlpha = tonumber(string.format("%6.2f",(newTime - oldTime)))
				self:SetAlpha(tempAlpha)
			else
				self:SetAlpha(1)
				self:SetScript("OnUpdate",nil)
			end
			self.nextUpdate = 0
		end
	end)
end

function Growl:OnHide(obj,time)
	local oldTime = time or GetTime()
	obj:SetScript("OnUpdate",function(self,elapsed)
		self.nextUpdate = self.nextUpdate + elapsed
		if self.nextUpdate > 0.01 then
			local newTime = GetTime()	
			if (newTime - oldTime) < 1 then
				local tempAlpha = tonumber(string.format("%6.2f",(newTime - oldTime)))
				self:SetAlpha(1-tempAlpha)
			else
				self:SetAlpha(0)
				self:SetScript("OnUpdate",nil)
				self:Hide()
			end
			self.nextUpdate = 0
		end
	end)
end

function Growl:OnEnter(obj)
	if obj:IsShown() then
		Growl:OnShow(obj,GetTime(),true)
	end
end

function Growl:OnLeave(obj)
	if obj:IsShown() then
		Growl:OnHide(obj,GetTime()+1)
	end
end

function Growl.Animation(objects,index,value,...)
	Growl:OnShow(objects[index],GetTime())
	objects[index].title.text:SetText(value.title(...))
	objects[index].content.text:SetText(value.content(...))
	Growl:OnHide(objects[index],GetTime() + value.duration)
end

function Growl:Sort(objs,data)
	--init event
	for k, v in pairs(data) do
		if v and v.EVENT then
			Growl:RegisterEvent(v.EVENT)
		end
	end
	Growl:SetScript("OnEvent", function(self, event, ...)
		for k,v in pairs(data) do
			if event == v.EVENT and CFG[k] then
				for c = 1, #objs do
					local obj = objs[c]
					if not obj:IsShown() then
						Growl.Animation(objs, c ,v,...)
						break;
					end
				end
			end
		end
	end)
end

ns.Growl = Growl
