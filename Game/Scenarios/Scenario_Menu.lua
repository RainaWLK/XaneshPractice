
--TODO: fill menu contents programatically

do
	local super=XANESHPRACTICE.Scenario
	XANESHPRACTICE.Scenario_Menu = XANESHPRACTICE.inheritsFrom(super)
	local class=XANESHPRACTICE.Scenario_Menu

	local REDX="\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:12\124t"
		
		
	--TODO: move to ScenarioList.lua
	-- global static:
	if(not XANESHPRACTICE.ScenarioList)then
		XANESHPRACTICE.ScenarioList={}		
	end
	function XANESHPRACTICE.ScenarioList.RegisterScenario(scenarioclass,name,description)
		tinsert(XANESHPRACTICE.ScenarioList,{class=scenarioclass,name=name,description=description})
	end
	
	function class:Populate()
		super.Populate(self)				
			
			
		--TODO: RaidMarkerController should be in baseline scenario class	
		local wmcontroller=XANESHPRACTICE.RaidMarkerController.new()
		wmcontroller:Setup(self.environment.game.environment_gameplay)
		self.wmcontroller=wmcontroller

		local platformsize=XANESHPRACTICE.Mobile_ConvertYardsToTGUnits(100)
		
		
		--self:CreateBossController()
		
		
		-- local currentplayer=self.raid.rdps[1]
		-- self.controls:SetPlayer(currentplayer)
		-- currentplayer:SetPlayerAppearance()
		-- local relevant=XANESHPRACTICE.Aura_PlayerControlled.new()
		-- relevant:Setup(currentplayer.combat,currentplayer.combat,currentplayer:GetLocalTime())			

		-- self.aggramar.groupdancemodule:GetIntoInitialPosition()
		
		
		local x=-1
		local y=0
		
		self.startbuttons={}
		local startbutton
		
		--local buttonx=0
		local buttonx=self.environment.game.window.frame:GetWidth()/2
		-- --!!!

		for j=1,#XANESHPRACTICE.ScenarioList do
			
			local scen=XANESHPRACTICE.ScenarioList[j]
			x=x+1	
			if(x>2)then x=0;y=y+1 end
			startbutton=XANESHPRACTICE.Button.new()
			startbutton:Setup(self.environment.game.environment_hud)
			startbutton.x=buttonx+310*(x-1)
			--startbutton.y=self.environment.game.window.frame:GetHeight()/2+80-150*i
			startbutton.y=self.environment.game.window.frame:GetHeight()/2+150-150*y
			startbutton.drawable.width=300;startbutton.drawable.height=140	
			startbutton:SetText(scen.name.."\r"..scen.description)
			startbutton.drawable.frame:SetScript("OnClick",function()					
					self:OnStartButton()
					self.environment.game:LoadScenarioByClass(scen.class)
				end)
			tinsert(self.startbuttons,startbutton)
		end
		
		-- i=i+1	
		-- startbutton=XANESHPRACTICE.Button.new()
		-- startbutton:Setup(self.environment.game.environment_hud)
		-- startbutton.x=buttonx
		-- startbutton.y=self.environment.game.window.frame:GetHeight()/2+80-150*i
		-- startbutton.drawable.width=500;startbutton.drawable.height=140				
		-- startbutton:SetText("Vectis\rfor mDPS and rDPS")
		-- startbutton.drawable.frame:SetScript("OnClick",function()					
					-- self:OnStartButton()
					-- self.environment.game:LoadScenarioByClass(XANESHPRACTICE.VECTIS_Scenario_Vectis)
				-- end)
		-- tinsert(self.startbuttons,startbutton)
		
		


				
		-- if(XANESHPRACTICE.SETTINGS_Scenario_Settings)then
			-- i=i+1	
			-- startbutton=XANESHPRACTICE.Button.new()
			-- startbutton:Setup(self.environment.game.environment_hud)
			-- startbutton.x=buttonx
			-- startbutton.y=self.environment.game.window.frame:GetHeight()/2+80-150*i
			-- startbutton.drawable.width=500;startbutton.drawable.height=140				
			-- startbutton:SetText("Settings")
			-- startbutton.drawable.frame:SetScript("OnClick",function()					
						-- self:OnStartButton()
						-- self.environment.game:LoadScenarioByClass(XANESHPRACTICE.SETTINGS_Scenario_Settings)
					-- end)
			-- tinsert(self.startbuttons,startbutton)
			
		-- end
		
				
		-- if(XANESHPRACTICE.Scenario_Animation)then
			-- i=i+1				
			-- startbutton=XANESHPRACTICE.Button.new()
			-- startbutton:Setup(self.environment.game.environment_hud)
			-- startbutton.x=buttonx
			-- startbutton.y=self.environment.game.window.frame:GetHeight()/2+80-150*i
			-- startbutton.drawable.width=500;startbutton.drawable.height=140				
			-- startbutton:SetText("Animation\rNothing to see here")
			-- startbutton.drawable.frame:SetScript("OnClick",function()					
						-- self:OnStartButton()
						-- self.environment.game:LoadScenarioByClass(XANESHPRACTICE.Scenario_Animation)
					-- end)
			-- tinsert(self.startbuttons,startbutton)
		-- end
		
		
		-- if(XANESHPRACTICE.SECRET35_Scenario_35Spheres)then
			-- i=i+1	
			-- startbutton=XANESHPRACTICE.Button.new()
			-- startbutton:Setup(self.environment.game.environment_hud)
			-- startbutton.x=buttonx
			-- startbutton.y=self.environment.game.window.frame:GetHeight()/2+80-150*i
			-- startbutton.drawable.width=500;startbutton.drawable.height=140				
			-- startbutton:SetText("Spheres scenario for Secret 35\rNothing to see here")
			-- startbutton.drawable.frame:SetScript("OnClick",function()					
						-- self:OnStartButton()
						-- self.environment.game:LoadScenarioByClass(XANESHPRACTICE.SECRET35_Scenario_35Spheres)
					-- end)
			-- tinsert(self.startbuttons,startbutton)			
		-- end
		
		

		
		--local OFFSETX=260
		local OFFSETX=0
		local OFFSETY=-80
		local text
		text=XANESHPRACTICE.Debug_Text.new();text:Setup(self.environment.game.environment_hud)
		text.x=OFFSETX+self.environment.game.window.frame:GetWidth()/2;text.y=OFFSETY+self.environment.game.window.frame:GetHeight()/2-125-0
		text.drawable.width=500;text.drawable.height=70
		text:SetText("Left-click a scenario to begin")
		text=XANESHPRACTICE.Debug_Text.new();text:Setup(self.environment.game.environment_hud)
		text.x=OFFSETX+self.environment.game.window.frame:GetWidth()/2;text.y=OFFSETY+self.environment.game.window.frame:GetHeight()/2-125-25
		text.drawable.width=500;text.drawable.height=70
		text:SetText("Move with WASD or by holding both mouse buttons")
		text=XANESHPRACTICE.Debug_Text.new();text:Setup(self.environment.game.environment_hud)
		text.x=OFFSETX+self.environment.game.window.frame:GetWidth()/2;text.y=OFFSETY+self.environment.game.window.frame:GetHeight()/2-125-50
		text.drawable.width=500;text.drawable.height=70
		text:SetText("Press Esc to quit")		
		
	end
	
	function XANESHPRACTICE.Scenario:PopulatePlayerHUD()
		-- do nothing
		
	end	
	
	
	--function class:CreateBossController()
		-- self.aggramar=XANESHPRACTICE.AGGRAMAR_BossController_Aggramar.new()
		-- --TODO: at this point it becomes very awkward that scenario.environment is not scenario.environment_gameplay
		-- self.aggramar:Setup(self.environment.game.environment_gameplay,self)
		-- self.aggramar:CreateBoss()		
		-- self.aggramar.groupdancemodule.bosscontroller=self.aggramar
		-- self.aggramar.groupdancemodule:PopulateDefaultRaid(self.environment.game.environment_gameplay)
	--end
	
	function class:OnStartButton()
		for i=1,#self.startbuttons do
			self.startbuttons[i].visible=false	
			self.startbuttons[i].drawable.frame:EnableMouse(false)
		end		
	end

	function XANESHPRACTICE.Scenario:OnEscapeKey()
		--pass through to parent function (and call Shutdown)
		self.environment.game.xaneshpractice:Shutdown()
	end
	
end