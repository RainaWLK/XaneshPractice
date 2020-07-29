
XANESHPRACTICE.DEFAULTSCENARIO.ObeliskTelegraphScaleMultiplier=3
XANESHPRACTICE.DEFAULTSCENARIO.VoidBarrierScaleMultiplier=1.0

do
	local super=XANESHPRACTICE.WoWObject
	XANESHPRACTICE.DEFAULTSCENARIO.ObeliskSmall=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.DEFAULTSCENARIO.ObeliskSmall
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)		
		self.scale=0.175
		self.collisionradius=10*(28/84.0)*XANESHPRACTICE.DEFAULTSCENARIO.VoidBarrierScaleMultiplier
		self.rotationdirection=(math.random(1,2)-1)*2-1		-- -1 or 1
	end
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(3028882)	--8bl_cultist_miniobelisk03
	end
	function class:CreateAssociatedObjects()
		self.telegraph=XANESHPRACTICE.DEFAULTSCENARIO.VoidbarrierTelegraph.new()
		self.telegraph:Setup(self.environment)
		--self.telegraph.scale=0.4*XANESHPRACTICE.DEFAULTSCENARIO.ObeliskTelegraphScaleMultiplier
		self.telegraph.scale=(28/84.0)*XANESHPRACTICE.DEFAULTSCENARIO.ObeliskTelegraphScaleMultiplier
		self.telegraph.obelisk=self		
	end
	function class:Step(elapsed)
		super.Step(self,elapsed)
		self.orientation_displayed.yaw=self.orientation_displayed.yaw+elapsed*0.25*self.rotationdirection
	end
end

do
	local super=XANESHPRACTICE.DEFAULTSCENARIO.ObeliskSmall
	XANESHPRACTICE.DEFAULTSCENARIO.ObeliskLarge=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.DEFAULTSCENARIO.ObeliskLarge
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.scale=0.2
		self.collisionradius=10*(52/84.0)*XANESHPRACTICE.DEFAULTSCENARIO.VoidBarrierScaleMultiplier	
	end
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(3028883)	--8bl_cultist_miniobelisk04
	end
	function class:CreateAssociatedObjects()
		super.CreateAssociatedObjects(self)
		self.telegraph.scale=(52/84.0)*XANESHPRACTICE.DEFAULTSCENARIO.ObeliskTelegraphScaleMultiplier
	end
end

do
	local super=XANESHPRACTICE.WoWObject
	XANESHPRACTICE.DEFAULTSCENARIO.VoidbarrierTelegraph=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.DEFAULTSCENARIO.VoidbarrierTelegraph
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(2150550)	--target_azerite_state_centeronly						
		--actor:SetModelByFileID(1034148)	--target_azerite_state_centeronly						
	end
	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
		self.projectilespawncustomduration=0.25
		self.projectileloopcustomduration=2.0
		self.projectiledespawncustomduration=0.25		
	end	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		if(self.obelisk)then
			self.position={x=self.obelisk.position.x,y=self.obelisk.position.y,z=self.obelisk.position.z}
		end
	end
	function class:OnProjectileDespawning()
		local voidbarrier=XANESHPRACTICE.DEFAULTSCENARIO.VoidbarrierState.new()
		voidbarrier:Setup(self.environment)
		voidbarrier.position={x=self.position.x,y=self.position.y,z=self.position.z}
		voidbarrier.obelisk=self.obelisk
		voidbarrier.scale=self.scale/XANESHPRACTICE.DEFAULTSCENARIO.ObeliskTelegraphScaleMultiplier
		--print("Scale:",voidbarrier.scale)
	end
end

-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------

