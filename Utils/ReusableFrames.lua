-- The ReusableFrames family doesn't behave like the other classes in this program.
-- Treat these as global, static functions.


--TODO: NOTE: changing defaultparent doesn't prevent frame flash after game restart

_XANESHPRACTICE_ReusableFrames_DefaultParent=UIParent
--XANESHPRACTICE.ReusableFrames_DefaultParent=nil		-- pretty much confirmed client crash.

_XANESHPRACTICE_ReusableFrames = {}
_XANESHPRACTICE_ReusableFrames.__index = _XANESHPRACTICE_ReusableFrames

function _XANESHPRACTICE_ReusableFrames.new()
	local self=setmetatable({}, _XANESHPRACTICE_ReusableFrames)	
	return self
end

--TODO LATER: inactiveframes/activeframes/nextframeid are apparently part of THIS instance only
-- and not part of "base" ReusableFrames (which is intended to act as a singleton).
-- is this a problem?  should we care if this is a problem?
XANESHPRACTICE.ReusableFrames=_XANESHPRACTICE_ReusableFrames.new()
XANESHPRACTICE.ReusableFrames.inactiveframes={}
XANESHPRACTICE.ReusableFrames.activeframes={}
XANESHPRACTICE.ReusableFrames.nextframeid=0

----TODO: restore this function if it's unrelated to the particleframe issue

function _XANESHPRACTICE_ReusableFrames:GetFrame()
	local f=tremove(self.inactiveframes)
	if not f then
		local framename=self:NextFrameName()
		f=self:CreateNewFrame(framename)
		--print("Created a new frame",f.name)
		-- if(framename=="XANESHPRACTICE.ReusableFrame49")then
			-- error("breakpoint: frame 49")
		-- end

		-- most gameobjects expect to have a "self.frame", but they aren't required to keep track of what type of frame that is
		-- (could be normal frame, buttonframe, modelframe, scrollframe, etc)
		-- so we'll store a reference to the cleanup function in the frame itself
		f.framefamily=self
		f.Cleanup=function(self)f.framefamily:RemoveFrame(f)end
		-- we can now call f:Cleanup()
		
		
		self.nextframeid=self.nextframeid+1
	else
		--print("Recycled an existing frame",f.name)
		--
		if(f:GetParent()~=_XANESHPRACTICE_ReusableFrames_DefaultParent)then
			print("WARNING: frame "..tostring(f:GetName()).."'s parent is not defaultparent but "..tostring(f:GetParent():GetName()).." instead")
		end
	end
	--print("ReusableFrames getting a frame ",f.name)
	tinsert(self.activeframes,f)

	-- NEW
	-- This might break something else
	f:Show()
	
	return f
end


function _XANESHPRACTICE_ReusableFrames:NextFrameName()
	return "XANESHPRACTICE.ReusableFrame"..tostring(self.nextframeid);	
end

-------------------------PRIVATE FUNCTION-------------------------
function _XANESHPRACTICE_ReusableFrames:CreateNewFrame(framename)
	local f=self:ReturnCreateFrameDetails(framename)
	f.id=self.nextframeid
	f.name=framename
	f.tag="(no tag)"		
	--TODO: maybe move texture to its own function too, maybe
	f.texture = f:CreateTexture()
	f.fontstring=f:CreateFontString(nil, "ARTWORK")
	self:ResetProperties(f)
	return f
end

function _XANESHPRACTICE_ReusableFrames:ReturnCreateFrameDetails(framename)
	return CreateFrame("Frame",framename,_XANESHPRACTICE_ReusableFrames_DefaultParent)
end

