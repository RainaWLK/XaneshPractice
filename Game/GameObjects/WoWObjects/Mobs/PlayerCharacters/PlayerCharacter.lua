do
	local super=XANESHPRACTICE.Mob
	XANESHPRACTICE.PlayerCharacter=XANESHPRACTICE.inheritsFrom(XANESHPRACTICE.Mob)
	local class=XANESHPRACTICE.PlayerCharacter

	
	function class:CreateDisplayObject()
		self.displayobject=XANESHPRACTICE.ModelSceneActor.new()
		self.displayobject:Setup(self)
		self.displayobject.drawable:SetModelByUnit("player")
	end
	
		--self.displayobject:PlayAnimation(11)	--ShuffleLeft
		--self.displayobject:PlayAnimation(12) --ShuffleRight
	
	function class:GetFinalMoveSpeed()
		local movespeed=super.GetFinalMoveSpeed(self)
		-- !!! HARDCODED XANESH VOID ZONES
		if(self.scenario)then
			for i=1,#self.scenario.obelisks do
				local obj=self.scenario.obelisks[i]
				if(obj.localtime>2.5)then
					local xdist=self.position.x-obj.position.x
					local ydist=self.position.y-obj.position.y
					local distsqr=xdist*xdist+ydist*ydist	
					local PLAYERRADIUS=0
					if(distsqr<(obj.collisionradius+PLAYERRADIUS)*(obj.collisionradius+PLAYERRADIUS))then
						movespeed=movespeed*0.5
					end
				end
			end
			--Azshara
			local xdist=self.position.x
			local ydist=self.position.y
			local distsqr=xdist*xdist+ydist*ydist	
			if(distsqr<10*10)then
				movespeed=movespeed*0.5
			end
		end
		return movespeed
	end
	
end