do
	local super=XANESHPRACTICE.WoWObject
	XANESHPRACTICE.DEFAULTSCENARIO.VoidbarrierState=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.DEFAULTSCENARIO.VoidbarrierState
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(3177003)	--8fx_headcultist_voidbarrier_state						
	end
	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
		self.projectilespawncustomduration=0.5
		self.projectileloopcustomduration=nil
		self.projectiledespawncustomduration=0.5
	end
	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		-- voidbarrier is not guaranteed to have an obelisk
		-- (if self.obelisk==nil, then we assume it's the barrier around azshara)
		if(self.obelisk)then
			self.position={x=self.obelisk.position.x,y=self.obelisk.position.y,z=self.obelisk.position.z}
			if(self.obelisk.dead)then
				self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
			end
		end
	end
end

-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------

do
	local super=XANESHPRACTICE.WoWObject
	XANESHPRACTICE.DEFAULTSCENARIO.VoidwokeState=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.DEFAULTSCENARIO.VoidwokeState
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.scale=2
		self.player=nil
	end
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(3152050)	--8fx_headcultist_voidwoke_state
	end
	function class:Step(elapsed)
		super.Step(self,elapsed)
		if(self.player)then			
			self.orientation_displayed.yaw=self.player.orientation_displayed.yaw
			self.position={x=self.player.position.x,y=self.player.position.y,z=self.player.position.z+3.5}
		end			
	end
	function class:Draw(elapsed)
		super.Draw(self,elapsed)
		if(self.player)then
			if(self.player.GetFinalAlpha)then	--ghost check			
				self.displayobject:SetAlpha(self.player:GetFinalAlpha())
			end
		end
	end
end

-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
do
	local super=XANESHPRACTICE.WoWObject
	XANESHPRACTICE.DEFAULTSCENARIO.GoalPortal=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.DEFAULTSCENARIO.GoalPortal
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(3152477)	--8fx_headcultist_voidwoke_portalbillboard
	end
	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
		self.projectilespawncustomduration=0.5
		self.projectileloopcustomduration=nil
		self.projectiledespawncustomduration=0.5
	end	
	function class:CreateAssociatedObjects()
		self.telegraph=XANESHPRACTICE.DEFAULTSCENARIO.GoalPortalTelegraph.new()
		self.telegraph:Setup(self.environment)		
		self.telegraph.portal=self
	end	
	function class:FadeOut()
		self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
		self.telegraph.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
	end
end

do
	local super=XANESHPRACTICE.WoWObject
	XANESHPRACTICE.DEFAULTSCENARIO.GoalPortalTelegraph=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.DEFAULTSCENARIO.GoalPortalTelegraph
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(2125936)	--cfx_warlock_genericportalvoid_notbillboarded_world
		self.scale=3
	end
	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
		self.projectilespawncustomduration=0.5
		self.projectileloopcustomduration=nil
		self.projectiledespawncustomduration=0.5
	end	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		if(self.portal)then
			self.position={x=self.portal.position.x,y=self.portal.position.y,z=-2}
			if(self.portal.dead)then
				self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
			end
		end
	end
end

-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------

do
	local super=XANESHPRACTICE.WoWObject
	XANESHPRACTICE.DEFAULTSCENARIO.StartPortal=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.DEFAULTSCENARIO.StartPortal
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(2125644)	--8fx_mythrax_oblivionsphere_orb_state		
		self.expirytime=self.environment.localtime+7.0
		self.fadestarttime=self.expirytime-2.0
	end
	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
		self.projectilespawncustomduration=0.5
		self.projectileloopcustomduration=nil
		--mythrax_oblivionsphere doesn't have a decay animation!
	end	
	function class:CreateAssociatedObjects()
		self.telegraph=XANESHPRACTICE.DEFAULTSCENARIO.StartPortalTelegraph.new()
		self.telegraph:Setup(self.environment)
		self.telegraph.portal=self
		self.swirl=XANESHPRACTICE.DEFAULTSCENARIO.StartPortalSwirl.new()
		self.swirl:Setup(self.environment)
		self.swirl.portal=self		
	end	
	function class:OnFadeStart()		
		local orb=XANESHPRACTICE.DEFAULTSCENARIO.VoidOrb.new()
		orb:Setup(self.environment)
		orb.position={x=self.position.x,y=self.position.y,z=4.0}
		orb.orientation_displayed.yaw=math.atan2(-orb.position.y,-orb.position.x)
		--print("Orb orientation:",orb.orientation_displayed.yaw)
		orb.scenario=self.scenario
		self.scenario.buttonphase=4
	end

end

do
	local super=XANESHPRACTICE.WoWObject
	XANESHPRACTICE.DEFAULTSCENARIO.StartPortalTelegraph=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.DEFAULTSCENARIO.StartPortalTelegraph
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(2125936)	--cfx_warlock_genericportalvoid_notbillboarded_world
		self.scale=3
	end
	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
		self.projectilespawncustomduration=0.5
		self.projectileloopcustomduration=5.0
		self.projectiledespawncustomduration=0.5
	end	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		if(self.portal)then
			self.position={x=self.portal.position.x,y=self.portal.position.y,z=-2}	
		end
	end
end

do
	local super=XANESHPRACTICE.WoWObject
	XANESHPRACTICE.DEFAULTSCENARIO.StartPortalSwirl=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.DEFAULTSCENARIO.StartPortalSwirl
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(2449820)	--8fx_void_precastbase
		self.scale=4
	end
	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
		self.projectilespawncustomduration=0.5
		self.projectileloopcustomduration=5.0
		self.projectiledespawncustomduration=0.5
	end	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		if(self.portal)then
			self.position={x=self.portal.position.x,y=self.portal.position.y,z=self.portal.position.z}
		end
	end
end

-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------

do
	local super=XANESHPRACTICE.WoWObject
	XANESHPRACTICE.DEFAULTSCENARIO.VoidOrb=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.DEFAULTSCENARIO.VoidOrb
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.nexthittime=0
		self.exploded=false
		self.ghostimpact=false
	end
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(3152115)	--8fx_headcultist_voidwoke_nzothorb
		self.scale=2.5
	end
	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
		self.projectilespawncustomduration=0.5
		self.projectileloopcustomduration=nil
		self.projectiledespawncustomduration=0.5
	end	
	function class:CreateAssociatedObjects()
		self.telegraph=XANESHPRACTICE.DEFAULTSCENARIO.VoidOrbTelegraph.new()
		self.telegraph:Setup(self.environment)
		self.telegraph.orb=self
		-- self.swirl=XANESHPRACTICE.DEFAULTSCENARIO.StartPortalSwirl.new()
		-- self.swirl:Setup(self.environment)
		-- self.swirl.portal=self		
	end	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		if(not self.exploded)then
			if(self.localtime>2.0)then
				if(self.scenario.paused==false)then
					if(self.localtime>=self.nexthittime)then
						local xdist=self.position.x-self.scenario.player.position.x
						local ydist=self.position.y-self.scenario.player.position.y
						local distsqr=xdist*xdist+ydist*ydist			
						--local ORB_IMPACT_DISTANCE=2.75
						--local ORB_IMPACT_DISTANCE=2.5
						local ORB_IMPACT_DISTANCE=2
						local impactplayer=nil
						if(distsqr<ORB_IMPACT_DISTANCE*ORB_IMPACT_DISTANCE)then
							impactplayer=self.scenario.player
							self.ghostimpact=false
						end
						for i=1,#self.scenario.ghosts do
							local ghost=self.scenario.ghosts[i]
							if(ghost.enabled)then
								local xdist=self.position.x-ghost.position.x
								local ydist=self.position.y-ghost.position.y
								local distsqr=xdist*xdist+ydist*ydist
								if(distsqr<ORB_IMPACT_DISTANCE*ORB_IMPACT_DISTANCE)then
									impactplayer=ghost
									self.ghostimpact=true
								end							
							end
						end
						if(impactplayer)then
							self.orientation_displayed.yaw=impactplayer.orientation_displayed.yaw
							self.nexthittime=self.localtime+2.0
							---- ORB IMPACT --------------------------------------
							local obj
							obj=XANESHPRACTICE.DEFAULTSCENARIO.OrbImpact.new()
							obj:Setup(self.environment)
							obj.orb=self							
							----------------------------------------------------------------------------
							--print("Debug: X",impactplayer.position.x,"Y",impactplayer.position.y,"yaw720",(impactplayer.orientation.yaw/(math.pi*2))*720)
							if(not XANESHPRACTICE.DEFAULTSCENARIO.PauseButtonWarning)then
								if(not self.scenario.useghosts)then
									XANESHPRACTICE.DEFAULTSCENARIO.PauseButtonWarning=true
									XANESHPRACTICE_RaidBossEmote("Use the pause button to run ahead of the orb and kick it again.",2.0,false)
								end
							end
						end
					end
					local xdist=self.position.x
					local ydist=self.position.y
					local distsqr=xdist*xdist+ydist*ydist			
					if(distsqr>=50*50)then
						self:Explode()
					end
					-- Azshara ring is hardcoded (so we don't accidentally delete it when deleting the other rings)
					if(distsqr<11.5*11.5)then
						self:Explode()
					end
					for i=1,#self.scenario.obelisks do
						local obj=self.scenario.obelisks[i]
						local xdist=self.position.x-obj.position.x
						local ydist=self.position.y-obj.position.y
						local distsqr=xdist*xdist+ydist*ydist	
						--local ORBRADIUS=2
						local ORBRADIUS=1.5
						if(distsqr<(obj.collisionradius+ORBRADIUS)*(obj.collisionradius+ORBRADIUS))then
							self:Explode()
						end
					end
					if(self.scenario.goalportal)then
						local goalportal=self.scenario.goalportal
						local xdist=self.position.x-goalportal.position.x
						local ydist=self.position.y-goalportal.position.y
						local distsqr=xdist*xdist+ydist*ydist	
						if(distsqr<3*3)then
							self:Success()
						end
					end
				
					--local ORB_SPEED=5
					local ORB_SPEED=5.5
					self.position.x=self.position.x+elapsed*ORB_SPEED*math.cos(self.orientation_displayed.yaw)
					self.position.y=self.position.y+elapsed*ORB_SPEED*math.sin(self.orientation_displayed.yaw)
					--print("Orb orientation:",self.orientation_displayed.yaw)
				end
			end
		end
	end
	function class:Explode()
		self.exploded=true
		self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
		local obj=XANESHPRACTICE.DEFAULTSCENARIO.GenericVoidNovaHigh.new()
		obj:Setup(self.environment)
		obj.position={x=self.position.x,y=self.position.y,z=0}
		self.scenario.soakstatus=0
		XANESHPRACTICE_RaidBossEmote("Try again...",2.0,false)
		self.scenario.buttonphase=1
		self.scenario:DeleteGoalPortal()
		self.scenario:DeleteGhosts()
	end
	function class:Success()
		self.exploded=true
		self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
		self.scenario.soakstatus=0
		XANESHPRACTICE_RaidBossEmote("GOAL!",2.0,false)
		self.scenario.buttonphase=1
		self.scenario:DeleteGoalPortal()
		self.scenario:DeleteGhosts()
	end
end

do
	local super=XANESHPRACTICE.WoWObject
	XANESHPRACTICE.DEFAULTSCENARIO.GenericVoidNovaHigh=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.DEFAULTSCENARIO.GenericVoidNovaHigh
				
	function class:SetActorAppearanceViaOwner(actor)
		--actor:SetModelByFileID(3055087)	--8fx_generic_void_novalow
		actor:SetModelByFileID(3055086)	--8fx_generic_void_novahigh
	end
	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
		self.projectilespawncustomduration=0.25
		self.projectileloopcustomduration=1.0
		self.projectiledespawncustomduration=0.25		
		self.scale=5
	end

	
end

do
	local super=XANESHPRACTICE.WoWObject
	XANESHPRACTICE.DEFAULTSCENARIO.OrbImpact=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.DEFAULTSCENARIO.OrbImpact
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(3152608)	--8fx_headcultist_voidwoke_orbimpact	
		self.scale=2.5
	end
	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ProjectileLoopCustomDuration)--TODO: wrong animation!
		self.projectilespawncustomduration=0
		self.projectileloopcustomduration=2.0
		self.projectiledespawncustomduration=0	
	end
	function class:Step(elapsed)
		super.Step(self,elapsed)
		if(self.orb)then
			self.position={x=self.orb.position.x,y=self.orb.position.y,z=4}
		end
	end
end

do
	local super=XANESHPRACTICE.WoWObject
	XANESHPRACTICE.DEFAULTSCENARIO.VoidOrbTelegraph=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.DEFAULTSCENARIO.VoidOrbTelegraph
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(1011918)	--target_fire_state_rimonly
		--self.scale=0.5
		self.scale=0.45
	end
	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
		self.projectilespawncustomduration=0.25
		self.projectileloopcustomduration=nil
		self.projectiledespawncustomduration=0.25
	end	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		if(self.orb)then
			self.position={x=self.orb.position.x,y=self.orb.position.y,z=0}
			if(self.orb.dead)then
				self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
			end
		end
	end
end


-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
do
	local super=XANESHPRACTICE.WoWObject
	XANESHPRACTICE.DEFAULTSCENARIO.VoidRitualSoak=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.DEFAULTSCENARIO.VoidRitualSoak
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.fadestarttime=self.environment.localtime+5.0
	end
	function class:SetActorAppearanceViaOwner(actor)
		self.fileid=1907392
		actor:SetModelByFileID(self.fileid) --8fx_rl_annihilation_state
		self.scale=1
	end
	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ProjectileLoop)
	end	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		if(self.scenario and self.scenario.player)then
			local player=self.scenario.player
			local xdist=player.position.x-self.position.x
			local ydist=player.position.y-self.position.y
			local distsqr=xdist*xdist+ydist*ydist
			local newfileid
			local RADIUS=2.3
			local ok=false
			if(distsqr<=RADIUS*RADIUS)then
				ok=true		-- future proofing in case we decide ghosts should interact with soaks
			end
			if(ok)then
				newfileid=1982733	--8fx_rl_annihilation_radius
			else
				newfileid=1907392				
			end
			if(newfileid~=self.fileid)then
				self.fileid=newfileid
				self.displayobject.drawable:SetModelByFileID(self.fileid)
			end
		end		
	end
	function class:OnFadeStart()
		super.OnFadeStart(self)
		self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
		if(self.fileid==1982733)then			
			self.scenario.soakstatus=2
		else
			if(self.scenario.soakstatus<2)then
				self.scenario.soakstatus=1
			end
		end
	end
