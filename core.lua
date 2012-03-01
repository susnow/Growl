local addon,growl = ...
local cfg = growl.cfg
local data = growl.data

local tex = "Interface\\AddOns\\Glowl\\media\\sd"
local tex2 = "Interface\\Buttons\\WHITE8X8"

--widget

--MainPanel
local f = CreateFrame("Button","GrowlPanel",UIParent)
f.nextUpdate = 0
f:SetSize(300,70)
f:SetPoint("TOPLEFT",UIParent,20,-20)
f.tex = f:CreateTexture(nil,"BACKGROUND")
f.tex:SetAllPoints(f)
f.tex:SetTexture(tex2)
f.tex:SetVertexColor(.1,.1,.1,.7)

--close button
f.close = CreateFrame("Button","GrowlCloseButton",f)
f.close:SetFrameLevel(f:GetFrameLevel()+1)
f.close:SetSize(20,20)
f.close:SetPoint("TOPRIGHT",f,-5,-5)
f.close.text = f.close:CreateFontString(nil,"OVERLAY")
f.close.text:SetFontObject(ChatFontNormal)
do 
	local font,size,flag = f.close.text:GetFont()
	f.close.text:SetFont(font,18,flag)
end
f.close.text:SetPoint("CENTER",f.close)
f.close.text:SetText("x")
f.close.text:SetTextColor(.5,.5,.5,1)

--icon
f.icon = CreateFrame("Frame","GrowlStatusIcon",f)
f.icon:SetSize(f:GetHeight()-20,f:GetHeight()-20)
f.icon:SetPoint("TOPLEFT",f,10,-10)
f.icon.tex = f.icon:CreateTexture(nil,"OVERLAY")
f.icon.tex:SetTexture(tex)
f.icon.tex:SetAllPoints(f.icon)
f.icon.tex:SetVertexColor(1,1,1,.2)

--title
f.title = CreateFrame("Frame","GrowlPanelTitle",f)
f.title:SetSize(f:GetWidth()-f.icon:GetWidth(),f:GetHeight()/4)
f.title:SetPoint("TOPLEFT",f.icon,"TOPRIGHT",10,-10)
f.title.text = f.title:CreateFontString(nil,"OVERLAY")
f.title.text:SetFontObject(ChatFontNormal)
do 
	local font,size,flag = f.title.text:GetFont()
	f.title.text:SetFont(font,18,"OUTLINE")
end
f.title.text:SetText("test")
f.title.text:SetPoint("LEFT",f.title)

--content
f.content = CreateFrame("Frame","GrowlPanelContent",f)
f.content:SetSize(f:GetWidth()-f.icon:GetWidth(),f:GetHeight()-f.title:GetHeight()-5)
f.content:SetPoint("TOPLEFT",f.title,"BOTTOMLEFT",0,-4)
f.content.text = f.content:CreateFontString(nil,"OVERLAY")
f.content.text:SetFontObject(ChatFontNormal)
f.content.text:SetPoint("TOPLEFT",f.content)
f.content.text:SetText("test content")


--------------------------------------
--some init value, don't touch this --
f:SetAlpha(0)												--
f.show = false											--
--------------------------------------

--custom function
--ShowFunction
local PanelOnShow = function(obj,time,isOnEnter)
	local oldTime = time or GetTime()
		if isOnEnter then
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
					self.show = true
					self:SetScript("OnUpdate",nil)
				end
				self.nextUpdate = 0
			end
		end)
end

--HideFunction
local PanelOnHide = function(obj,time)
	local oldTime = time or GetTime()
		f:SetScript("OnUpdate",function(self,elapsed)
			self.nextUpdate = self.nextUpdate + elapsed
			if self.nextUpdate > 0.01 then
				local newTime = GetTime()	
				if (newTime - oldTime) < 1 then
					local tempAlpha = tonumber(string.format("%6.2f",(newTime - oldTime)))
					self:SetAlpha(1-tempAlpha)
				else
					self:SetAlpha(0)
					self.show = false
					self:SetScript("OnUpdate",nil)
				end
				self.nextUpdate = 0
			end
		end)
end

--EnterFunction
local PanelOnEnter = function(obj)
	if obj.show then
		PanelOnShow(obj,GetTime(),true)
	end
end

--LeaveFunction
local PanelOnLeave = function(obj)
	if obj.show  then
		PanelOnHide(obj,GetTime()+1)
	end
end


f:SetScript("OnEnter",function(self)
	PanelOnEnter(self)
end)

f:SetScript("OnLeave",function(self)
	PanelOnLeave(self)
end)

f.close:SetScript("OnEnter",function(self)
	self.text:SetTextColor(1,1,1,1)
	PanelOnEnter(f)
end)

f.close:SetScript("OnLeave",function(self)
	self.text:SetTextColor(.5,.5,.5,1)
end)



for k,v in pairs(data) do
	if cfg.k then
		f:RegisterEvent(v.EVENT)
		f:HookScript("OnEvent",function(self,event,...)
			if event == v.EVENT then
				PanelOnShow(self,GetTime())
				self.title.text:SetText(v.title(...))
				self.content.text:SetText(v.content(...))
				PanelOnHide(self,GetTime()+v.duration)
			end
		end)
	end
end

-------test button---------
--local btn = CreateFrame("Button",nil,self)
--btn:SetSize(50,20)
--btn:SetPoint("CENTER",UIParent)
--btn.tex = btn:CreateTexture(nil,"OVERLAY")
--btn.tex:SetTexture(tex2)
--btn.tex:SetAllPoints(btn)
--btn.tex:SetVertexColor(0,0,0,1)
--
--
--btn:SetScript("OnClick",function()
--	if f.show then 
--		PanelOnHide(f)
--	else
--		PanelOnShow(f)
--	end
--end)
