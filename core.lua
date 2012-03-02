local addon,ns = ...
local Growl = ns.Growl
local CFG = ns.CFG
local DATA = ns.DATA

local Objects = {}

for i = 1, CFG.OBJECTS_NUM do
	Objects[i] = CreateFrame("Frame","Growl"..i,UIParent)
	Growl:New(CFG.POINT,Objects[i])
	Objects[i]:SetScript("OnEnter",function() Growl:OnEnter(Objects[i]) end)
	Objects[i]:SetScript("OnLeave",function() Growl:OnLeave(Objects[i]) end)
end

Growl:Sort(Objects,DATA)
