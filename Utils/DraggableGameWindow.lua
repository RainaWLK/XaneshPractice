-- This window is hardcoded to expect a XANESHPRACTICE.Game.

XANESHPRACTICE.DraggableGameWindow = {}
XANESHPRACTICE.DraggableGameWindow.__index = XANESHPRACTICE.DraggableGameWindow

function XANESHPRACTICE.DraggableGameWindow.new()
	local self=setmetatable({}, XANESHPRACTICE.DraggableGameWindow)	
		
	return self
end

--TODO: resizable

function XANESHPRACTICE.DraggableGameWindow:Setup(game,width,height,titletext,titleheight,closebutton,onclose)		

	--TODO: figure out how we want to handle window framelevels

	if(not titleheight)then titleheight=20 end

	self.game=game	
	self.environments={}
			
	self.background=XANESHPRACTICE.ReusableFrames:GetFrame()
	self.background.parent=UIParent
	self.background:SetParent(self.background.parent)
	self.background:SetWidth(width)	
	self.background:SetHeight(height+(titleheight+2))
	
	self.background:SetPoint("CENTER",self.background.parent,"CENTER",0,(titleheight/2))
	self.background.texture:SetColorTexture(0,0,0,0.5)
	self.background:Show()
	self.background.texture:Show()		
	self.background:SetAlpha(1)
	
	self.inputframe=XANESHPRACTICE.ReusableFrames:GetFrame()
	self.inputframe:SetParent(self.background)
	self.inputframe.parent=self.background; self.inputframe:SetParent(self.inputframe.parent)
	self.inputframe:SetPoint("BOTTOM",self.inputframe.parent,"BOTTOM",0,0) 
	self.inputframe:SetWidth(width);self.inputframe:SetHeight(height)	
	self.inputframe:Show()
	self.inputframe:SetAlpha(1)
			
--/run _XANESHPRACTICE_game.window.background:Hide()
--/run SetupFullscreenScale(_XANESHPRACTICE_game.window.background)
	self.frame=XANESHPRACTICE.ReusableFrames:GetFrame()
	self.frame.parent=self.background; self.frame:SetParent(self.frame.parent)
	
	self.frame:SetPoint("BOTTOM",self.frame.parent,"BOTTOM",0,0) 
	self.frame:SetWidth(width);self.frame:SetHeight(height)
	
	self.frame:Show()	
	self.frame:SetAlpha(1)
	
	self.inputframe:EnableMouse(true)
	--TODO: EnableMouseWheel not locking mouse wheel controls -- do we need to set an event before it locks?
	--TODO: state in future comments whether setting an event is necessary
	self.inputframe:EnableMouseWheel(true)	
	-- SetScript calls functions from the perspective of the frame, not the DraggableGameWindow itself
	-- so we must remind frame who it's supposed to be
	self.inputframe.parentwindow=self
	self.inputframe:SetScript("OnMouseDown", self.OnMouseDown)
	self.inputframe:SetScript("OnMouseUp", self.OnMouseUp)		
	self.inputframe:SetScript("OnMouseWheel", self.OnMouseWheel)	
	self.inputframe:SetScript("OnKeyDown", self.OnKeyDown)
	self.inputframe:SetScript("OnKeyUp", self.OnKeyUp)		
	
	local OnUpdate=function(self,elapsed)
		XANESHPRACTICE.xpcall(function()game.MainGameLoop(game,elapsed)end)
	end
	self.inputframe:SetScript("OnUpdate", OnUpdate)
	
	
	
	self.bordergraphic=XANESHPRACTICE.BorderGraphicWithTitle.new()
	self.bordergraphic:Setup(self.background,titletext,titleheight)	
	

	
	----Background texture is now handled by BorderGraphicWithTitle
	--TODO: rename BorderGraphicWithTitle to bordergraphicWithTitle
	--self.frame.texture:SetColorTexture(0,0,0,0.5)
	--self.frame.texture:Show()
	
	--XANESHPRACTICE.FrameVisibilityCheck(self.frame)
	
	--TitleRegion removed in 7.1!
	--use RegisterForDrag instead
	--self.titleregion=self.frame:CreateTitleRegion()	
	--self.titleregion:SetPoint("TOPLEFT",self.frame,"TOPLEFT",0,0)		-- remember, this is the draggable title bar we're setting,
	--self.titleregion:SetPoint("TOPRIGHT",self.frame,"TOPRIGHT",0,0)	-- so use TOPLEFT/TOPRIGHT instead of BOTTOMLEFT/BOTTOMRIGHT
	--self.titleregion:SetHeight(titleheight)

	self.titleregion=XANESHPRACTICE.ReusableFrames:GetFrame()
	self.titleregion.parent=self.background; self.titleregion:SetParent(self.titleregion.parent)
	self.titleregion:SetPoint("TOPLEFT",self.titleregion.parent,"TOPLEFT")
	self.titleregion:SetPoint("TOPRIGHT",self.titleregion.parent,"TOPRIGHT")
	self.titleregion:SetWidth(width)
	self.titleregion:SetHeight(titleheight)	
	self.titleregion:Show()
	self.titleregion:RegisterForDrag("LeftButton")	
	self.titleregion:SetAlpha(1)
	self.background:SetMovable(true)
	self.titleregion:SetScript("OnDragStart", function()
		self.background:StartMoving()
	end)
	self.titleregion:SetScript("OnDragStop", function()
		self.background:StopMovingOrSizing()
	end)	
	--mouse must be enabled to drag window
	self.titleregion:EnableMouse(true)
	

	
	if(closebutton)then
		self.closebutton=XANESHPRACTICE.ReusableButtonFrames:GetFrame()
		self.closebutton:SetParent(self.titleregion)
		self.closebutton:SetWidth(16)
		self.closebutton:SetHeight(16)
		self.closebutton:SetPoint("TOPRIGHT",-3,-2)
		--self.closebutton:SetFrameLevel(255)
		self.closebutton.texture=self.closebutton:CreateTexture()
		self.closebutton.texture:SetAllPoints(self.closebutton)		
		self.closebutton.texture:SetTexture("Interface\\AddOns\\XaneshPractice\\Assets\\Graphics\\Misc\\closebutton.tga")			
		self.closebutton:SetHighlightTexture("Interface\\AddOns\\XaneshPractice\\Assets\\Graphics\\Misc\\square.tga")	
		
		self.closebutton.texture:Show()		
		self.closebutton:Show()	
		self.closebutton:SetAlpha(1)		
		
		self.closebutton:SetScript("OnClick",function(self,button,down)
				onclose()
			end)
	end
	


