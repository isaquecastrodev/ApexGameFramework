local RunService = game:GetService("RunService")
local waitTime = 60 

while true do
    wait(waitTime)
    if _G and _G.ApexFramework then
        _G.ApexFramework:SaveAll()
        print("[DataSaveLoop] Saved all player data")
    end
    if RunService:IsStudio() then
    end
end
