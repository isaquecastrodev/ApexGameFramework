local CombatSystem = {}
CombatSystem.__index = CombatSystem

function CombatSystem.new(eventBus)
    local self = setmetatable({}, CombatSystem)
    self._eventBus = eventBus
    return self
end

function CombatSystem:ApplyDamage(targetData, amount, source)
    targetData.Data.Stats = targetData.Data.Stats or {}
    targetData.Data.Stats.MaxHealth = targetData.Data.Stats.MaxHealth or 100
    targetData.Data.Stats.Health = targetData.Data.Stats.Health or targetData.Data.Stats.MaxHealth

    targetData.Data.Stats.Health = targetData.Data.Stats.Health - amount
    self._eventBus:Emit("Damaged", targetData.Player, amount, source)

    if targetData.Data.Stats.Health <= 0 then
        targetData.Data.Stats.Health = 0
        self._eventBus:Emit("Died", targetData.Player, source)
    end
end

function CombatSystem:Heal(targetData, amount)
    targetData.Data.Stats = targetData.Data.Stats or {}
    targetData.Data.Stats.MaxHealth = targetData.Data.Stats.MaxHealth or 100
    targetData.Data.Stats.Health = targetData.Data.Stats.Health or targetData.Data.Stats.MaxHealth

    targetData.Data.Stats.Health = math.min(targetData.Data.Stats.Health + amount, targetData.Data.Stats.MaxHealth)
    self._eventBus:Emit("Healed", targetData.Player, amount)
end

return CombatSystem
