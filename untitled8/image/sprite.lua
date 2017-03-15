--
-- created with TexturePacker (http://www.codeandweb.com/texturepacker)
--
-- $TexturePacker:SmartUpdate:bd36e32cf4f02e30a0394839f4eaa92c:5f5bb52d7fe05d614645b3df81f3c209:ab53c0937f41bb2487347d8c04ab9d24$
--
-- local sheetInfo = require("mysheet")
-- local myImageSheet = graphics.newImageSheet( "mysheet.png", sheetInfo:getSheet() )
-- local sprite = display.newSprite( myImageSheet , {frames={sheetInfo:getFrameIndex("sprite")}} )
--

local SheetInfo = {}

SheetInfo.sheet =
{
    frames = {
    
        {
            -- attack
            x=1,
            y=643,
            width=316,
            height=64,

            sourceX = 3,
            sourceY = 0,
            sourceWidth = 328,
            sourceHeight = 64
        },
        {
            -- player_00 (2)
            x=1,
            y=1,
            width=384,
            height=640,

        },
    },
    
    sheetContentWidth = 386,
    sheetContentHeight = 708
}

SheetInfo.frameIndex =
{

    ["attack"] = 1,
    ["player_00 (2)"] = 2,
}

function SheetInfo:getSheet()
    return self.sheet;
end

function SheetInfo:getFrameIndex(name)
    return self.frameIndex[name];
end

return SheetInfo
