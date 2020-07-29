_XANESHPRACTICE_ReusableCooldownFrames = XANESHPRACTICE.inheritsFrom(_XANESHPRACTICE_ReusableFrames)

XANESHPRACTICE.ReusableCooldownFrames=_XANESHPRACTICE_ReusableCooldownFrames.new()
XANESHPRACTICE.ReusableCooldownFrames.inactiveframes={}
XANESHPRACTICE.ReusableCooldownFrames.activeframes={}
XANESHPRACTICE.ReusableCooldownFrames.nextframeid=0

function _XANESHPRACTICE_ReusableCooldownFrames:NextFrameName()	
	return "XANESHPRACTICE.ReusableButtonFrame"..tostring(self.nextframeid);
end

function _XANESHPRACTICE_ReusableCooldownFrames:ResetProperties(f)	
	XANESHPRACTICE.ReusableFrames.ResetProperties(self,f)
	CooldownFrame_Set(f,0,0,false)
end


function _XANESHPRACTICE_ReusableCooldownFrames:ReturnCreateFrameDetails(framename)
	return CreateFrame("Cooldown",framename,UIParent)
end