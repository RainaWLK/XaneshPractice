do
	local super=XANESHPRACTICE.GameObject
	XANESHPRACTICE.Nameplate=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.Nameplate
	
	function class:Setup(environment,mob)
		super.Setup(self,environment)
		self.mob=mob
		mob.nameplate=self
		self.selected=false
		self.selectsize=0.0
		self.in_front_of_camera=false
		self.zsort=1
	end
	
		
	function class:SetupEnvironmentObjectListIndexStorage()
		super.SetupEnvironmentObjectListIndexStorage(self)
		tinsert(self.environmentobjectlists,self.environment.nameplates)
	end
	
	
	function class:CreateDisplayObject()
		self.displayobject=XANESHPRACTICE.NameplateDisplayObject.new()
		self.displayobject:Setup(self)
	end	
	
	function class:Step(elapsed)
		if(self.selected)then
			self.selectsize=self.selectsize+elapsed*(10)
			if(self.selectsize>1)then self.selectsize=1 end
		else
			self.selectsize=self.selectsize-elapsed*(10)
			if(self.selectsize<0)then self.selectsize=0 end	
		end
		self.displayobject.drawable:SetSize(145+65*self.selectsize,15+5*self.selectsize)
		--self.displayobject.drawable:SetSize(145+65*self.selectsize,55+5*self.selectsize)
	end
	
	function class:Draw()
		local x1,y1,z1,x2,y2,z2=self.mob.displayobject.drawable:GetActiveBoundingBox()
		if(not z2)then z2=0 end
		local x3D,y3D,z3D
		x3D=self.mob.position.x
		y3D=self.mob.position.y
		z3D=self.mob.position.z+z2*self.mob.scale
		local x2D,y2D,z2D=self.environment.modelsceneframe:Project3DPointTo2D(x3D,y3D,z3D)
		
		-- adjust projected point for large screen size
		-- (we're not sure why this works, but it does)
		local multiplier
		local l1,b1,w1,h1=UIParent:GetRect()
		local l2,b2,w2,h2=UIParent:GetScaledRect()
		multiplier=w1/w2		
		x2D=x2D*multiplier
		y2D=y2D*multiplier
		-- do NOT multiply z2D by multiplier
		
		local NEAR_CLIP=1.0		
		if(z2D<NEAR_CLIP)then
			self.displayobject.drawable:SetPoint("BOTTOM",self.displayobject.parentframe,"BOTTOMLEFT",x2D,y2D)
			self.displayobject.drawable:SetAlpha(1)
			self.in_front_of_camera=true			
		else
			self.displayobject.drawable:SetAlpha(0)
			self.in_front_of_camera=false
		end
		self.zsort=z2D
	end
	
	function class:SetSelected(selected)
		self.displayobject:SetSelected(selected)
		self.selected=selected
	end
	
	function class:SetText(text)
		self.displayobject:SetText(text)
	end
	
	-- function class:Cleanup()
		-- self.displayobject:Cleanup()
	-- end
	
end

-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------

do
	local super=XANESHPRACTICE.DisplayObject
	XANESHPRACTICE.NameplateDisplayObject=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.NameplateDisplayObject
	
	function class:CreateDrawable()
		self.drawable=XANESHPRACTICE.ReusableFrames:GetFrame()		
		tinsert(self.drawables,self.drawable)
		self.topfill=XANESHPRACTICE.ReusableFrames:GetFrame()
		tinsert(self.drawables,self.topfill)
		self.bottomfill=XANESHPRACTICE.ReusableFrames:GetFrame()
		tinsert(self.drawables,self.bottomfill)		
		self.name=XANESHPRACTICE.ReusableFrames:GetFrame()
		tinsert(self.drawables,self.name)
	end
	
	function class:SetAppearance()		
		self.parentframe=self.owner.environment.frame
		self.drawable:SetParent(self.parentframe);self.drawable:SetFrameLevel(200)
		self.drawable.texture:Show()
		self.drawable:Show()
		self.drawable:SetSize(210,20)
		self.drawable:SetAlpha(1)		
		self.topfill:SetParent(self.drawable);self.topfill:SetFrameLevel(201)
		self.topfill.texture:Show();self.topfill.texture:SetColorTexture(1,1,1,1)
		self.topfill:Show()
		self.topfill:SetPoint("BOTTOMLEFT",self.drawable,"LEFT",2,0)
		self.topfill:SetPoint("TOPRIGHT",self.drawable,"TOPRIGHT",-2,-2)
		self.topfill:SetAlpha(1)
		self.bottomfill:SetParent(self.drawable);self.bottomfill:SetFrameLevel(201)
		self.bottomfill.texture:Show();self.bottomfill.texture:SetColorTexture(1,1,1,1)
		self.bottomfill:Show()
		self.bottomfill:SetPoint("BOTTOMLEFT",self.drawable,"BOTTOMLEFT",2,2)
		self.bottomfill:SetPoint("TOPRIGHT",self.drawable,"RIGHT",-2,0)
		self.bottomfill:SetAlpha(1)
		self.name:Show()
		self.name:SetParent(self.drawable);self.name:SetFrameLevel(201)		
		self.name:SetPoint("BOTTOM",self.drawable,"TOP",0,0)
		self.name.fontstring:SetFont("Fonts\\FRIZQT__.TTF",20)		
		self.name.fontstring:Show();self:SetText("Unknown\n<Unknown>")		
		self.name:SetAlpha(1)
		self:SetSelected(false)
	end
	
	function class:SetSelected(selected)
		local texture,gradient1,gradient2,textcolor
		if(not selected)then
			texture={0,0,0,0.75}
			gradient1={"VERTICAL",1,0,0,0.75,0,0,0,0.75}
			gradient2={"VERTICAL",0,0,0,0.75,1,0,0,0.75}
			textcolor={1,0,0,0.75}
		else
			texture={1,1,1,1}
			gradient1={"VERTICAL",1,0,0,1,0,0,0,1}
			gradient2={"VERTICAL",0,0,0,1,1,0,0,1}
			textcolor={1,0,0,1}
		end
		self.drawable.texture:SetColorTexture(unpack(texture))
		self.topfill.texture:SetGradientAlpha(unpack(gradient1))		
		self.bottomfill.texture:SetGradientAlpha(unpack(gradient2))
		self.name.fontstring:SetTextColor(unpack(textcolor))
	end
	
	function class:SetText(text)
		self.name.fontstring:SetText(text)
		self.name:SetSize(self.name.fontstring:GetStringWidth(),self.name.fontstring:GetStringHeight()+5)		
	end
	
	-- function class:Cleanup()
		-- self.drawable:Cleanup()
	-- end
end

