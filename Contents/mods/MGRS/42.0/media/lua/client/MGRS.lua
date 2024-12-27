require "ISUI/Maps/ISWorldMap"
local util = require "MGRS_util"

local ISWorldMap_ShowWorldMap = ISWorldMap.ShowWorldMap
function ISWorldMap.ShowWorldMap(playerNum)
    ISWorldMap_ShowWorldMap(playerNum)
    --if ISWorldMap_instance then ISWorldMap_instance:setShowCellGrid(true) end
end


local WorldMapOptions_getVisibleOptions = WorldMapOptions.getVisibleOptions
function WorldMapOptions:getVisibleOptions()
    local result = WorldMapOptions_getVisibleOptions(self)
    if self.showAllOptions then return result end
    for i=1,self.map.mapAPI:getOptionCount() do
        local option = self.map.mapAPI:getOptionByIndex(i-1)
        if option:getName() == "CellGrid" then table.insert(result, option) end
    end
    return result
end


local ISWorldMap_saveSettings = ISWorldMap.saveSettings
function ISWorldMap:saveSettings()
    if not MainScreen.instance or not MainScreen.instance.inGame then return end

    ISWorldMap_saveSettings(self)

    local writer = getFileWriter("MGRS.ini", true, false)

    local options = {
        CellGrid = self.mapAPI:getBoolean("CellGrid")
    }

    for option,value in pairs(options) do
        writer:write(option.."="..tostring(value)..",\n")
    end

    writer:close()
end


local ISWorldMap_restoreSettings = ISWorldMap.restoreSettings
function ISWorldMap:restoreSettings()
    if not MainScreen.instance or not MainScreen.instance.inGame then return end

    ISWorldMap_restoreSettings(self)

    local fileReader = getFileReader("MGRS.ini", true)
    local options = {}
    local line = fileReader:readLine()
    while line do
        for optionName,optionValue in string.gmatch(line, "([^=]*)=([^=]*),") do
            options[optionName] = optionValue
        end
        line = fileReader:readLine()
    end
    fileReader:close()

    local cellGrid = options["CellGrid"]=="true" and true or false
    self:setShowCellGrid(cellGrid)
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

    if self.mapAPI:getBoolean("CellGrid") ~= true then
        self.currentGridID = nil
        return
    end

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