function _XANESHPRACTICE_ReusableFrames:ResetProperties(f)
	-- override as necessary
	
	
	f.framelevel=0	
	f:SetParent(_XANESHPRACTICE_ReusableFrames_DefaultParent)	
	f:SetFrameLevel(f.framelevel)	
	
	-- --!!!!!!!!!!!!!!! client crash was apparently related to SetParent(nil) without Hiding the frame.
	-- f:Show()
	-- -- f:Hide()
	-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	
	-- if(f.SetCustomCamera)then f:SetCustomCamera(0) end
	
	-- --f:SetAlpha(1)	--original line.  caused screen flash.  TODO: remove line as soon as we're sure we fixed anything that broke
	f:SetAlpha(0) 	-- does not cause screen flash, as far as we know
	
	-- --f:Show()		-- note: commenting f:Hide() above and uncommenting this line causes a client crash upon game shutdown
						-- -- commenting f:Hide() and NOT uncommenting this line also causes a client crash upon game shutdown!
	
	-- ----TODO LATER: vague memory that explicitly disabling mouse here causes problems; keep an eye on
	f:EnableMouse(false)
	f:EnableMouseWheel(false)
	-- -- Event handlers are not included here; must remove those manually.  (TODO LATER: are we unable to do that automatically?)	
	
	-- --TODO LATER: is it necessary to clearallpoints before setallpoints?
	f:ClearAllPoints()	
	
	-- --TODO: NOTE: calling setsize(1,1) doesn't prevent frame flash after game restart
	-- f:SetSize(1,1)
		
	-- polyframe textures don't use SetAllPoints, so we need to reset that property here
	-- TODO: *maybe* move poly frames to their own class?
	f.texture:Show()
	f.texture:ClearAllPoints()	
	f.texture:SetAllPoints(f)
	f.texture:SetTexture(nil)
	f.texture:SetColorTexture(0,1,1,0.5)		
	--f.texture:SetTexCoord(0,1,0,1)	--TODO: why did we comment this out instead of removing it
	f.texture:SetTexCoord(0,0, 0,1, 1,0, 1,1)	
										-- --  R G B A R G B A
	f.texture:SetGradientAlpha("HORIZONTAL",1,1,1,1,1,1,1,1);
	f.texture:Hide()

	
	f.fontstring:Show()
	f.fontstring:SetAllPoints(f)	
	f.fontstring:SetFont("Fonts\\FRIZQT__.TTF",14,"OUTLINE")
	f.fontstring:SetTextHeight(14)	
	f.fontstring:SetTextColor(1,1,1,1)
	f.fontstring:Hide()
	
	-- if(f.animgroup~=nil) then
		-- f.animgroup:Stop()
		-- f.animgroup=nil
	-- end
	-- if(f.texture.animgroup~=nil)then
		-- f.texture.animgroup:Stop()
		-- f.texture.animgroup=nil
	-- end	
	-- f.animgroup=nil
	
	-- -- Frame might also be given an "owner" property by the owning drawable.
	-- -- Don't reset that in case we need to track it and/or debug it later.

	
	-- OK so... Hide is still necessary here even though we fixed the SetParent(nil) crash.
	-- If we're calling this from a ReusableButtonFrame, we're about to call EnableMouse(true)
		-- and that's a problem because the frame is still somewhere on screen, able to catch mouse events, unseen with SetAlpha(0).
	-- So we're going to attempt to solve this by calling frame:Show after GetFrame.
	f:Hide()

end

