local addon,growl = ...

local tex = "Interface\\AddOns\\Growl\\media\\sd"
local tex2 = "Interface\\Buttons\\WHITE8X8"
local close = "Interface\\AddOns\\Growl\\media\\close"
local close2 = "Interface\\AddOns\\Growl\\media\\close2"
local close3 = "Interface\\AddOns\\Growl\\media\\cls1"
local close4 = "Interface\\AddOns\\Growl\\media\\cls2"
--MainPanel
local f = CreateFrame("Button","GrowlPanel",UIParent)
f.nextUpdate = 0
f:SetSize(270,70)
f:SetPoint("TOPLEFT",UIParent,20,-20)
f.tex = f:CreateTexture(nil,"BACKGROUND")
f.tex:SetAllPoints(f)
f.tex:SetTexture(tex2)
f.tex:SetVertexColor(.1,.1,.1,.7)

--closeicon
f.close = CreateFrame("Button",nil,f)
f.close:SetSize(13,13)
f.close:SetPoint("TOPRIGHT",f,-5,-5)
f.close.tex = f.close:CreateTexture(nil,"OVERLAY")
f.close.tex:SetTexture(close)
f.close.tex:SetPoint("TOPLEFT",f.close)
f.close.tex:SetPoint("BOTTOMRIGHT",f.close)
f.close.tex:SetVertexColor(.3,.3,.3,.5)


--icon
f.icon = CreateFrame("Frame",nil,f)
f.icon:SetSize(f:GetHeight()-20,f:GetHeight()-20)
f.icon:SetPoint("TOPLEFT",f,10,-10)
f.icon.tex = f.icon:CreateTexture(nil,"OVERLAY")
f.icon.tex:SetTexture(tex)
f.icon.tex:SetAllPoints(f.icon)
f.icon.tex:SetVertexColor(1,1,1,.2)

--title
f.title = CreateFrame("Frame",nil,f)
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
f.content = CreateFrame("Frame",nil,f)
f.content:SetSize(f:GetWidth()-f.icon:GetWidth(),f:GetHeight()-f.title:GetHeight()-5)
f.content:SetPoint("TOPLEFT",f.title,"BOTTOMLEFT")
f.content.text = f.content:CreateFontString(nil,"OVERLAY")
f.content.text:SetFontObject(ChatFontNormal)
f.content.text:SetPoint("TOPLEFT",f.content)
f.content.text:SetText("test content")

f:SetAlpha(0)
f.show = false


local PanelOnShow = function(obj,time)
	local oldTime = time or GetTime()
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

local PanelOnEnter = function(obj)
	if obj.show then
		PanelOnShow(obj,GetTime())
	end
end

local PanelOnLeave = function(obj)
	if obj.show then
		PanelOnHide(obj,GetTime()+1)
	end
end

f:SetScript("OnEnter",function()
	print("OnEnter")
	PanelOnEnter(f)
end)

f:SetScript("OnLeave",function()
	print("OnLeave")
	PanelOnLeave(f)
end)

local btn = CreateFrame("Button",nil,self)
btn:SetSize(50,20)
btn:SetPoint("CENTER",UIParent)
btn.tex = btn:CreateTexture(nil,"OVERLAY")
btn.tex:SetTexture(tex2)
btn.tex:SetAllPoints(btn)
btn.tex:SetVertexColor(0,0,0,1)


btn:SetScript("OnClick",function()
	if f.show then 
		PanelOnHide(f)
	else
		PanelOnShow(f)
	end
end)
