local keep_this_line_here_to_avoid_lua_errors_upon_addon_load=1



	
-- This page is intentionally left blank
-- ...unless you happen to have stumbled across it during a point of development in which it wasn't left blank.


-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
do
	local super=XANESHPRACTICE.Mob
	XANESHPRACTICE.DEFAULTSCENARIO.PlayerGhost=XANESHPRACTICE.inheritsFrom(XANESHPRACTICE.Mob)
	local class=XANESHPRACTICE.DEFAULTSCENARIO.PlayerGhost
	
	local DISABLE_DISTANCE=7
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.targetghostalpha=1
		self.ghostalpha=1
		self.ghostalphamultiplier=0.75		
		self.enabled=true
		self.basemovespeed=14	--ghosts need to cheat to reach the start portal in time, for group 4 CCW
	end	
	function class:CreateDisplayObject()
		self.displayobject=XANESHPRACTICE.ModelSceneActor.new()
		self.displayobject:Setup(self)
		self.displayobject.drawable:SetModelByUnit("player")
	end	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		if(self.scenario and self.scenario.player)then
			local xdist=self.scenario.player.position.x-self.position.x
			local ydist=self.scenario.player.position.y-self.position.y
			local distsqr=xdist*xdist+ydist*ydist
			if(distsqr<DISABLE_DISTANCE*DISABLE_DISTANCE)then
				self.targetghostalpha=0
				self.enabled=false
			else
				self.targetghostalpha=1
				self.enabled=true
			end
			if(self.ghostalpha>self.targetghostalpha)then
				self.ghostalpha=self.ghostalpha-elapsed*0.5
				if(self.ghostalpha<self.targetghostalpha)then self.ghostalpha=self.targetghostalpha end
			end
			if(self.ghostalpha<self.targetghostalpha)then
				self.ghostalpha=self.ghostalpha+elapsed*0.5
				if(self.ghostalpha>self.targetghostalpha)then self.ghostalpha=self.targetghostalpha end
			end			
		end
	end
	function class:GetFinalAlpha()
		local alpha=0
		local fadealpha=1
		if(self.expirytime and self.fadestarttime)then
			fadealpha=1-(self.environment.localtime-self.fadestarttime)/(self.expirytime-self.fadestarttime)
			if(fadealpha>1)then fadealpha=1 end
			if(fadealpha<0)then fadealpha=0 end
		end
		return self.ghostalpha*self.ghostalphamultiplier*fadealpha
	end
	
	function class:Draw(elapsed)
		self.animationmodule:Step(elapsed)
		self.displayobject:SetPositionAndScale(self.position,self.scale)
		self.displayobject:SetOrientation(self.orientation_displayed)
		self.displayobject:SetAlpha(self:GetFinalAlpha())
	end	
	
end


-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------

-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------

-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------

-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------

-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------

do
	XANESHPRACTICE.CombatModule = {}
	local class=XANESHPRACTICE.CombatModule
	class.__index = class

	function class.new()
		local self=setmetatable({}, class)
		return self 
	end
	
	function class:Setup(mob)
		self.mob=mob
		self.targetmob=nil
		self.autoattacking=false
		self.nextMHautoattack=nil
		self.nextOHautoattack=nil
	end
	
	function class:SetTargetMob(mob)
		self.targetmob=mob
		if(mob==nil)then
			self:StopAutoAttacking()
		end
	end
	
	function class:StartAutoAttacking()
		self.autoattacking=true
	end
	function class:StopAutoAttacking()
		self.autoattacking=false
	end
	
	function class:HasMHAutoAttack()
		--TODO: NYI HasMHAutoAttack()
		--return true
		return false
	end
	function class:HasOHAutoAttack()
		--TODO: NYI HasOHAutoAttack()
		return false
	end	
	
	function class:Step(elapsed)
		local localtime=self.mob.environment.localtime
		if(self.autoattacking)then
			if(self:HasMHAutoAttack())then
				if(not self.nextMHautoattack)then
					self.nextMHautoattack=localtime
				end
				if(localtime>=self.nextMHautoattack)then
					self.nextMHautoattack=self.nextMHautoattack+2.60
					self.mob.animationmodule:PlayAnimation(XANESHPRACTICE.AnimationList.Attack1H)
				end
			end
		else
			if(self.nextMHautoattack and localtime>=self.nextMHautoattack)then
				self.nextMHautoattack=nil
			end
			if(self.nextOHautoattack and localtime>=self.nextOHautoattack)then
				self.nextOHautoattack=nil
			end			
		end
		
	end
	
end

-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
function XANESHPRACTICE_RaidBossEmote(message,duration,clear)
		-- center-screen raid notice is easy
		if(clear)then
			RaidNotice_Clear(RaidBossEmoteFrame)
		end
		RaidNotice_AddMessage(RaidBossEmoteFrame, message, ChatTypeInfo["RAID_BOSS_EMOTE"],duration)
		-- chat messages are trickier
		local i
		for i = 1, NUM_CHAT_WINDOWS do
			local chatframes = { GetChatWindowMessages(i) }			
			local v
			for _, v in ipairs(chatframes) do
				if v == "MONSTER_BOSS_EMOTE" then
					local frame = 'ChatFrame' .. i
					if _G[frame] then
						_G[frame]:AddMessage(message,1.0,1.0,0.0,GetChatTypeIndex(ChatTypeInfo["RAID_BOSS_EMOTE"].id))
					end
					break
				end
			end
		end
	end

-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------
-------------------------------------------------------