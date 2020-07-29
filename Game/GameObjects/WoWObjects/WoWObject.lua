do
	local super=XANESHPRACTICE.GameObject
	XANESHPRACTICE.WoWObject=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.WoWObject

	function class:Setup(environment)
		super.Setup(self,environment)
		
		--TODO: move animationsystem to wowobject
		self.animationmodule=XANESHPRACTICE.AnimationModule.new()
		self.animationmodule:Setup(self)
		self:SetDefaultAnimation()
	end
	
	function class:SetCustomInfo()
		self.projectilespawncustomduration=0.5
		self.projectileloopcustomduration=2.0
		self.projectiledespawncustomduration=0.5
	end
	
	function class:CreateDisplayObject()
		self.displayobject=XANESHPRACTICE.ModelSceneActor.new()
		self.displayobject:Setup(self)
	end
	
	-- shortcut function to avoid defining a new DisplayObject_ModelSceneActor for every wowobject
	function class:SetActorAppearanceViaOwner(actor)
		if(not XANESHPRACTICE.PTR) then actor:SetModelByFileID(1) end		
	end
	function class:SetDefaultAnimation()
		--override
	end
	
	function class:Draw(elapsed)
	
		self.animationmodule:Step(elapsed)
	
		--self.displayobject:PlayAnimation(17)	-- #17 pretty reliably has multiple sequences
		--self.displayobject:PlayAnimation(5)	-- Run
		--self.displayobject:PlayAnimation(0)
		--self.displayobject:PlayAnimation(158)	
		
		
		
		self.displayobject:SetPositionAndScale(self.position,self.scale)
		self.displayobject:SetOrientation(self.orientation_displayed)
		
		local alpha=1
		if(self.expirytime and self.fadestarttime)then
			alpha=1-(self.environment.localtime-self.fadestarttime)/(self.expirytime-self.fadestarttime)
			if(alpha>1)then alpha=1 end
			if(alpha<0)then alpha=0 end
		end
		--TODO: check for auras		
		self.displayobject:SetAlpha(alpha)
		
	end
	
	function class:OnProjectileDespawning()
		--override.  called from AnimationModule:PlayAnimation when the new animation name is "ProjectileDespawnCustomDuration".
	end
	function class:OnProjectileDespawned()
		--override.  called from AnimationModule:PlayAnimation when animation "ProjectileDespawnCustomDuration" finishes playing.		
		self:Die()
	end	
end