do
	XANESHPRACTICE.DisplayObject = {}
	local class=XANESHPRACTICE.DisplayObject
	class.__index = class

	function class.new()
		local self=setmetatable({}, class)
		return self
	end
	
	-- call from GameObject:CreateDisplayObject.
	-- owner must be a GameObject whose Environment has already been set.
	function class:Setup(owner)
		self.owner=owner
		self.drawable=nil
		self.drawables={}
		self:CreateDrawable()
		self:SetAppearance()
	end

	-- CreateDrawable can create the frame widget itself (for frame-based DisplayObjects)
	-- or the Actor that goes in environment's ModelScene widget
	function class:CreateDrawable()
		--virtual
	end

	function class:SetAppearance()
		--virtual
	end
	
	function class:Cleanup()
		for i=1,#self.drawables do
			self.drawables[i]:Cleanup()
		end
	end
end