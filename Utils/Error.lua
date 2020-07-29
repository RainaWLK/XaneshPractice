-- note that xpcall doesn't accept function arguments,
-- so fn() should be an anonymous function with its arguments baked in
-- At the moment, this is only used for game:MainGameLoop 
-- to prevent bad things from happening if an error occurs every frame.
function XANESHPRACTICE.xpcall(fn)
	xpcall(fn,function(msg)XANESHPRACTICE.ErrorHandler(msg)end)
end


function XANESHPRACTICE.ErrorHandler(msg)	
	print(msg)
	XANESHPRACTICE.PrintStackTrace()
	print("|cFFFF0000A Lua error was detected.  Shutting down Xanesh Practice to prevent further issues.")
	
	-- it turns out this function still counts as within xpcall, so any further errors will cause a recursive loop	
	if(XANESHPRACTICE and not XANESHPRACTICE.alreadyattemptederrorshutdown)then
		XANESHPRACTICE.alreadyattemptederrorshutdown=true
		XANESHPRACTICE:Shutdown()
	end		
	
	--TODO: instead of showing error in default lua window, 
	-- print stacktrace to a custom copypastable error dialog instead
	-- (which won't rely on scriptErrors cvar)
	-- we also attempt to display the error in the default lua error window.
	-- we need to break out of xpcall to do so
	-- (note that the stacktrace won't be tremendously useful)
	C_Timer.After(0.5,function()
			error(msg)		
			-- anything past this point won't happen
		end
	)
end



function XANESHPRACTICE.PrintStackTrace()
	local ds=debugstack()
	local split_debugstack=XANESHPRACTICE.split_lines(ds)
	for i,v in ipairs(split_debugstack) do
		print(v)	
	end
end