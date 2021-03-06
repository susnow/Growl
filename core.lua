﻿local addon,ns = ...
local Growl = ns.Growl
local CFG = ns.CFG
local DATA = ns.DATA

local Objects = {}

for i = 1, CFG.OBJECTS_NUM do
	Objects[i] = CreateFrame("Button","Growl"..i,UIParent)
	Growl:New(Objects[i])
	Growl:SetAttributes(Objects[i],"Enter")
	Growl:SetAttributes(Objects[i],"Leave")
	Growl:SetAttributes(Objects[i],"Close")
	Growl:SetAttributes(Objects[i],"Clicks")
end

Growl:Load(Objects,DATA)
