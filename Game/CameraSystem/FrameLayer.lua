do
	XANESHPRACTICE.FrameLayer = {}
	XANESHPRACTICE.FrameLayer.__index = XANESHPRACTICE.FrameLayer
	local class=XANESHPRACTICE.FrameLayer
	
	function XANESHPRACTICE.FrameLayer.new()
		local self=setmetatable({}, XANESHPRACTICE.FrameLayer)	
		return self
	end
	
	function XANESHPRACTICE.FrameLayer.QuickSetup(level)
		local framelayer=XANESHPRACTICE.FrameLayer.new()
		framelayer.level=level
		return framelayer
	end
end