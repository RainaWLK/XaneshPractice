do
	local super=XANESHPRACTICE.WoWObject
	XANESHPRACTICE.Mob=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.Mob
	
	function class:Setup(environment)
		super.Setup(self,environment)
		

		self:CreateAI()
		self:CreateCombatModule()		
		
		self.backpedal=false
		self.lockorientationtocamera=false
		
		
	end
	
	function class:SetupEnvironmentObjectListIndexStorage()
		super.SetupEnvironmentObjectListIndexStorage(self)
		tinsert(self.environmentobjectlists,self.environment.mobs)
	end	
	
	function class:SetCustomInfo()
		self.basemovespeed=7.0	
		self.backpedalspeed=4.5
	end
	
	function class:CreateAI()
		--TODO: self:CreateAI instead
		self.ai=XANESHPRACTICE.MobAI.new()
		self.ai:Setup(self)		
	end
	
	function class:CreateCombatModule()
		self.combatmodule=XANESHPRACTICE.CombatModule.new()
		self.combatmodule:Setup(self)
	end
	
	function class:SetTargetMob(mob)
		self.combatmodule:SetTargetMob(mob)
	end
	
	function class:Step(elapsed)
		super.Step(elapsed)
		
		
		self.ai:AIStep(elapsed)
		
		local vx=self.ai.moveinputvector.x
		local vy=self.ai.moveinputvector.y
	
		local unitvectorx=0
		local unitvectory=0
		local movespeed
		--setting movespeed now, but can be overridden later during specialmovement check
		movespeed=self:GetFinalMoveSpeed()
		
		if(vx~=0 or vy~=0)then
			local dist=math.sqrt(vx*vx+vy*vy)
			unitvectorx=vx/dist
			unitvectory=vy/dist
		end
		--print(vx,vy)
		local turnspeed=5
		if(unitvectorx==0 and unitvectory==0 and self.position.z<=0)then
			self.velocity.x=0
			self.velocity.y=0
			self.targetfacing_movement=nil
			turnspeed=5
			self.target_orientation_displayed.yaw=self.orientation.yaw
			--self.displayobject:PlayAnimation(0)
		elseif(unitvectorx~=0 or unitvectory~=0)then
			turnspeed=10
			if(self.position.z<=0)then
				self.velocity.x=unitvectorx*movespeed
				self.velocity.y=unitvectory*movespeed
			end
			local targetfacing
			--TODO: ask camera for targetfacing
			local angle=0
			-- if(self.currentfacing_3D)then angle=self.currentfacing_3D--+math.pi/2 
				-- print("Angle:",angle)
			-- end
			targetfacing=math.atan2(unitvectory,unitvectorx)
			if(self.backpedal)then 
				targetfacing=targetfacing+math.pi 
				--self.displayobject:PlayAnimation(13)
				self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.Walkbackwards)
			else
				--self.displayobject:PlayAnimation(5)
				self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.Run)
			end
			if(self.lockorientationtocamera)then
				self.target_orientation_displayed.yaw=self.orientation.yaw
				self.orientation_displayed.yaw=self.target_orientation_displayed.yaw
			end
			--!!!
			--if(self.position.z<=0)then
				self.target_orientation_displayed.yaw=math.atan2(self.velocity.y,self.velocity.x)			
			--end
			--self.orientation_displayed.yaw=math.atan2(self.velocity.y,self.velocity.x)
			if(self.backpedal)then self.target_orientation_displayed.yaw=self.target_orientation_displayed.yaw+math.pi end
		end
		
		local newyaw,yawchange=self:GetNewYawTurnAtSpeed(self.target_orientation_displayed.yaw,elapsed,turnspeed)		
		self.orientation_displayed.yaw=newyaw
		--print("yawchange:",yawchange)
		--if(unitvectorx==0 and unitvectory==0 and self.position.z<=0)then
		if(unitvectorx==0 and unitvectory==0)then
			if(yawchange==0)then
				if(not self.combatmodule.autoattacking)then
				--self.displayobject:PlayAnimation(0)
					self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.Idle)
				else
					self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.Ready1H)
				end
			elseif(yawchange>0)then
				--self.displayobject:PlayAnimation(11)
				self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ShuffleLeft)
			elseif(yawchange<0)then
				--self.displayobject:PlayAnimation(12)
				self.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ShuffleRight)
			end
		end
		
		--TODO: move to GameObject
		self.position.x=self.position.x+self.velocity.x*elapsed
		self.position.y=self.position.y+self.velocity.y*elapsed
		
		if(self.position.z>0 or self.velocity.z>0)then
			self.velocity.z=self.velocity.z+self.gravity*elapsed
		else
			self.position.z=0
			self.velocity.z=0
		end
		self.position.z=self.position.z+self.velocity.z*elapsed
		
	end
	
	
	function class:CombatPhase(elapsed)
		self.combatmodule:Step(elapsed)
	end

	
		-- Function should (eventually) account for all speed modifiers, snares, roots, etc.
	function class:GetFinalMoveSpeed()
		local finalspeed
		if(not self.backpedal)then
			finalspeed=self.basemovespeed
		else
			finalspeed=self.backpedalspeed
		end		
		return finalspeed
	end
	

	function class:GetNewYawTurnAtSpeed(targetyaw,elapsed,turnspeed,oldyaw)
		
		if(not oldyaw)then oldyaw=self.orientation_displayed.yaw end
		local difference=targetyaw-oldyaw
		
		if(difference<-math.pi) then difference=difference+math.pi*2 end
		if(difference>math.pi) then difference=difference-math.pi*2 end
		
		local yawchange=0;
		
		if(difference>0)then yawchange=turnspeed*elapsed end
		if(difference<0)then yawchange=-turnspeed*elapsed end
		if(difference>math.pi/2)then yawchange=difference-math.pi/2 end
		if(difference<-math.pi/2)then yawchange=difference-(-math.pi/2) end

		if(math.abs(math.abs(difference)-math.pi)<turnspeed*elapsed) then
			if(math.random()>.5)then
				yawchange=-yawchange
			end
		end
		
		local newyaw=oldyaw+yawchange
		
		if(math.abs(difference)<turnspeed*elapsed*2) then
			newyaw=targetyaw
		end	
		
		if(newyaw<-math.pi) then newyaw=newyaw+math.pi*2 end
		if(newyaw>math.pi) then newyaw=newyaw-math.pi*2 end	
		
		return newyaw,yawchange
	end
	
	function class:SetSelected(selected)
		self.selected=selected
		if(self.nameplate)then
			self.nameplate:SetSelected(selected)
		end
	end
	
	
	

	
	
end