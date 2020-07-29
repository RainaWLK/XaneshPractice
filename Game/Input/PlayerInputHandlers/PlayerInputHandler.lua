
XANESHPRACTICE.PlayerInputHandler = {}
XANESHPRACTICE.PlayerInputHandler.__index = XANESHPRACTICE.PlayerInputHandler
function XANESHPRACTICE.PlayerInputHandler.new()
	local self=setmetatable({}, XANESHPRACTICE.PlayerInputHandler)
	return self
end

function XANESHPRACTICE.PlayerInputHandler:Setup(environment)
	self.environment=environment
end

function XANESHPRACTICE.PlayerInputHandler:ProcessInput()
	--override
end