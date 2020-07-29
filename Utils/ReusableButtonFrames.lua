_XANESHPRACTICE_ReusableButtonFrames = XANESHPRACTICE.inheritsFrom(_XANESHPRACTICE_ReusableFrames)

XANESHPRACTICE.ReusableButtonFrames=_XANESHPRACTICE_ReusableButtonFrames.new()
XANESHPRACTICE.ReusableButtonFrames.inactiveframes={}
XANESHPRACTICE.ReusableButtonFrames.activeframes={}
XANESHPRACTICE.ReusableButtonFrames.nextframeid=0

function _XANESHPRACTICE_ReusableButtonFrames:NextFrameName()	
	return "XANESHPRACTICE.ReusableButtonFrame"..tostring(self.nextframeid);	
end

function _XANESHPRACTICE_ReusableButtonFrames:ResetProperties(f)	
	XANESHPRACTICE.ReusableFrames.ResetProperties(self,f)
	
	ActionButton_HideOverlayGlow(f)
	
	--TODO:
	--f:SetNormalTexture(f.texture)
	f:SetNormalTexture(nil)
	f:SetHighlightTexture(nil)
	f:SetPushedTexture(nil)
	
	
	f:SetScript("OnClick",nil)
	f:SetScript("OnEnter",nil)
	f:SetScript("OnLeave",nil)
	--TODO LATER: find out if this is redundant or necessary or even if anything we're doing actually prevents memory leaks
		--(it's certainly not necessary to register click events beforehand, if such a thing is even possible)
	f:UnregisterAllEvents()
	-- mouse is enabled on our buttons by default, so if we disabled it, turn it back on here
		-- note that this line overrides the previous EnableMouse(false) in ReusableFrames.ResetProperties
			-- -- this is one of the reasons ResetProperties hides frames by default
	f:EnableMouse(true)
	f:RegisterForClicks("AnyDown","AnyUp")
	
	--print("ReusableButtonFrames: GetHighlightTexture:",f:GetHighlightTexture())
end


function _XANESHPRACTICE_ReusableButtonFrames:ReturnCreateFrameDetails(framename)
	--return CreateFrame("Button",framename,UIParent)
	local f=CreateFrame("Button",framename,UIParent)
	--f:GetNormalTexture():SetAllPoints(f)
	--f:GetHighlightTexture():SetAllPoints(f)
	--f:GetPushedTexture():SetAllPoints(f)
	return f
end