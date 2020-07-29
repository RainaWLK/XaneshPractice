
XANESHPRACTICE.Scenario = {}
local class=XANESHPRACTICE.Scenario
class.__index = class

function class.new()
	local self=setmetatable({}, class)	
	return self
end


function class:Setup(game)
	self.game=game
	self.scenariotime=0
	self.nextevent=0.125
	
	self:SetCustomInfo()
end


function class:SetCustomInfo()

	self:SetCamera()
	
end


-- Override SetCamera if the environment uses a different camera (such as Camera_HUD).
-- TODO LATER: either leave comment about not calling super in overridden function, or change default camera to nil
function class:SetCamera()
	self.game.environment_gameplay.cameramanager.camera=XANESHPRACTICE.Camera.new()
	self.game.environment_gameplay.cameramanager.camera:Setup(self.game.environment_gameplay)
end

function class:GetPlayerInput(elapsed)
	--override
end
function class:Step(elapsed)
	--TODO: use this, or use localtime?
	self.scenariotime=self.scenariotime+elapsed
	--print(elapsed,self.nextevent)
	if(self.nextevent)then
		if(self.scenariotime>=self.nextevent)then
			
			self:Populate()
	
			self.nextevent=nil
		end
	end
	
	
end

function class:Populate()
	--return self.raid:Populate(self.environment.game.environment_gameplay)	
	--local controls = XANESHPRACTICE.ScenarioPlayerControls.new()

			self:CreatePlayerControls()
			-- local currentplayer=self:Populate()
			-- --print(player)
			-- controls:SetPlayer(currentplayer)
			-- currentplayer:SetPlayerAppearance()
			-- local relevant=XANESHPRACTICE.Aura_PlayerControlled.new()
			-- relevant:Setup(currentplayer.combat,currentplayer.combat,currentplayer:GetLocalTime())
			
			-- self.currentplayer=currentplayer			
	--self:PopulatePlayerHUD()
end

function class:CreatePlayerControls()
	-- local controls = XANESHPRACTICE.ScenarioPlayerControls_CharacterMode.new()
	-- controls:Setup(self.game.environment_gameplay,self)			
	-- self.controls=controls
end

function class:PopulatePlayerHUD()
	-- -- override for scenarios which should not have player HUD elements
	
	-- --TODO: decide whether to call them "hotbars" or "actionbars"
	-- local env=self.game.environment_hotbar
	-- self.actionbar=XANESHPRACTICE.ActionBar.new()
	-- self.actionbar:Setup(env)

end

function class:SetCurrentPlayer(mob)
	self.currentplayer=mob
	self.actionbar:SetCurrentPlayer(mob)
	
end


function class:GetRandomRangedTargetCombats(min_ranged,num_targets)	
	local targets={}
	
	if(not min_ranged)then min_ranged=3 end
	if(not num_targets)then num_targets=1 end
	
	local rangedtargets=self.raid:GetAllRangedTargets()
	if(#rangedtargets<min_ranged)then
		self.raid:GetAllTargets()
	end
	
	--print("GetRandomRangedTarget, first pass:",#rangedtargets,#targets,num_targets)
	--TODO: refine logic
	while(#rangedtargets>0 and #targets<num_targets)do		
		local i=math.floor((math.random()*#rangedtargets)+1)
		tinsert(targets,rangedtargets[i].combat)
		tremove(rangedtargets,i)
		--print("GetRandomRangedTarget, loop:",#rangedtargets,#targets,num_targets,i)
	end
	
	
	return targets
	
end

function class:Cleanup()
	for i=1,#self.combatlog.groupdancemodules do
		self.combatlog.groupdancemodules[i]:Cleanup()
	end
end

function class:OnEscapeKey()
	--override, don't call super
	if(_XANESHPRACTICE)then
		_XANESHPRACTICE:Shutdown()
	end
end