do
	local super=XANESHPRACTICE.GameObject
	XANESHPRACTICE.PlayerController=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.PlayerController	
	
	function class:Setup(environment,player,camera)
		super.Setup(self,environment)
		self.player=player
		self.camera=camera
	end

	function class:GetPlayerInput(elapsed)
		local keys=self.player.environment.game.keys	
		
		local xcameradelta=0
		local ycameradelta=0
		
		----------CAMERA--------------------
		
		local camera=self.camera
		--TODO: take a look at zoom controls from old version
		local delta=keys.wmouse.pressed
		if(delta)then
			--print("delta:",delta)
			camera:AdjustZoomViaScrollWheel(delta)
		end
		
		local SCROLL_SPEED=20
		
		
		local mousepressed=false
		local mousecurrent=false
		local mousereleased=false
		if(keys.lmouse.pressed or keys.rmouse.pressed)then
			mousepressed=true
		end
		if(keys.lmouse.current or keys.rmouse.current)then
			mousecurrent=true
		end
		if(keys.lmouse.released or keys.rmouse.released)then
			-- note that this detects whether EITHER mouse button was released, even if the other is still held down.
			-- to determine check if mousecurrent=false
			mousereleased=true
		end		
		
		if(mousepressed)then
			local globalx,globaly=GetCursorPosition()
			camera.camerarotationprevmousex=globalx
			camera.camerarotationprevmousey=globaly
			XANESHPRACTICE.CVars:Override("enableMouseSpeed",1)
				-- -- turns out using 0 doesn't work -- camera rotation becomes too granular
			--XANESHPRACTICE.CVars:Override("mouseSpeed",0)
			
			--TODO: first check if mouse sensitivity is enabled and already lower than override!
				-- don't speed the mouse up unwittingly!
			XANESHPRACTICE.CVars:Override("mouseSpeed",XANESHPRACTICE.Config.Camera.MouseSpeed)
		end
		if(mousecurrent)then	
			local globalx,globaly=GetCursorPosition()
			--local speed=0.005*(GetCVar("cameraYawMoveSpeed")/180)
			local TEMP_MULTIPLIER=XANESHPRACTICE.Config.Camera.CameraSpeed 	--6-7 for windowed, 9-10 for fullscreen
			--TODO: can we use the GetScaledRect trick for cameraspeed?
			--TODO: attempt to detect whether mouse sensitivity was already set by player, and calculate multiplier from that
			local speed=0.006*(GetCVar("cameraYawMoveSpeed")/180)*TEMP_MULTIPLIER

			if(camera.camerarotationprevmousex and camera.camerarotationprevmousey)then
				xcameradelta=(globalx-camera.camerarotationprevmousex)
				ycameradelta=(globaly-camera.camerarotationprevmousey)
			end
			local inversionmultiplier=1
			if(GetCVar("mouseInvertYaw")=="1")then
				inversionmultiplier=-1
			end		
			camera.orientation.yaw=camera.orientation.yaw+ -1*xcameradelta*inversionmultiplier*speed
			
			local inversionmultiplier=1
			if(GetCVar("mouseInvertPitch")=="1")then			
				inversionmultiplier=-1
			end
			camera.orientation.pitch=camera.orientation.pitch+ -1*ycameradelta*inversionmultiplier*speed
			
			if(camera.orientation.yaw<-math.pi) then camera.orientation.yaw=camera.orientation.yaw+math.pi*2 end
			if(camera.orientation.yaw>math.pi) then camera.orientation.yaw=camera.orientation.yaw-math.pi*2 end				
			
			camera.camerarotationprevmousex=globalx
			camera.camerarotationprevmousey=globaly

			--TODO: move min/max consts to camera
			local MIN_VERTICAL_ANGLE=math.pi*-0.0	--ground
			--local MAX_VERTICAL_ANGLE=math.pi*0.5	--some objects disappear at 0.5
			local MAX_VERTICAL_ANGLE=math.pi*0.49	--overhead
			if(camera.orientation.pitch<MIN_VERTICAL_ANGLE)then camera.orientation.pitch=MIN_VERTICAL_ANGLE end
			if(camera.orientation.pitch>MAX_VERTICAL_ANGLE)then camera.orientation.pitch=MAX_VERTICAL_ANGLE end			
		else
			--else not mousecurrent
			--TODO: look for "self.player" instead (which is apparently never nil)
			-- local player=self.scenario.controls.player
			-- if(player)then
				-- player.targetfacing_3D_button=0
			-- end
		end

		if(mousereleased and not mousecurrent)then
			--TODO: does it matter which order we do this in?  does it need to be reverse order instead?
			XANESHPRACTICE.CVars:Restore("enableMouseSpeed")
			XANESHPRACTICE.CVars:Restore("mouseSpeed")			
		end
		
		local delta=keys.wmouse.pressed
		if(delta)then		
			local DELTA_MULTIPLIER=1
			--local DELTA_MULTIPLIER=3
			
			camera.cdist=camera.cdist-delta*DELTA_MULTIPLIER
			local MIN_DIST=5	--TODO: move to camera
			--local MAX_DIST=40	
			--local MAX_DIST=60
			local MAX_DIST=80
			--local MAX_DIST=200
			if(camera.cdist<MIN_DIST)then camera.cdist=MIN_DIST end
			if(camera.cdist>MAX_DIST)then camera.cdist=MAX_DIST end
		end	
	
	
	

		
		------PLAYER CHARACTER------------
	
		if(self.player) then
			local player=self.player

			if(keys.rmouse.current and (keys.lmouse.current or xcameradelta~=0 or ycameradelta~=0))then
				player.orientation.yaw=camera.orientation.yaw
				player.target_orientation_displayed.yaw=player.orientation.yaw
			elseif(not keys.rmouse.current)then
				local turnvector=0
				if(keys.turnQ.current)then
					turnvector=turnvector+1
				end
				if(keys.turnE.current)then
					turnvector=turnvector-1
				end				
				if(turnvector~=0)then
					--TODO: move to AI?
					if(turnvector>0)then
						self.player.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ShuffleLeft)
					elseif(turnvector<0)then
						self.player.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.ShuffleRight)
					end
					local TURN_SPEED=2.5					
					player.orientation.yaw=player.orientation.yaw+turnvector*elapsed*TURN_SPEED
					player.orientation.yaw=XANESHPRACTICE.WrapAngle(player.orientation.yaw)
					player.orientation_displayed.yaw=player.target_orientation_displayed.yaw+turnvector*elapsed*TURN_SPEED
					player.orientation_displayed.yaw=XANESHPRACTICE.WrapAngle(player.orientation_displayed.yaw)					
					player.target_orientation_displayed.yaw=player.target_orientation_displayed.yaw+turnvector*elapsed*TURN_SPEED
					player.target_orientation_displayed.yaw=XANESHPRACTICE.WrapAngle(player.target_orientation_displayed.yaw)
					if(not keys.lmouse.current)then
						camera.orientation.yaw=camera.orientation.yaw+turnvector*elapsed*TURN_SPEED
						camera.orientation.yaw=XANESHPRACTICE.WrapAngle(camera.orientation.yaw)
					end
				end
			end
			
			local vectorx,vectory			
			--TODO: involuntarymovement shouldn't be in PlayerControls class
			vectorx,vectory=self:GetCharacterMovementInputUnitVector()
			player.backpedal=(vectorx<0)
			player.lockorientationtocamera=(vectorx~=0 and vectory==0 and (xcameradelta~=0 or ycameradelta~=0))
			--player.lockorientationtocamera=(player.lockorientationtocamera or (player.position.z>0))
			
			if(vectorx==0 and vectory==0)then
				player.ai.targetposition=nil
			else
				player.ai.targetlocation={}			
				local yaw=player.orientation.yaw
				
				vectorx,vectory=XANESHPRACTICE.Transform_Rotate2D(vectorx,vectory,yaw,0,0)
				player.ai.targetposition={x=player.position.x+vectorx,y=player.position.y+vectory}
			end
		end
			

		--------- MOBCLICKZONES and NAMEPLATES -------------------------------
		
		--TODO: sort nameplates and mobclickzones by projected z2D
		if(self.player)then
			--print("nameplates:",#self.environment.nameplates)
			if(mousepressed)then
				local nameplates={unpack(self.environment.nameplates)}
				table.sort(nameplates,function(a,b)return a.zsort>b.zsort end)
				local globalx,globaly=GetCursorPosition()
				local foundmob=false
				for i=1,#nameplates do					
					local nameplate=nameplates[i]
					if(nameplate.in_front_of_camera)then
						local left,bottom,width,height=nameplate.displayobject.drawable:GetScaledRect()						
						local right=left+width
						local top=bottom+height
						local vertical_leeway=7
						top=top+vertical_leeway
						bottom=bottom-vertical_leeway
						--print(globalx,globaly,nameplate.displayobject.drawable:GetScaledRect())
						if(left<=globalx and globalx<=right)then
							if(bottom<=globaly and globaly<=top)then
								--nameplate:SetSelected(true)								
								self.player:SetTargetMob(nameplate.mob)
								self.environment:SelectMob(nameplate.mob)
								if(keys.rmouse.pressed)then
									self.player.combatmodule:StartAutoAttacking()
								end
								foundmob=true
								break
								--TODO:
								--self.player:SetTarget({nameplate.mob})
							end
						end
					end
				end
				if(not foundmob)then
					local mobclickzones={unpack(self.environment.mobclickzones)}
					table.sort(mobclickzones,function(a,b)
						--print(a.mob.nameplate.zsort,b.mob.nameplate.zsort)
						return a.zsort>b.zsort
					end)
					for i=1,#mobclickzones do
						local mobclickzone=mobclickzones[i]
						--local nameplate=mobclickzone.mob.nameplate
						if(mobclickzone.in_front_of_camera)then
							local left,bottom,width,height=mobclickzone.displayobject.drawable:GetScaledRect()
							local right=left+width
							local top=bottom+height
							local vertical_leeway=7
							top=top+vertical_leeway
							bottom=bottom-vertical_leeway
							--print(globalx,globaly,nameplate.displayobject.drawable:GetScaledRect())
							if(left<=globalx and globalx<=right)then
								if(bottom<=globaly and globaly<=top)then
									--nameplate:SetSelected(true)								
									self.player:SetTargetMob(mobclickzone.mob)
									self.environment:SelectMob(mobclickzone.mob)
									if(keys.rmouse.pressed)then
										self.player.combatmodule:StartAutoAttacking()
									end									
									break
									--TODO:
									--self.player:SetTarget({nameplate.mob})
								end
							end
						end
					end
				end
			end
		end
		
		
		---------- JUMP KEY -------------------------------------
		if(self.player)then
			if(keys.jump.pressed)then
				if(self.player.position.z<=0)then
					--TODO: move to AI?
					self.player.velocity.z=self.player.jumpvelocity.z
					self.player.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.JumpStart)
					--self.player.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.JumpLandRun)
				end
			end
		end
		
		
		
		
		
		---------- ESC KEY -------------------------------------
		if(self.player)then
			if(keys.esc.pressed)then
				--TODO: move to AI?
				self.player:SetTargetMob(nil)
				self.environment:SelectMob(nil)
			end
		
		end
	
		
	end
	
	
		
	function class:GetCharacterMovementInputUnitVector()
		-- this function assumes the camera is facing "right" (angle 0 radians)
		local environment_gameplay=self.environment.game.environment_gameplay		
		local vectorx,vectory=0,0
		local fwdvector=false
		local keys=self.environment.game.keys

				
		if(keys.leftA.current or (keys.turnQ.current and keys.rmouse.current))then		vectory=vectory+1		end		
		if(keys.rightD.current or (keys.turnE.current and keys.rmouse.current))then	vectory=vectory-1		end	
		if(keys.downS.current)then			vectorx=vectorx-1		end	
		if(keys.upW.current)then			fwdvector=true		end
		----TODO: figure out what we want to do with middle mouse button
			-- (hint: we want to dodgeroll)
		--if(self.environment.game.keys.mmouse.current)then			fwdvector=true		end
		if(self.environment.game.keys.lmouse.current and self.environment.game.keys.rmouse.current)then			fwdvector=true		end	--LMB+RMB
		if(fwdvector)then
			vectorx=vectorx+1
		end		
		return vectorx,vectory				
	end		
	
end