end
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
do
	local super=XANESHPRACTICE.WoWObject
	XANESHPRACTICE.DEFAULTSCENARIO.VoidRitualPortalProjectile=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.DEFAULTSCENARIO.VoidRitualPortalProjectile

	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(2999412) --8fx_herald_maddeningeruption_missile		--TODO: find a better fileid
		self.scale=3
	end
	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
		self.projectilespawncustomduration=0.25
		self.projectileloopcustomduration=2.0
		self.projectiledespawncustomduration=0.25
	end		
	function class:Step(elapsed)
		super.Step(self,elapsed)
		local ratio=self.localtime/2.5
		self.position.x=self.scenario.xanesh.position.x+(self.destination.x-self.scenario.xanesh.position.x)*ratio
		self.position.y=self.scenario.xanesh.position.y+(self.destination.y-self.scenario.xanesh.position.y)*ratio	
		self.position.z=10*math.sin(ratio*math.pi)		
	end
	function class:OnProjectileDespawning()
		super.OnProjectileDespawned(self)
		local portal=self.portalclass.new()		
		portal:Setup(self.environment)
		portal.position={x=self.destination.x,y=self.destination.y,z=self.destination.z}
		portal.scenario=self.scenario		
		if(self.portalclass==XANESHPRACTICE.DEFAULTSCENARIO.GoalPortal)then
			self.scenario.goalportal=portal
		end
	end	
