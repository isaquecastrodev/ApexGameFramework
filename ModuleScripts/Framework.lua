local EventBus = require(script.Parent.EventBus)
local EntityManager = require(script.Parent.EntityManager)
local QuestSystem = require(script.Parent.QuestSystem)
local InventorySystem = require(script.Parent.InventorySystem)
local CombatSystem = require(script.Parent.CombatSystem)
local PlayerDataClass = require(script.Parent.PlayerData)

local Framework = {}
Framework.__index = Framework

function Framework.new()
    local self = setmetatable({}, Framework)
    self.EventBus = EventBus.new()
    self.EntityManager = EntityManager.new()
    self.Quest = QuestSystem.new(self.EventBus)
    self.Inventory = InventorySystem.new(self.EventBus)
    self.Combat = CombatSystem.new(self.EventBus)
    self._playerData = {} -- Player -> PlayerData instance
    return self
end

function Framework:OnPlayerAdded(player)
    local pd = PlayerDataClass.new(player)
    pd:Load()
    self._playerData[player] = pd

    -- assign starter quest for demo
    if self.Quest and self.Quest._definitions and next(self.Quest._definitions) ~= nil then
        -- pick first quest definition
        for id,_ in pairs(self.Quest._definitions) do
            self.Quest:AssignQuestToPlayer(pd, id)
            break
        end
    end

    self.EventBus:Emit("PlayerJoined", player, pd)
end

function Framework:OnPlayerRemoving(player)
    local pd = self._playerData[player]
    if pd then
        pd:Save()
        self._playerData[player] = nil
    end
    self.EventBus:Emit("PlayerLeft", player)
end

function Framework:GetPlayerData(player)
    return self._playerData[player]
end

function Framework:SaveAll()
    for player, pd in pairs(self._playerData) do
        pd:Save()
    end
end

return Framework
