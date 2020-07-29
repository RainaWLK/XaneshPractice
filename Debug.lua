XANESHPRACTICE.DEBUG={}

-- CHANGE THIS LINE TO FALSE BEFORE PUBLISHING
if(false)then
	XANESHPRACTICE.DEBUG.debugprint=true
	XANESHPRACTICE.DEBUG.extraslashcommands=true	
	
	-- when true, /xp can open multiple games at once
	-- XANESHPRACTICE.DEBUG.allowmultiboxing=true
	
	-- when true, /xp will shutdown and restart instead of displaying an error message
	-- XANESHPRACTICE.DEBUG.autoshutdownrestart=true
	
	-- change this key to whatever our /reload macro is set to
	-- change to nil (not "false") to disable
	XANESHPRACTICE.DEBUG.extrapassthrukeycode="R"
	

end


function XANESHPRACTICE.debugprint(str)
	if(XANESHPRACTICE.DEBUG.debugprint)then
		print(str)
	end
end



function XANESHPRACTICE.FrameVisibilityCheck(frame)
	if(not XANESHPRACTICE)then local XANESHPRACTICE=self.XANESHPRACTICE end
	print("Checking frame",tostring(frame))
	print("Name:",tostring(frame.name))
	print("Parent:",tostring(frame:GetParent()))
	print("Width:",frame:GetWidth())
	print("Height:",frame:GetHeight())	
	print("Framelevel:",frame:GetFrameLevel())	
	print("Shown:",frame:IsShown())
	print("Alpha:",frame:GetAlpha())	-- GetAlpha() does not actually grant alpha access.  I've tried.
	--DevTools_Dump(frame:GetAllPoints())	
end

