_XANESHPRACTICE_ReusableLeftalignedTextFrames = XANESHPRACTICE.inheritsFrom(_XANESHPRACTICE_ReusableFrames)

XANESHPRACTICE.ReusableLeftalignedTextFrames=_XANESHPRACTICE_ReusableLeftalignedTextFrames.new()
XANESHPRACTICE.ReusableLeftalignedTextFrames.inactiveframes={}
XANESHPRACTICE.ReusableLeftalignedTextFrames.activeframes={}
XANESHPRACTICE.ReusableLeftalignedTextFrames.nextframeid=0

function _XANESHPRACTICE_ReusableLeftalignedTextFrames:NextFrameName()	
	return "XANESHPRACTICE.ReusableLeftalignedTextFrame"..tostring(self.nextframeid);
end

function _XANESHPRACTICE_ReusableLeftalignedTextFrames:ResetProperties(f)	
	XANESHPRACTICE.ReusableFrames.ResetProperties(self,f)
	f.fontstring:SetJustifyH("LEFT")
end

