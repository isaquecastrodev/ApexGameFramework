local InventorySystem = {}
InventorySystem.__index = InventorySystem

function InventorySystem.new(eventBus)
    local self = setmetatable({}, InventorySystem)
    self._eventBus = eventBus
    return self
end

function InventorySystem:GiveItem(playerData, itemId, amount)
    playerData:AddItem(itemId, amount)
    self._eventBus:Emit("InventoryChanged", playerData.Player, playerData.Data.Inventory)
end

function InventorySystem:UseItem(playerData, itemId)
    if not playerData:HasItem(itemId) then return false end
    playerData.Data.Inventory[itemId] = playerData.Data.Inventory[itemId] - 1
    if playerData.Data.Inventory[itemId] <= 0 then playerData.Data.Inventory[itemId] = nil end
    self._eventBus:Emit("InventoryChanged", playerData.Player, playerData.Data.Inventory)
    return true
end

return InventorySystem