end
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------

do
	local super=XANESHPRACTICE.GameObject
	XANESHPRACTICE.DEFAULTSCENARIO.Guidelines1=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.DEFAULTSCENARIO.Guidelines1
	
	function class:CreateDisplayObject()
		self.displayobject=XANESHPRACTICE.DEFAULTSCENARIO.Guidelines1DisplayObject.new()
		self.displayobject:Setup(self)
	end
	
	function class:Draw(elapsed)
		self.displayobject:SetPositionAndScale(self.position,self.scale)
	end	
	function class:Select(toggle)
		-- do nothing!
	end
	function class:EnableMouse(toggle)
		-- do nothing!
	end
end

do
	local super=XANESHPRACTICE.DisplayObject
	XANESHPRACTICE.DEFAULTSCENARIO.Guidelines1DisplayObject=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.DEFAULTSCENARIO.Guidelines1DisplayObject
	
	function class:CreateDrawable()
		local f=XANESHPRACTICE.ReusableFrames:GetFrame()
		self.drawable=f	
		tinsert(self.drawables,f)	
	end
	function class:SetAppearance()
		self.drawable:Show();self.drawable:SetAlpha(0)
		self.parentframe=self.owner.environment.frame
		self.drawable:SetParent(self.parentframe)
		self.drawable:SetSize(5,400)
		self.drawable:SetFrameLevel(200)
		self.drawable.texture:Show()
		self.drawable.texture:SetColorTexture(1,0,0,1)
	end	
	function class:SetPositionAndScale(position,scale)
		self.drawable:SetPoint("BOTTOM",self.parentframe,"CENTER",0,30)
	end

