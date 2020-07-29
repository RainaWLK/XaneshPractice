_XANESHPRACTICE_ReusableModelSceneFrames = XANESHPRACTICE.inheritsFrom(_XANESHPRACTICE_ReusableFrames)

XANESHPRACTICE.ReusableModelSceneFrames=_XANESHPRACTICE_ReusableModelSceneFrames.new()
XANESHPRACTICE.ReusableModelSceneFrames.inactiveframes={}
XANESHPRACTICE.ReusableModelSceneFrames.activeframes={}
XANESHPRACTICE.ReusableModelSceneFrames.nextframeid=0

function _XANESHPRACTICE_ReusableModelSceneFrames:NextFrameName()	
	return "XANESHPRACTICE.ReusableModelSceneFrame"..tostring(self.nextframeid);
end

function _XANESHPRACTICE_ReusableModelSceneFrames:ReturnCreateFrameDetails(framename)
	local f=CreateFrame("ModelScene",framename,UIParent)
	f.inactiveactors={}
	f.activeactors={}
	f.nextactorid=0
	return f
	--return CreateFrame("PlayerModel",framename,UIParent)
end

function _XANESHPRACTICE_ReusableModelSceneFrames:ResetProperties(f)	
	XANESHPRACTICE.ReusableFrames.ResetProperties(self,f)
	f:SetCameraOrientationByYawPitchRoll(0,0.1,0)
	f:SetCameraPosition(0,0,0)
	f:Hide()	
	for i=#f.activeactors,1,-1 do
		local a=f.activeactors[i]
		a:Cleanup()
	end
end

function _XANESHPRACTICE_ReusableModelSceneFrames:ResetActorProperties(a)
	--print("reset a:",a)
	a:SetPosition(0,0,0)
	a:SetPitch(0)
	a:SetRoll(0)
	a:SetYaw(0)
	a:SetScale(1)
	--a:SetAlpha(1)
	a:SetAlpha(0)
	a:SetDesaturation(0.0)
	a:SetUseCenterForOrigin(false)
	a:Hide()	
end

function _XANESHPRACTICE_ReusableModelSceneFrames:GetActor(f)
	local a=tremove(f.inactiveactors)
	if not a then
		local actorname=XANESHPRACTICE.ReusableModelSceneFrames:NextActorName(f)
		a=f:CreateActor()		
		a.name=actorname
		a.tag="(tag)"
		a.frame=f
		--print("CreateActor a,f:",a,f)
		--print("Created a new frame",f.name)
		-- if(framename=="XANESHPRACTICE.ReusableFrame49")then
			-- error("breakpoint: frame 49")
		-- end

		a.Cleanup=function(self)XANESHPRACTICE.ReusableModelSceneFrames:RemoveActor(f,a)end

		f.nextactorid=f.nextactorid+1
	else
		--print("Recycled an existing actor",a.name)
		--
	end
	--print("ReusableModelSceneFrames getting an actor ",a.name)
	tinsert(f.activeactors,a)

	-- NEW
	-- This might break something else
	a:Show()
	
	return a
end

function _XANESHPRACTICE_ReusableModelSceneFrames:NextActorName(f)
	return "XANESHPRACTICE.ReusableModelSceneActor"..tostring(f.nextactorid);	
end


function _XANESHPRACTICE_ReusableModelSceneFrames:CreateNewActor(f)
	local a=f:CreateActor()
	a.Cleanup=function(self)XANESHPRACTICE.ReusableModelSceneFrames:RemoveActor(f,a)end
end


function _XANESHPRACTICE_ReusableModelSceneFrames:RemoveActor(f,a)	
	self:ResetActorProperties(a)

	local activecount=#f.activeactors
	XANESHPRACTICE.tremovebyval(f.activeactors,a)	
	if(#f.activeactors==activecount)then
		print("tremovebyval:",f.activeactors,a)
		print("WARNING: failed to remove an actor from XANESHPRACTICE.ReusableModelSceneFrames.activeactors")
		error(0)
	end
	if(XANESHPRACTICE.tcontains(f.inactiveactors,a))then		
		local errorstring="XANESHPRACTICE.ReusableModelSceneFrames.inactiveactors already contains "..tostring(a).." "..a.name.." "..a.tag
		print("WARNING: "..errorstring)
	else
		tinsert(f.inactiveactors,a)
	end	
end