function _XANESHPRACTICE_ReusableFrames:RemoveFrame(f)
	--print("RemoveFrame",f.name)
	self:ResetProperties(f)

	f:SetParent(_XANESHPRACTICE_ReusableFrames_DefaultParent)	
	if(f:GetParent()~=_XANESHPRACTICE_ReusableFrames_DefaultParent)then
		print("WARNING: after cleanup, frame "..tostring(f:GetName()).."'s parent is not defaultparent but "..tostring(f:GetParent():GetName()).." instead")
	end
	--if(f.texture:GetTexture()~="Color-0ffff80-CSimpleTexture")then	-- pre-8.1.5
	
	local defaulttexturestring,defaulttexture
	if(XANESHPRACTICE.TOCVersion<=80100)then	
		defaulttexture=nil	
	else
		--defaulttexture="FileData ID 0"
		defaulttexture=nil
	end
	defaulttexturestring=defaulttexture
	if(f.texture:GetTexture()~=defaulttexture)then		-- 8.1.5+
		
		print("WARNING: after cleanup, frame "..tostring(f:GetName()).."'s texture is not "..tostring(defaulttexturestring).." but "..tostring(f.texture:GetTexture()).." instead")
	end
	
	local activecount=#self.activeframes
	XANESHPRACTICE.tremovebyval(self.activeframes,f)	
	if(#self.activeframes==activecount)then
		print("WARNING: failed to remove a frame from XANESHPRACTICE.ReusableFrames.activeframes")
	end
	if(XANESHPRACTICE.tcontains(self.inactiveframes,f))then		
		local errorstring="XANESHPRACTICE.ReusableFrames.inactiveframes already contains "..tostring(f).." "..f.name.." "..f.tag
		print("WARNING: "..errorstring)
		--error(errorstring)
	else
		tinsert(self.inactiveframes,f)
	end	
end

function _XANESHPRACTICE_ReusableFrames:ResetAllActiveFrames()
	local looping=true
	if(#self.activeframes>0)then
		XANESHPRACTICE.debugprint("WARNING: after cleanup on reusable frames, "..#self.activeframes.." frames remaining")
	end				
	while looping do
		looping=false
		local f
		f=nil		
		if(#self.activeframes>0) then			
			f=self.activeframes[1]
		end
		if not f then
			-- do nothing
		else
			--self.RemoveFrame(f)
			self:RemoveFrame(f)
			if(f:GetParent()~=_XANESHPRACTICE_ReusableFrames_DefaultParent)then
				--XANESHPRACTICE.debugprint("WARNING: during force cleanup, frame "..tostring(f:GetName()).."'s parent is not defaultparent but "..tostring(f:GetParent():GetName()).." instead")
			end
			--print("Force cleanup on ReusableFrames: "..f:GetName().." cleaned up, "..#self.activeframes.." frames remaining")

			looping=true
		end
	end
	-- --DO NOT SET NEXTFRAMEID TO ZERO DURING A STANDARD RESET.
	-- --NEXTFRAMEID IS USED TO SET THE INDEX OF A NEWLY-CREATED FRAME IN THE FRAME LIST.
	-- --IF NEXTFRAMEID IS SET TO ZERO, THE EXISTING RECYCLED FRAMES WILL BE OVERWRITTEN BY THE NEWLY-CREATED FRAMES
	-- --self.nextframeid=0   <-- DON'T DO THIS.
	-- --There's no way to force the frame names to appear in the same order every time the program is run
		-- --...not without sorting the entire inactive frame table by name after a reset.
	-- --Inactive frames are placed in their table in order they're cleaned up.
end

function _XANESHPRACTICE_ReusableFrames.ResetAndReport()
	local oktotal=#XANESHPRACTICE.ReusableFrames.inactiveframes
				+#XANESHPRACTICE.ReusableModelFrames.inactiveframes
				+#XANESHPRACTICE.ReusableModelSceneFrames.inactiveframes
				+#XANESHPRACTICE.ReusableParticleFrames.inactiveframes
				+#XANESHPRACTICE.ReusableButtonFrames.inactiveframes				
				+#XANESHPRACTICE.ReusableScrollFrames.inactiveframes
	local leftovertotal=#XANESHPRACTICE.ReusableFrames.activeframes
				+#XANESHPRACTICE.ReusableModelFrames.activeframes
				+#XANESHPRACTICE.ReusableModelSceneFrames.activeframes
				+#XANESHPRACTICE.ReusableParticleFrames.activeframes
				+#XANESHPRACTICE.ReusableButtonFrames.activeframes
				+#XANESHPRACTICE.ReusableScrollFrames.activeframes
	--XANESHPRACTICE.debugprint("Properly cleaned up "..tostring(oktotal).." frames.  Running force cleanup on "..tostring(leftovertotal).." frames.")
	if(leftovertotal==0)then
		--print("Xanesh Practice: successfully cleaned up all active frames.")
	else
		-- don't show warning if we think game crashed (if game crashes, leftover frames are to be expected)
		if(XANESHPRACTICE and not XANESHPRACTICE.alreadyattemptederrorshutdown)then
			print("WARNING: "..leftovertotal.." out of "..tostring(oktotal+leftovertotal).." frames remaining after cleanup.")
			print("Please /reload before running Xanesh Practice again.")
		end
	end
	
	XANESHPRACTICE.ReusableFrames:ResetAllActiveFrames()
	XANESHPRACTICE.ReusableModelFrames:ResetAllActiveFrames()
	XANESHPRACTICE.ReusableModelSceneFrames:ResetAllActiveFrames()
	XANESHPRACTICE.ReusableParticleFrames:ResetAllActiveFrames()
	XANESHPRACTICE.ReusableButtonFrames:ResetAllActiveFrames()
	XANESHPRACTICE.ReusableScrollFrames:ResetAllActiveFrames()
	XANESHPRACTICE.ReusableLeftalignedTextFrames:ResetAllActiveFrames()
	
end

function _XANESHPRACTICE_ReusableFrames:Report()
	XANESHPRACTICE.debugprint("Checking ReusableFrames only...")
	XANESHPRACTICE.debugprint(tonumber(#self.activeframes).." active frames")
	XANESHPRACTICE.debugprint(tonumber(#self.inactiveframes).." inactive frames")
	for i=1,#self.inactiveframes,1 do
		local f=self.inactiveframes[i]
		if(f:GetParent()~=_XANESHPRACTICE_ReusableFrames_DefaultParent)then
			XANESHPRACTICE.debugprint("Frame "..tostring(f:GetName()).."'s parent is not defaultparent but "..tostring(f:GetParent():GetName()).." instead")
		end
		XANESHPRACTICE.debugprint("Frame "..tostring(f:GetName()).."'s parent is "..tostring(f:GetParent():GetName()))
	end
end

function _XANESHPRACTICE_ReusableFrames:ForceReset()
	self.inactiveframes={}
	self.activeframes={}
	self.nextframeid=0
end

-- TODO: prohibit using this unless debug option is enabled
function _XANESHPRACTICE_ReusableFrames:ForceFullReset()
	XANESHPRACTICE.ReusableFrames:ForceReset()
	XANESHPRACTICE.ReusableModelFrames:ForceReset()
	XANESHPRACTICE.ReusableModelSceneFrames:ForceReset()
	XANESHPRACTICE.ReusableParticleFrames:ForceReset()
	XANESHPRACTICE.ReusableButtonFrames:ForceReset()
	XANESHPRACTICE.ReusableScrollFrames:ForceReset()
	XANESHPRACTICE.ReusableLeftalignedTextFrames:ForceReset()
end

--/run XANESHPRACTICE.ReusableFrames:Audit()
--/run print(XANESHPRACTICE.ReusableFrame0.texture:GetTexture())
--/run print(XANESHPRACTICE.ReusableFrame0.owner.owner.visible)
--/run print(XANESHPRACTICE.ReusableFrame0:IsShown())
function _XANESHPRACTICE_ReusableFrames:Audit()
	local uiparentcounter=0
	for i=1,#self.activeframes do
		local f=self.activeframes[i]	
		if(f:GetParent()==_XANESHPRACTICE_ReusableFrames_DefaultParent)then
			uiparentcounter=uiparentcounter+1
			--print("Frame "..tostring(f:GetName()).."'s parent is defaultparent")
		end
	end	
	print(#XANESHPRACTICE.ReusableFrames.activeframes,"active frames,",#XANESHPRACTICE.ReusableFrames.inactiveframes,"inactive frames")
	--print(uiparentcounter,"active frames with parent UIParent")
	print(uiparentcounter,"active frames with defaultparent")
	print("Nextframeid",self.nextframeid)
	
end