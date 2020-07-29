
SetScreenResolution_old = SetScreenResolution
SetScreenResolution=function(index)
	--TODO LATER: do something when we detect screen resolution was changed
	SetScreenResolution_old(index)
end



XANESHPRACTICE.Game = {}
XANESHPRACTICE.Game.__index = XANESHPRACTICE.Game

function XANESHPRACTICE.Game.new()
	local self=setmetatable({}, XANESHPRACTICE.Game)	
	return self
end

function XANESHPRACTICE.Game:Setup(xaneshpractice)	
	
	-- widescreen
	self.SCREEN_WIDTH=853*1.5	
	self.SCREEN_HEIGHT=480*1.5
	

	
	local TITLEHEIGHT=20
	
	local titletext="Xanesh Practice 2020-02-29"
	
	self.xaneshpractice=xaneshpractice
	
	--XANESHPRACTICE.PlayerCharacter.SetupCanPlayerDW()
	--XANESHPRACTICE.Class.SetupClasses()
	
	self.window=XANESHPRACTICE.DraggableGameWindow.new()
	self.window:Setup(self,self.SCREEN_WIDTH,self.SCREEN_HEIGHT,titletext,nil,true,function()self:Shutdown() end)	
	
	-- self.hotbarwindow=XANESHPRACTICE.DraggableGameWindow.new()
	-- self.hotbarwindow:Setup(self,xaneshpractice,self.SCREEN_WIDTH,100,"",nil,false)
	-- self.hotbarwindow.background:ClearAllPoints()
	-- self.hotbarwindow.background:SetPoint("TOP",UIParent,"CENTER",0,-240)	
	
	self.rawinput=XANESHPRACTICE.RawInput.new()
	self.keys=XANESHPRACTICE.Keys.new()
	self.keys:Setup(self.rawinput)	
	
	self.environments={}
	
	
	-- realtime is only used for non-gameplay functions such as mouse highlight scanning
	-- reminder: GetTime is measured in SECONDS, not milliseconds
	self.realtime=GetTime()
	-- currenttime is the sum of all elapsed time each frame.  this is probably very close to realtime minus starting time.
	-- note that each environment tracks its own currenttime separately.  (TODO LATER: track environment.currenttime)
	self.currenttime=0
	
	self.nextmousehighlighttargetscantime=GetTime()			-- mouseover detection doesn't run every frame
	self.nextmousehighlighttargetscaninterval=0.100

	--self:LoadScenarioByClass(XANESHPRACTICE.Scenario_Menu)
	self:LoadScenarioByClass(XANESHPRACTICE.DEFAULTSCENARIO.Scenario)
end


function XANESHPRACTICE.Game:LoadScenarioByClass(scenarioclass)
	--if(self.scenario)then
		--self.scenario:Cleanup()
	--end
	for i=1,#self.environments do
		--TODO: if environments ever become unusable after cleanup, this will break things
		self.environments[i]:Cleanup()
	end
	
	self:RecreateEnvironments()
	
	local scenario=scenarioclass.new()
	--print("New scenario:",scenario)
	scenario:Setup(self)
	self.scenario=scenario
end

function XANESHPRACTICE.Game:RecreateEnvironments()
	--WARNING: call cleanup on existing environments first
	--TODO: do this automatically somehow
	
	self.environments={}

	local environment_gameplay=XANESHPRACTICE.Environment.new()	
	self.environment_gameplay=environment_gameplay
	environment_gameplay:Setup(self,self.window.frame)
	self.window.background:SetFrameLevel(1)	
	self.window.inputframe:SetFrameLevel(2)	
	environment_gameplay.frame:SetFrameLevel(3)
	tinsert(self.window.environments,environment_gameplay)
	
	-- local environment_scenario=XANESHPRACTICE.Environment.new()
	-- self.environment_scenario=environment_scenario
	-- environment_scenario:Setup(self,self.window.frame)
	-- tinsert(self.window.environments,environment_scenario)	
	
	-- local environment_hud=XANESHPRACTICE.Environment_HUD.new()
	-- self.environment_hud=environment_hud
	-- environment_hud:Setup(self,self.window.frame)
	-- environment_hud.frame:SetFrameLevel(255)
	-- tinsert(self.window.environments,environment_hud)
	
	
	-- local environment_hotbar=XANESHPRACTICE.Environment_HUD.new()	--XANESHPRACTICE.Environment_Menu.new()	
	-- self.environment_hotbar=environment_hotbar
	-- --!!!
	-- --environment_hotbar:Setup(self,self.hotbarwindow.frame)
	-- environment_hotbar:Setup(self,self.window.frame)
	-- environment_hotbar.cameramanager.camera.objectanchor="BOTTOMLEFT"
	-- --!!!
	-- self.hotbarwindow.background:Hide()
	-- tinsert(self.window.environments,environment_hotbar)	
	
	-- --TODO: move to environment_hotbar (which does not exist yet)
	-- --TODO: rename to hotbar_controller / environment_hotbar?
	-- local spellbuttoncontroller=XANESHPRACTICE.SpellButtonController.new()
	-- spellbuttoncontroller:Setup(environment_hotbar)
	-- self.spellbuttoncontroller=spellbuttoncontroller
