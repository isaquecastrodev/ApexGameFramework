local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local root = ReplicatedStorage:WaitForChild("ApexGameFramework")
local remotes = root:WaitForChild("Remotes")
local reqUse = remotes:WaitForChild("ReqUseItem")
local reqAdd = remotes:WaitForChild("ReqAddItem")
local response = remotes:WaitForChild("PlayerDataResponse")

response.OnClientEvent:Connect(function(data)
    print("[Client] Received player data update:")
    print(data)
end)

local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.H then
        -- request to use item
        reqUse:FireServer("health_potion")
    end
    if input.KeyCode == Enum.KeyCode.K then
        -- request to give item (for testing via remote)
        reqAdd:FireServer("health_potion", 1)
    end
end)

