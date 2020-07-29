
do
	XANESHPRACTICE.MobAI = {}
	local class=XANESHPRACTICE.MobAI
	class.__index = class

	function class.new()
		local self=setmetatable({}, class)
		return self
	end
	
	function class:Setup(mob)
		self.mob=mob
		self.targetposition=nil
		self.moveinputvector={x=0,y=0}
	end
	
	function class:AIStep(elapsed)
		--print("targetlocation: ",self.targetlocation)
		if(self.targetposition)then
			--print("targetlocation")
			local distx=(self.targetposition.x-self.mob.position.x)
			local disty=(self.targetposition.y-self.mob.position.y)
			local distsqr=distx*distx+disty*disty
			--TODO: use self:GetFinalMoveSpeed() ^ 2 instead
			local movespeed=self.mob:GetFinalMoveSpeed()
			local movespeedelapsed=movespeed*(2*elapsed)
			local dist=math.sqrt(distsqr)	
			if(distsqr>movespeedelapsed*movespeedelapsed)then
				self.moveinputvector.x=distx
				self.moveinputvector.y=disty
			else			
				--TODO: don't set targetposition nil if forced movement occurs
				-- (not sure how to properly do this yet.  check that xspeed and yspeed are 0?)
				self.targetposition=nil
				self.moveinputvector.x=0
				self.moveinputvector.y=0
			end
		else	-- else no targetposition
			self.moveinputvector.x=0
			self.moveinputvector.y=0	
		end
	end

end