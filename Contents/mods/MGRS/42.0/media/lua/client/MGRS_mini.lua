require "ISUI/Maps/ISMiniMap"
local util = require "MGRS_util"

local ISMiniMapOuter_render = ISMiniMapOuter.render
function ISMiniMapOuter:render()
    ISMiniMapOuter_render(self)

    if self:isMouseOver() then
        local playerObj = getSpecificPlayer(self.playerNum)
        if not playerObj then return end
        local vehicle = playerObj and playerObj:getVehicle()
        local trackOnto = vehicle or playerObj

        if trackOnto then

            local x, y = trackOnto:getX(), trackOnto:getY()
            local gridID = util.xyToLabel(x, y)

            self:drawText(gridID, 3, 1, 1, 1, 1, 1, UIFont.NewSmall)
        end
    end
end