end
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------

do
	local super=XANESHPRACTICE.GameObject
	XANESHPRACTICE.DEFAULTSCENARIO.Guidelines2=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.DEFAULTSCENARIO.Guidelines2
	
	function class:CreateDisplayObject()
		self.displayobject=XANESHPRACTICE.DEFAULTSCENARIO.Guidelines2DisplayObject.new()
		self.displayobject:Setup(self)
	end
	
	function class:Draw(elapsed)
		self.displayobject:SetPositionAndScale(self.position,self.scale)
	end	
	function class:Select(toggle)
		-- do nothing!
	end
	function class:EnableMouse(toggle)
		-- do nothing!
	end
end

do
	local super=XANESHPRACTICE.DisplayObject
	XANESHPRACTICE.DEFAULTSCENARIO.Guidelines2DisplayObject=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.DEFAULTSCENARIO.Guidelines2DisplayObject
	
	function class:CreateDrawable()
		local f=XANESHPRACTICE.ReusableFrames:GetFrame()
		self.drawable=f	
		self.left=f
		tinsert(self.drawables,f)
		local f=XANESHPRACTICE.ReusableFrames:GetFrame()
		self.right=f
		tinsert(self.drawables,f)		
	end
	function class:SetAppearance()
		self.left:Show();self.left:SetAlpha(1)
		self.parentframe=self.owner.environment.frame
		self.left:SetParent(self.parentframe)
		self.left:SetSize(4,400)
		self.left:SetFrameLevel(200)
		self.left.texture:Show()
		self.left.texture:SetColorTexture(0.7,0.7,0.7,0.8)
		self.right:Show();self.right:SetAlpha(1)
		self.right:SetParent(self.left)
		self.right:SetSize(4,400)
		self.right:SetFrameLevel(200)
		self.right.texture:Show()
		self.right.texture:SetColorTexture(0.7,0.7,0.7,0.8)
		self.drawable:SetAlpha(0)
	end	
	function class:SetPositionAndScale(position,scale)
		local RADIUS=10
		self.left:SetPoint("BOTTOM",self.parentframe,"CENTER",-RADIUS,-10)
		self.right:SetPoint("BOTTOMLEFT",self.left,"BOTTOMLEFT",RADIUS*2,0)		
		--self.drawable:SetAllPoints(self.parentframe)
	end

end