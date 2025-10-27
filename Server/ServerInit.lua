local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local root = ReplicatedStorage:WaitForChild("ApexGameFramework")
local FrameworkModule = require(root.ModuleScripts.Framework)

local framework = FrameworkModule.new()

local QuestDef = require(root.ModuleScripts.QuestSystem)
local demoQuest = QuestDef and QuestDef.new(101, "Collect 5 Coins", "Collect", 5, {XP = 100, Gold = 50}) or nil
if demoQuest then framework.Quest:RegisterQuest(demoQuest) end

Players.PlayerAdded:Connect(function(plr)
    framework:OnPlayerAdded(plr)
end)

Players.PlayerRemoving:Connect(function(plr)
    framework:OnPlayerRemoving(plr)
end)

local moduleValue = Instance.new("ModuleScript")
moduleValue.Name = "FrameworkDebug"
moduleValue.Source = "-- debug placeholder"
moduleValue.Parent = root
-- store actual table in an attribute (not perfect but for dev)
root:SetAttribute("FrameworkInitialized", true)

local remotes = root:WaitForChild("Remotes")
local reqUse = remotes:WaitForChild("ReqUseItem")

reqUse.OnServerEvent:Connect(function(player, itemId)
    local pd = framework:GetPlayerData(player)
    if not pd then return end
    local used = framework.Inventory:UseItem(pd, itemId)
    if used then
        if itemId == "health_potion" then
            framework.Combat:Heal(pd, 50)
        end
        remotes.PlayerDataResponse:FireClient(player, pd:GetData())
    end
end)

game:BindToClose(function()
    framework:SaveAll()
end)

_G.ApexFramework = framework
print("[ApexGameFramework] Initialized")
