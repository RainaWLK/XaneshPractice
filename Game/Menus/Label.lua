do
	local super=XANESHPRACTICE.GameObject
	XANESHPRACTICE.Label=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.Label
	
	function class:CreateDisplayObject()
		self.displayobject=XANESHPRACTICE.LabelDisplayObject.new()
		self.displayobject:Setup(self)
	end
	
	function class:SetSize(wid,hgt)
		self.displayobject.drawable:SetSize(wid,hgt)
	end
	
	function class:SetText(text)
		self.displayobject.drawable.fontstring:SetText(text)
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
	XANESHPRACTICE.LabelDisplayObject=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.LabelDisplayObject
	
	function class:CreateDrawable()
		local f=XANESHPRACTICE.ReusableFrames:GetFrame()
		self.drawable=f	
		tinsert(self.drawables,f)
	end
	function class:SetAppearance()
		self.drawable:Show();self.drawable:SetAlpha(1)
		self.parentframe=self.owner.environment.frame
		self.drawable:SetParent(self.parentframe)
		self.drawable:SetSize(50,50)
		self.drawable:SetFrameLevel(200)
		self.drawable.fontstring:Show()
		self.drawable.fontstring:SetText("")
	end
	function class:SetPositionAndScale(position,scale)
		self.drawable:SetPoint("BOTTOMLEFT",self.parentframe,"BOTTOMLEFT",position.x,position.y)
		--self.drawable:SetAllPoints(self.parentframe)
	end

end