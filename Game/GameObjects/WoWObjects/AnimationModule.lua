do
	XANESHPRACTICE.AnimationList={}
	
	XANESHPRACTICE.AnimationTemplate = {}
	local class=XANESHPRACTICE.AnimationTemplate
	class.__index = class

	function class.new()
		local self=setmetatable({}, class)
		return self 
	end
	
	-- static global
	function XANESHPRACTICE.AnimationTemplate.QuickSetup(animationlist,name,index,subindex,priority,duration,nextanimation)
		local template=XANESHPRACTICE.AnimationTemplate.new()
		template.name=name
		template.index=index
		template.subindex=subindex
		template.priority=priority
		template.duration=duration
		template.nextanimation=nextanimation
		
		animationlist[name]=template
	end	
end
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
do
	XANESHPRACTICE.AnimationList={}
	
	XANESHPRACTICE.Animation = {}
	local class=XANESHPRACTICE.Animation
	class.__index = class
	
	function class.new()
		local self=setmetatable({}, class)
		return self 
	end
	
	function class:Setup(template)
		for k,v in pairs(template) do
			self[k]=v	-- read: "self[k]=template[k]"
		end
		self.time=0
		--print("Animation.Setup",self)
	end
	
end

-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------

do
	XANESHPRACTICE.AnimationPriorities={}
	-- Attacks and priority movement (such as jumping).
	tinsert(XANESHPRACTICE.AnimationPriorities,"Active")
	-- Movement.
	tinsert(XANESHPRACTICE.AnimationPriorities,"Passive")
	-- At the moment, used only for ShuffleLeft/ShuffleRight animations.
	-- (Necessary to have its own group to avoid conflict with JumpEnd.)
	tinsert(XANESHPRACTICE.AnimationPriorities,"Shuffle")
	-- Idle/combat stances.
	tinsert(XANESHPRACTICE.AnimationPriorities,"Idle")	
end

do
	XANESHPRACTICE.AnimationModule = {}
	local class=XANESHPRACTICE.AnimationModule
	class.__index = class

	function class.new()
		local self=setmetatable({}, class)
		return self 
	end
	
	function class:Setup(owner_wowobject)
		self.owner=owner_wowobject
		self.animations={}
		--TODO LATER: this loop doesn't do anything, but it's included for readability...
		for k,v in ipairs(XANESHPRACTICE.AnimationPriorities) do
			self.animations[v]=nil
		end
		self:PlayAnimation(XANESHPRACTICE.AnimationList.Idle)
	end
	
	function class:PlayAnimation(animationtemplate)
		local animation=XANESHPRACTICE.Animation.new()
		animation:Setup(animationtemplate)
		self.animations[animation.priority]=animation
		if(animation.name=="ProjectileDespawnCustomDuration")then
			self.owner:OnProjectileDespawning()
		end		
	end
	
	function class:Step(elapsed)		
		-- choose the highest priority animation and play it
		-- do this BEFORE checking if animation has ended to avoid glitches at very low framerates
		for k,v in ipairs(XANESHPRACTICE.AnimationPriorities) do
			local animation=self.animations[v]
			if(animation)then	
				self.owner.displayobject:PlayAnimation(animation.index,animation.subindex)
				break
			end
		end
		-- then check if each animation has ended
		-- by the way, we have to loop through ipairs(priorities) instead of pairs(animations) because we might set animations to nil later
		for k,v in ipairs(XANESHPRACTICE.AnimationPriorities) do
			local animation=self.animations[v]
			if(animation)then
				animation.time=animation.time+elapsed
				local animationduration=animation.duration
				if(animation.name=="ProjectileSpawnCustomDuration")then
					animationduration=self.owner.projectilespawncustomduration
				elseif(animation.name=="ProjectileLoopCustomDuration")then
					animationduration=self.owner.projectileloopcustomduration
				elseif(animation.name=="ProjectileDespawnCustomDuration")then
					animationduration=self.owner.projectiledespawncustomduration
				end
				if(animationduration~=nil)then
					if(animation.time>animationduration)then
						-- if so, call nextanimation
						-- note that nextanimation is not necessarily the same priority as the existing animation						
						self.animations[v]=nil	
						if(animation.nextanimation~=nil)then
							self:PlayAnimation(animation.nextanimation)
						end
						if(animation.name=="ProjectileDespawnCustomDuration")then
							self.owner:OnProjectileDespawned()
						end								
					end
				end
			end
		end		
	end
	