end

-- reminder: these events are called from the perspective of self.frame
function XANESHPRACTICE.DraggableGameWindow:OnMouseDown(button)
	self.parentwindow.game:OnMouseChange(self,button,true)			
end

function XANESHPRACTICE.DraggableGameWindow:OnMouseUp(button)
	self.parentwindow.game:OnMouseChange(self,button,false)		
end

function XANESHPRACTICE.DraggableGameWindow:OnMouseWheel(delta)
	self.parentwindow.game:OnMouseWheel(self,delta)
end
function XANESHPRACTICE.DraggableGameWindow:OnKeyDown(keycode,binding)
	if(keycode=="ENTER" or keycode=="/" or keycode==XANESHPRACTICE.DEBUG.extrapassthrukeycode) then
		-- ENTER and / keys pass through so the player can still access chat
		self:SetPropagateKeyboardInput(true)
	else
		-- (we still can't believe this works.  would not be surprised if it breaks in a future patch)
		self:SetPropagateKeyboardInput(false)
	end
	
	if(keycode=="ESCAPE") then
		if(XANESHPRACTICE.DEBUG.instantquit==true) then
			if(_XANESHPRACTICE)then
				print("XANESHPRACTICE.DEBUG.instantquit")
				_XANESHPRACTICE:Shutdown()
			end
			return
		end
		-- if(XANESHPRACTICE.DEBUG.instantshiftquit==true)then
			-- if(XANESHPRACTICE.game.keys.shift.current==true)then
				-- XANESHPRACTICE:Shutdown()
				-- return
			-- end
		-- end
		-- if(XANESHPRACTICE.forceshutdowntimer==nil)then
			-- XANESHPRACTICE.forceshutdowntimer=XANESHPRACTICE.FORCESHUTDOWNDURATION --TODO: const
		-- end
	end

	self.parentwindow.game:OnKeyChange(self,keycode,binding,true)
end
function XANESHPRACTICE.DraggableGameWindow:OnKeyUp(keycode,binding)
	self.parentwindow.game:OnKeyChange(self,keycode,binding,false)
end


function XANESHPRACTICE.DraggableGameWindow:Cleanup(game,xaneshpractice)	
	self.environments={}
	self.inputframe.parentwindow=nil	
	self.inputframe:SetScript("OnMouseDown", nil)
	self.inputframe:SetScript("OnMouseUp", nil)		
	self.inputframe:SetScript("OnMouseWheel", nil)
	self.inputframe:SetScript("OnKeyDown", nil)
	self.inputframe:SetScript("OnKeyUp", nil)
	self.inputframe:SetScript("OnUpdate", nil)
	self.inputframe:Cleanup()
	self.frame:Cleanup()	
	self.titleregion:Cleanup()
	-- we did some extra things with titleregion that ReusableFrames isn't expecting; clean that up here
	self.titleregion:SetScript("OnDragStart", nil);self.titleregion:SetScript("OnDragStop", nil)	
	self.titleregion:RegisterForDrag();
	self.frame:SetMovable(false)
	self.bordergraphic:Cleanup()
	self.background:Cleanup()
	if(self.closebutton)then
		self.closebutton:Cleanup()
	end
	self.game=nil
	self.xaneshpractice=nil
end

	
