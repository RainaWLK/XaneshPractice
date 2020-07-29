
--
-- Xanesh Practice is still undergoing construction.
-- Please don't redistribute this addon until official release.
--


--TODO LATER: print debugstack on certain OOP problems such as (but not limited to) inheritance errors

--
-- XANESHPRACTICE "class".  Non-OOP (call methods using . notation instead of : notation)
--

XANESHPRACTICE.LOADED=false
XANESHPRACTICE.TOCVersion=nil
XANESHPRACTICE.games={}

-- event handler frame.  handles ADDON_LOADED and .
-- OnUpdate (step event) has been moved to gamewindow (which also handles input events).
XANESHPRACTICE.EventHandlerFrame = CreateFrame("Frame")

function XANESHPRACTICE.EventHandlerFrame:OnEvent(event, ...)
	if(event=="ADDON_LOADED") then
		XANESHPRACTICE.EventHandlerFrame:OnLoad(...)
	end
end

function XANESHPRACTICE.EventHandlerFrame:OnLoad(AddOn)		
	-- run init code only once
	if(AddOn=="XaneshPractice" and XANESHPRACTICE.LOADED==false) then				
		XANESHPRACTICE.LOADED=true
		self:UnregisterEvent("ADDON_LOADED")		
		-- savedata has been loaded by now, if it exists.
		-- if it's still nil, then there was no data to load.
		if(XANESHPRACTICE.SAVEDATA==nil) then XANESHPRACTICE.SAVEDATA={} end				

		local v,b,d,t=GetBuildInfo()
		XANESHPRACTICE.TOCVersion=t
			
		XANESHPRACTICE.NewsAndUpdates()
		
	end 
end

XANESHPRACTICE.EventHandlerFrame:RegisterEvent("ADDON_LOADED")
XANESHPRACTICE.EventHandlerFrame:SetScript("OnEvent", XANESHPRACTICE.EventHandlerFrame.OnEvent)




SLASH_XANESHPRACTICE1 = "/xp"

function SlashCmdList.XANESHPRACTICE(msg,editbox)
	if(XANESHPRACTICE.LOADED==false)then 
		print("Xanesh Practice hasn't loaded yet.  Wait a moment and try again.")
		return 
	end
	
	local args={}
	local i=1
	for arg in string.gmatch(msg, "%S+") do	
		args[i]=arg
		i=i+1
		--print(arg)
	end	
	
	if(#args==0 and args[1]==nil)then
		if(#XANESHPRACTICE.games==0)then
			print("Starting up Xanesh Practice...")
			XANESHPRACTICE.alreadyattemptederrorshutdown=false
			XANESHPRACTICE.StartNewGame()
		else
			if(XANESHPRACTICE.DEBUG.allowmultiboxing)then
				print("Starting up Xanesh Practice (multiboxing)...")
				XANESHPRACTICE.alreadyattemptederrorshutdown=false
				XANESHPRACTICE.StartNewGame()				
			elseif(XANESHPRACTICE.DEBUG.autoshutdownrestart)then
				print("Restarting Xanesh Practice...")
				XANESHPRACTICE.EmergencyShutdown()
				XANESHPRACTICE.alreadyattemptederrorshutdown=false
				XANESHPRACTICE.StartNewGame()				
			else
				print("Xanesh Practice appears to be running already.  If something broke, type /xp shutdown.")
			end
		end
	end
	
	if(args[1]=="shutdown")then
		XANESHPRACTICE:EmergencyShutdown()
	end
	
	if(XANESHPRACTICE.DEBUG.extraslashcommands)then
		if(args[1]=="reset") then		
			if(args[2]~="confirm") then
				print("To delete all Xanesh Practice saved data, type /xp reset confirm")
			else			
				XANESHPRACTICE.EmergencyShutdown()			
				XANESHPRACTICE.SAVEDATA={}
				print("Xanesh Practice data has been reset.")			
			end
		end 
	end
end

-- XANESHPRACTICE.EventHandlerFrame.OnUpdate=function(self,elapsed)
	-- if(XANESHPRACTICE.games)then
		-- XANESHPRACTICE.xpcall(function()XANESHPRACTICE.games[1].MainGameLoop(XANESHPRACTICE.games[1],elapsed)end)
	-- end
-- end


function XANESHPRACTICE.StartNewGame()	
	if(#XANESHPRACTICE.games==0)then
		XANESHPRACTICE.CVars:SaveAll()
	end
	local game=XANESHPRACTICE.Game.new()	
	game:Setup(XANESHPRACTICE)
	tinsert(XANESHPRACTICE.games,game)
	
	--XANESHPRACTICE.EventHandlerFrame:SetScript("OnUpdate", XANESHPRACTICE.EventHandlerFrame.OnUpdate)
end

function XANESHPRACTICE:EmergencyShutdown()	
	for i=#XANESHPRACTICE.games,1,-1 do
		XANESHPRACTICE.games[i]:Shutdown()
	end
	XANESHPRACTICE.games={}
end

function XANESHPRACTICE.RemoveDeadGames()
	for i=#XANESHPRACTICE.games,1,-1 do
		if(XANESHPRACTICE.games[i].dead)then
			tremove(XANESHPRACTICE.games,i)
		end
	end
	if(#XANESHPRACTICE.games==0)then
		XANESHPRACTICE.Shutdown()
	end
end

function XANESHPRACTICE.Shutdown()
	XANESHPRACTICE.CVars:RestoreAll()
	--XANESHPRACTICE.EventHandlerFrame:SetScript("OnUpdate", nil)
	XANESHPRACTICE.Cleanup()
end

function XANESHPRACTICE.Cleanup()
	XANESHPRACTICE.ReusableFrames:ResetAndReport()
	print("Xanesh Practice was shut down.  Type /xp to restart.")
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
















	