end


--XANESHPRACTICE.AnimationTemplate.QuickSetup(animationlist,				name,			index,	subindex,	priority,	duration,	nextanimation)
XANESHPRACTICE.AnimationTemplate.QuickSetup(XANESHPRACTICE.AnimationList,"Idle",			0,		0,			"Idle",		nil,		nil)
XANESHPRACTICE.AnimationTemplate.QuickSetup(XANESHPRACTICE.AnimationList,"Run",				5,		0,			"Passive",	0.1,		nil)
XANESHPRACTICE.AnimationTemplate.QuickSetup(XANESHPRACTICE.AnimationList,"ShuffleLeft",		11,		0,			"Shuffle",	0.1,		nil)
XANESHPRACTICE.AnimationTemplate.QuickSetup(XANESHPRACTICE.AnimationList,"ShuffleRight",	12,		0,			"Shuffle",	0.1,		nil)
XANESHPRACTICE.AnimationTemplate.QuickSetup(XANESHPRACTICE.AnimationList,"Walkbackwards",	13,		0,			"Passive",	0.1,		nil)
XANESHPRACTICE.AnimationTemplate.QuickSetup(XANESHPRACTICE.AnimationList,"Stun",			14,		0,			"Active",	nil,		nil)
--XANESHPRACTICE.AnimationTemplate.QuickSetup(XANESHPRACTICE.AnimationList,"JumpStart",		37,		0,			"Active",	0.833,		nil)
XANESHPRACTICE.AnimationTemplate.QuickSetup(XANESHPRACTICE.AnimationList,"JumpStart2",		37,		0,			"Passive",	0.333,		nil)
XANESHPRACTICE.AnimationTemplate.QuickSetup(XANESHPRACTICE.AnimationList,"JumpStart",		37,		0,			"Active",	0.500,		XANESHPRACTICE.AnimationList.JumpStart2)
XANESHPRACTICE.AnimationTemplate.QuickSetup(XANESHPRACTICE.AnimationList,"Jump",			38,		0,			"Idle",		nil,		nil)
XANESHPRACTICE.AnimationTemplate.QuickSetup(XANESHPRACTICE.AnimationList,"JumpEnd",			39,		0,			"Passive",	1.134,		nil)
XANESHPRACTICE.AnimationTemplate.QuickSetup(XANESHPRACTICE.AnimationList,"JumpLandRun",		187,	0,			"Active",	0.333,		nil)
XANESHPRACTICE.AnimationTemplate.QuickSetup(XANESHPRACTICE.AnimationList,"Attack1H",		17,		0,			"Active",	1.0,		nil)
XANESHPRACTICE.AnimationTemplate.QuickSetup(XANESHPRACTICE.AnimationList,"ReadyUnarmed",	25,		0,			"Idle",		nil,		nil)
XANESHPRACTICE.AnimationTemplate.QuickSetup(XANESHPRACTICE.AnimationList,"Ready1H",			26,		0,			"Idle",		nil,		nil)
XANESHPRACTICE.AnimationTemplate.QuickSetup(XANESHPRACTICE.AnimationList,"ProjectileLoop",	158,	0,			"Idle",		nil,		nil)
XANESHPRACTICE.AnimationTemplate.QuickSetup(XANESHPRACTICE.AnimationList,"ProjectileSpawn500ms",0,	0,			"Idle",		0.5,		XANESHPRACTICE.AnimationList.ProjectileLoop)
--projectile CustomDuration names are HARD-CODED EXCEPTIONS.
-- Animation's owner will call OnExpiry after despawn animation completes.
XANESHPRACTICE.AnimationTemplate.QuickSetup(XANESHPRACTICE.AnimationList,"ProjectileDespawnCustomDuration",159,	0,		"Idle",		nil,nil)
XANESHPRACTICE.AnimationTemplate.QuickSetup(XANESHPRACTICE.AnimationList,"ProjectileLoopCustomDuration",158,	0,			"Idle",		nil,XANESHPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
XANESHPRACTICE.AnimationTemplate.QuickSetup(XANESHPRACTICE.AnimationList,"ProjectileSpawnCustomDuration",0,	0,			"Idle",		nil,XANESHPRACTICE.AnimationList.ProjectileLoopCustomDuration)
XANESHPRACTICE.AnimationTemplate.QuickSetup(XANESHPRACTICE.AnimationList,"PriReadySpellCast",874,	0,			"Idle",		nil,		nil)