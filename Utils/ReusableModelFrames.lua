_XANESHPRACTICE_ReusableModelFrames = XANESHPRACTICE.inheritsFrom(_XANESHPRACTICE_ReusableFrames)

XANESHPRACTICE.ReusableModelFrames=_XANESHPRACTICE_ReusableModelFrames.new()
XANESHPRACTICE.ReusableModelFrames.inactiveframes={}
XANESHPRACTICE.ReusableModelFrames.activeframes={}
XANESHPRACTICE.ReusableModelFrames.nextframeid=0

function _XANESHPRACTICE_ReusableModelFrames:NextFrameName()	
	return "XANESHPRACTICE.ReusableModelFrame"..tostring(self.nextframeid);
end



function _XANESHPRACTICE_ReusableModelFrames:ReturnCreateFrameDetails(framename)
	return CreateFrame("DressUpModel",framename,UIParent)
	--return CreateFrame("PlayerModel",framename,UIParent)
end

-- 
--frame:SetCamera(0) -- full view (i.e. not facecam)

function _XANESHPRACTICE_ReusableModelFrames:ResetProperties(f)	
	XANESHPRACTICE.ReusableFrames.ResetProperties(self,f)
	f:SetCamera(1)
	f:SetPosition(0,0,0)
	f:SetRotation(0)
	f:SetModelScale(1)
	f:SetModelAlpha(1)
	f:SetDesaturation(0.0)
	f:UseModelCenterToTransform(false)
end