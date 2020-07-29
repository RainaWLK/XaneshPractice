do
	local super=XANESHPRACTICE.GameObject
	XANESHPRACTICE.Polygon=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.Polygon

	function class:CreateDisplayObject()
		self.displayobject=XANESHPRACTICE.PolygonDisplayObject.new()
		self.displayobject:Setup(self)
	end		
	
	function class:Draw()
		--self.displayobject.drawable:SetPoint("BOTTOM",self.displayobject.parentframe,"BOTTOMLEFT",0,0)
		self.displayobject.drawable:SetAllPoints(self.displayobject.parentframe)
		self.displayobject:SetVertices(0,0,0,10,0,0,0,10,0)
	end
	
end

-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------

do
	local super=XANESHPRACTICE.DisplayObject
	XANESHPRACTICE.PolygonDisplayObject=XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.PolygonDisplayObject
	
	function class:CreateDrawable()
		self.drawable=XANESHPRACTICE.ReusableFrames:GetFrame()		
		tinsert(self.drawables,self.drawable)
	end
	
	function class:SetAppearance()		
		self.parentframe=self.owner.environment.frame
		self.drawable:SetParent(self.parentframe);self.drawable:SetFrameLevel(200)
		self.drawable.texture:Show()
		self.drawable:Show()
		--self.drawable:SetSize(210,20)
		self.drawable:SetAlpha(1)
		self.drawable:SetFrameLevel(95)		
	end	

	
	function class:SetVertices(x1,y1,z1,x2,y2,z2,x3,y3,z3)
		--print("D_P:SetVertices")
		--print("Parentframe size: ",self.parentframe:GetSize())
		self.x1=x1
		self.y1=y1
		self.z1=z1
		self.x2=x2
		self.y2=y2
		self.z2=z2
		self.x3=x3
		self.y3=y3
		self.z3=z3
		local x2D1,y2D1=self.owner.environment.modelsceneframe:Project3DPointTo2D(x1,y1,z1)
		local x2D2,y2D2=self.owner.environment.modelsceneframe:Project3DPointTo2D(x2,y2,z2)
		local x2D3,y2D3=self.owner.environment.modelsceneframe:Project3DPointTo2D(x3,y3,z3)
		local multiplier
		local l1,b1,w1,h1=UIParent:GetRect()
		local l2,b2,w2,h2=UIParent:GetScaledRect()
		multiplier=w1/w2
		x2D1=x2D1*multiplier;y2D1=y2D1*multiplier
		x2D2=x2D2*multiplier;y2D2=y2D2*multiplier
		x2D3=x2D3*multiplier;y2D3=y2D3*multiplier
		
		x2D1=x2D1/self.drawable:GetWidth()
		x2D2=x2D2/self.drawable:GetWidth()
		x2D3=x2D3/self.drawable:GetWidth()
		y2D1=1-y2D1/self.drawable:GetHeight()
		y2D2=1-y2D2/self.drawable:GetHeight()
		y2D3=1-y2D3/self.drawable:GetHeight()
		
		local ymin=min(y2D1,y2D2,y2D3)
		local crossproduct=0
		if(ymin==y2D1)then
			crossproduct=CrossProduct(x2D1,y2D1,x2D3,y2D3,x2D2,y2D2)
		elseif(ymin==y2D2)then
			crossproduct=CrossProduct(x2D2,y2D2,x2D1,y2D1,x2D3,y2D3)
		elseif(ymin==y2D3)then
			crossproduct=CrossProduct(x2D3,y2D3,x2D2,y2D2,x2D1,y2D1)
		end
		--print(x2D1,y2D1,x2D2,y2D2,x2D3,y2D3)
		--print(crossproduct)
		
		local ystretch=self.owner.environment.cameramanager.camera.ystretch
		if(crossproduct>0 and crossproduct<10)then
			self.drawable:SetAlpha(1)
			XANESHPRACTICE.TAXIFRAME_TextureAdd(self.drawable,100,1,1,1,x2D1,y2D1,x2D2,y2D2,x2D3,y2D3)
		else
			self.drawable:SetAlpha(0)
		end
	end	
	
	
	function CrossProduct(ax,ay,bx,by,cx,cy)
		local ux=bx-ax
		local uy=by-ay
		local vx=cx-ax
		local vy=cy-ay
		return ux*vy-uy*vx
	end
end