require "ISUI/Maps/ISWorldMap"
local util = require "MGRS_util"

local ISWorldMap_ShowWorldMap = ISWorldMap.ShowWorldMap
function ISWorldMap.ShowWorldMap(playerNum)
    ISWorldMap_ShowWorldMap(playerNum)
    if ISWorldMap_instance then ISWorldMap_instance:setShowCellGrid(true) end
end


local WorldMapOptions_getVisibleOptions = WorldMapOptions.getVisibleOptions
function WorldMapOptions:getVisibleOptions()
    local result = WorldMapOptions_getVisibleOptions(self)
    if self.showAllOptions then return result end

    for i=1,self.map.mapAPI:getOptionCount() do
        local option = self.map.mapAPI:getOptionByIndex(i-1)
        if option:getName() == "CellGrid" then
            table.insert(result, option)
        end
    end
    return result
end


local ISWorldMap_render = ISWorldMap.render
function ISWorldMap:render()
    ISWorldMap_render(self)
    if self.currentGridID then
        local gridID, x, y = self.currentGridID[1], self.currentGridID[2], self.currentGridID[3]
        self:drawText(gridID, x+30, y+30, 0.1, 0.1, 0.1, 1, UIFont.Title)
    end
end


local ISWorldMap_onMouseMove = ISWorldMap.onMouseMove
function ISWorldMap:onMouseMove(dx, dy)
    ISWorldMap_onMouseMove(self, dx, dy)

    local mouseX = self:getMouseX()
    local mouseY = self:getMouseY()

    local worldX = self.mapAPI:uiToWorldX(mouseX, mouseY)
    local worldY = self.mapAPI:uiToWorldY(mouseX, mouseY)

    if getWorld():getMetaGrid():isValidSquare(worldX,worldY) then
        local gridID = util.xyToLabel(worldX, worldY)
        self.currentGridID = {gridID, mouseX, mouseY}
    else
        self.currentGridID = nil
    end
end