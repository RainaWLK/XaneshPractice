do
	local super=XANESHPRACTICE.Mob
	XANESHPRACTICE.Floor=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.Floor
	
	function class:CreateDisplayObject()
		self.displayobject=XANESHPRACTICE.ModelSceneActor_Floor.new()
		self.displayobject:Setup(self)
	end
end

-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------

do
	local super=XANESHPRACTICE.ModelSceneActor
	XANESHPRACTICE.ModelSceneActor_Floor=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.ModelSceneActor_Floor

	
	function class:CreateDrawable()
		--TODO: self:PickModelSceneFrame()
		local msf=self.owner.environment.modelsceneframe_floor
		local actor=XANESHPRACTICE.ReusableModelSceneFrames:GetActor(msf)
		self.drawable=actor
		self:SetActorAppearance()
		tinsert(self.drawables,self.drawable)
	end
end