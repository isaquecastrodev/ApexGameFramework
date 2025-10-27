local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local Utils = require(script.Parent.Utils)

local PlayerData = {}
PlayerData.__index = PlayerData

local DATASTORE = DataStoreService:GetDataStore("ApexGameFramework_v1")

function PlayerData.new(player)
    local self = setmetatable({}, PlayerData)
    self.Player = player
    self.Key = "player_" .. player.UserId
    self.Data = {
        Stats = {
            Level = 1,
            XP = 0,
            MaxHealth = 100,
        },
        Inventory = {},
        Quests = {},
    }
    return self
end

function PlayerData:Load()
    local success, stored = pcall(function()
        return DATASTORE:GetAsync(self.Key)
    end)
    if success and type(stored) == "table" then
        self.Data = stored
        print("[PlayerData] Loaded for", self.Player.Name)
    else
        print("[PlayerData] New data for", self.Player.Name)
    end
end

function PlayerData:Save()
    local clone = Utils:DeepCopy(self.Data)
    local success, err = pcall(function()
        DATASTORE:SetAsync(self.Key, clone)
    end)
    if not success then
        warn("[PlayerData] Save failed for", self.Player.Name, err)
    else
        print("[PlayerData] Saved for", self.Player.Name)
    end
end

function PlayerData:AddItem(itemId, amount)
    amount = amount or 1
    self.Data.Inventory[itemId] = (self.Data.Inventory[itemId] or 0) + amount
end

function PlayerData:HasItem(itemId)
    return (self.Data.Inventory[itemId] or 0) > 0
end

function PlayerData:AddQuest(questObj)
    self.Data.Quests[questObj.Id] = questObj
end

function PlayerData:GetData() return self.Data end

return PlayerData
