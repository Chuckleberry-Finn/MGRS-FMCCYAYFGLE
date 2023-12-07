local util = {}

function util.numToAlpha(n)
    local looped = math.floor((n-1)/26)
    local prefix = looped>0 and string.char(looped+96) or ""
    local alpha = string.char(n-(looped*26)+96)
    return (prefix..alpha)
end

function util.xyToLabel(x, y)

    local cellX = math.floor(x/300)+1
    local cellY = math.floor(y/300)+1

    local deliminator = "-"
    if SandboxVars.MGRS.style ~= 2 then
        cellX = util.numToAlpha(cellX)
        deliminator = ""
    end

    local gridID = string.upper(cellX..deliminator..cellY)

    return gridID
end

return util