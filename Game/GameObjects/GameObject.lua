do
	XANESHPRACTICE.GameObject = {}
	local class=XANESHPRACTICE.GameObject
	class.__index = class

	function class.new()
		local self=setmetatable({}, class)
		return self
	end

	local _XANESHPRACTICE_GameObject_NextObjectID=0
	local function _XANESHPRACTICE_GameObject_GetNextObjectIDAndIncrement()
		_XANESHPRACTICE_GameObject_NextObjectID=_XANESHPRACTICE_GameObject_NextObjectID+1
		return _XANESHPRACTICE_GameObject_NextObjectID	
	end

	function class:Setup(environment,x,y)
		self.environment=environment
		
		self.id=_XANESHPRACTICE_GameObject_GetNextObjectIDAndIncrement()
		
		if(x and y)then
			self.position={x=x,y=y,z=0}
		else
			self.position={x=0,y=0,z=0}
		end
		self.localtime=0
		self.fadestarttime=nil
		self.alreadyfadestarted=false
		self.expirytime=nil
		
		
		self.velocity={x=0,y=0,z=0}
		
		self.jumpvelocity={x,0,y=0,z=10}
		self.gravity=-25
		
		-- Object's "true" orientation with respect to WASD tank controls.
		self.orientation={yaw=0,pitch=0,roll=0}
		-- Object's orientation as displayed on screen.
		self.orientation_displayed={yaw=0,pitch=0,roll=0}
		-- Object's orientation as *should be* displayed on screen, but maybe hasn't caught up yet.
			-- (Recalculated every frame while moving.)
		self.target_orientation_displayed={yaw=0,pitch=0,roll=0}
		self.scale=1
		
		self:SetCustomInfo()
		self:CreateDisplayObject()
		
		self:SetupEnvironmentObjectListIndexStorage()
		
		self:CreateAssociatedObjects()
		
		tinsert(environment.newgameobjects,self)
	end

	function class:SetCustomInfo()
	end

	function class:CreateDisplayObject()
	end

	function class:CreateAssociatedObjects()
		-- for objects that should create other objects
		-- on the same frame as they are themselves created.
	end
	
	function class:SetupEnvironmentObjectListIndexStorage()
		--override, call super when overriding
		
		-- List of environment objectlists relevant to this object (gameobjects, mobs, nameplates, etc)
		self.environmentobjectlists={}
		tinsert(self.environmentobjectlists,self.environment.gameobjects)
		
		-- Objects are transferred from newgameobject list to currentobject lists by Environment at end of frame
		-- 			(next function)	
		-- Dead objects are removed from currentobject lists by Environment at end of frame
	end


	function class:TransferFromEnvironmentNewobjectLists(environment)
		for i=1,#self.environmentobjectlists,1 do
			tinsert(self.environmentobjectlists[i],self)
		end
	end 
	
	function class:GetPlayerInput()
		--override
	end
	
	function class:Step(elapsed)
		--override, call super
		self.localtime=self.localtime+elapsed
		if(self.fadestarttime and not self.alreadyfadestarted)then
			if(self.environment.localtime>=self.fadestarttime)then
				--TODO: move fade effect from wowobject to gameobject?				
				self.alreadyfadestarted=true
				self:OnFadeStart()
			end
		end
		if(self.expirytime)then
			if(self.environment.localtime>=self.expirytime)then
				self:OnExpiry()
			end
		end
	end
	
	function class:Draw()
		--override
	end
	
	function class:OnFadeStart()
		--override
		--TODO: baseline fade animation?
	end
	
	function class:OnExpiry()
		self:Die()
	end
	
	function class:Die()
		self.dying=true
	end
	
	function class:Cleanup()
		if(self.displayobject)then
			self.displayobject:Cleanup()
		end
		self.dead=true
	end
end