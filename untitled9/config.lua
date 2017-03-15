--
-- For more information on config.lua see the Corona SDK Project Configuration Guide at:
-- https://docs.coronalabs.com/guide/basics/configSettings
--

application =
{
	content =
	{
		width = 1280,
		height = 720, 
		scale = "letterBox",
		fps = 30,
		
		--[[
		imageSuffix =
		{
			    ["@2x"] = 2,
			    ["@4x"] = 4,
		},
		--]]
	},
	window =
	{
		defaultViewWidth = 1280,
		defaultViewWidth = 720,
		resizable = true,
		minViewWidth = 1280,
		minViewHeight = 720,
		enableCloseButton = true,
		enableMinimizeButton = true,
		enableMaximizeButton = true,
		suspendWhenMinimized = true,
		titleText =
		{
			default = "Hello World1"
		},
	},
}
