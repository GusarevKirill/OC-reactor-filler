local me = require"component".me_interface
local shell = require"shell"

local args, options = shell.parse(...)
local reactorSide

if args[1] then
    reactorSide = args[1]
else
    io.write("Сторона реактора: ")
    reactorSide = io.read()
end

local components = {
    ["0"] = "IC2:reactorUraniumQuad",
    ["1"] = "IC2:reactorVentSpread",
    ["2"] = "IC2:reactorVentGold",
    ["3"] = "IC2:reactorPlating",
    ["4"] = "IC2:reactorHeatSwitchSpread"
}

local pattern = {
    "012422123",
    "312212202",
    "320220221",
    "122122123",
    "202202202",
    "321321321"
}

local function findComponent(componentId)
    local items = me.getAvailableItems()
    local component = components[componentId]
    
    for i, item in pairs(items) do
        if item.fingerprint.id == component and item.size > 0 then
            return item.fingerprint
        end
    end
    
    return nil
end

local i = 1

for _, line in pairs(pattern) do
    for x = 1, #line do
        local componentId = line:sub(x, x)
        local fingerprint = findComponent(componentId)
        
        if fingerprint then
            if not me.exportItem(fingerprint, reactorSide, 1, i) then
                print("Не найден компонент " .. components[componentId] .. " для слота " .. i)
            end
        else
            print("Не найден компонент " .. components[componentId] .. " для слота " .. i)
        end
        
        i = i + 1
    end
end