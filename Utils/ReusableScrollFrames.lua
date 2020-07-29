-- Each scrollframe comes with its own parent frame.  frame is f; scrollframe is f.scrollframe
-- BE SURE TO MANUALLY CALL SETSCROLLCHILD AFTER CALLING GETFRAME(),
-- EVEN IF IT LOOKS LIKE WE'RE CALLING SETSCROLLCHILD DURING THAT VERY FUNCTION.
-- We call SetScrollChild during getFrame, but it tends to break if we make any adjustments afterwards.

-- Important: 3D modelframes, such as DressUpModel, must each have a UNIQUE SetFrameLevel in order to respect scrollframe boundaries.
	-- so, for example, you can't place multiple telegraph models on the same framelevel
	-- (unless you use a 3D camera, where the frame doesn't move outside of the window).
		-- Apprently, modelframe.texture must also be visible (but colortexture can be 0,0,0,0)
		

_XANESHPRACTICE_ReusableScrollFrames = XANESHPRACTICE.inheritsFrom(_XANESHPRACTICE_ReusableFrames)

XANESHPRACTICE.ReusableScrollFrames=_XANESHPRACTICE_ReusableScrollFrames.new()
XANESHPRACTICE.ReusableScrollFrames.inactiveframes={}
XANESHPRACTICE.ReusableScrollFrames.activeframes={}
XANESHPRACTICE.ReusableScrollFrames.nextframeid=0

function _XANESHPRACTICE_ReusableScrollFrames:NextFrameName()	
	return "XANESHPRACTICE.ReusableScrollFrame"..tostring(self.nextframeid);
end

function _XANESHPRACTICE_ReusableScrollFrames:ReturnCreateFrameDetails(framename)
	local f = CreateFrame("Frame",framename.."_scrollchild",UIParent)
	f.scrollframe=CreateFrame("ScrollFrame",framename.."_scrollframe",UIParent)
	-- REMEMBER, DON'T TRUST THIS LINE.  CALL SETSCROLLCHILD YOURSELF AFTER ADJUSTING FRAME APPEARANCE.
	f.scrollframe:SetScrollChild(f)
	
	return f
end

function _XANESHPRACTICE_ReusableScrollFrames:ResetProperties(f)	
	XANESHPRACTICE.ReusableFrames.ResetProperties(self,f)
	--f:SetScrollChild(nil)
	f.scrollframe:SetScrollChild(nil)
	f.scrollframe:SetHorizontalScroll(0)
	f.scrollframe:SetVerticalScroll(0)
	f.scrollframe:SetParent(f)
	f:SetScale(1)	
end