end


function XANESHPRACTICE.Game:OnMouseChange(window,button,state)
	--TODO: window
	if(button=="LeftButton")then
		self.rawinput:SetKey("LMOUSE",state)
	elseif(button=="RightButton")then
		self.rawinput:SetKey("RMOUSE",state)		
	elseif(button=="MiddleButton")then
		self.rawinput:SetKey("MMOUSE",state)
	end
	
end
function XANESHPRACTICE.Game:OnMouseWheel(window,delta)
	--TODO: window
	self.rawinput.keys["WMOUSE"]:SetMouseWheel(delta)
end
function XANESHPRACTICE.Game:OnKeyChange(window,keycode,binding,state)

	--print("OnKeyDown",keycode,binding,state)
	--print(keycode,self.rawinput.keys[keycode])
	if(self.rawinput.keys[keycode])then
		self.rawinput.keys[keycode]:SetKey(state)
	end
	
	-- if(keycode=="ESCAPE" and state==true)then
		-- if(self.traininggrounds)then
			-- self.traininggrounds.game.scenario:OnEscapeKey()
			-- --self.traininggrounds:Shutdown()
		-- end
	-- end
end

function XANESHPRACTICE.Game:MainGameLoop(elapsed)
	
	self.realtime=GetTime()
	self.currenttime=self.currenttime+elapsed

	
	--TODO: environment:StartOfFrame -- increment environment.currenttime there
	for i=1,#self.environments,1 do
		self.environments[i]:IncrementTime(elapsed)
	end		
	
	--TODO: preferably loop through playercontrol objects only
	for i=1,#self.environments,1 do
		self.environments[i]:GetPlayerInput(elapsed)
	end		
	-- --TODO: rename to AIStep or AIPhase?
	-- for i=1,#self.environments,1 do
		-- self.environments[i]:AI(elapsed)
	-- end		
	
	if(self.scenario)then
		self.scenario:Step(elapsed)
	end
	

	for i=1,#self.environments,1 do
		self.environments[i]:Step(elapsed)
	end	
	-- for i=1,#self.environments,1 do
		-- self.environments[i]:PreMove(elapsed)
	-- end
	-- for i=1,#self.environments,1 do
		-- self.environments[i]:Move(elapsed)
	-- end	
	-- for i=1,#self.environments,1 do
		-- self.environments[i]:PostMove(elapsed)
	-- end

	-- for i=1,#self.environments,1 do
		-- self.environments[i]:CombatPhase_CollisionCheck_VoidZone(elapsed)
	-- end	
	for i=1,#self.environments,1 do
		self.environments[i]:CombatPhase(elapsed)
	end			
	-- for i=1,#self.environments,1 do	
		-- --TODO LATER: rename to Animate, or write separate Animate function
		-- self.environments[i]:PreDraw(elapsed)
	-- end			
	for i=1,#self.environments,1 do
		self.environments[i]:Draw(elapsed)
	end		
	for i=1,#self.environments,1 do
		self.environments[i]:EndOfFrame(elapsed)
	end
	
	self.rawinput:EndStep()
	self.keys:EndStep()
	

end

function XANESHPRACTICE.Game:ResetModelsAfterScreenRatioChange()
	for i=1,#self.environments,1 do
		self.environments[i]:ResetModelsAfterScreenRatioChange()
	end


end

function XANESHPRACTICE.Game:Shutdown()
	self.dead=true
	self:Cleanup()
	self.xaneshpractice:RemoveDeadGames()
end

function XANESHPRACTICE.Game:Cleanup()
	--TODO: maintain list of windows
	self.window:Cleanup()
	--self.hotbarwindow:Cleanup()
	self.keys:Cleanup()
	self.rawinput:Cleanup()
	
	for i=1,#self.environments,1 do
		local environment=self.environments[i]
		environment:Cleanup()
		--<s>TODO: environment.frame:cleanup was moved here from environment:cleanup so as not to break loadscenario.  however, it's not a great system by any stretch of the imagination		</s>
		--environment.frame:Cleanup()
	end
	
	--TODO LATER: more cleanup where necessary	
end







