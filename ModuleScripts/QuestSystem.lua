local QuestSystem = {}
QuestSystem.__index = QuestSystem

local QuestTemplate = {}
QuestTemplate.__index = QuestTemplate
function QuestTemplate.new(id, title, goalType, goalAmount, reward)
    local self = setmetatable({}, QuestTemplate)
    self.Id = id
    self.Title = title
    self.GoalType = goalType -- e.g., "Collect", "Kill"
    self.GoalAmount = goalAmount or 1
    self.Reward = reward or {}
    return self
end

function QuestTemplate:CreateInstance()
    return {
        Id = self.Id,
        Title = self.Title,
        GoalType = self.GoalType,
        GoalAmount = self.GoalAmount,
        Progress = 0,
        Completed = false,
        Reward = self.Reward,
    }
end

function QuestSystem.new(eventBus)
    local self = setmetatable({}, QuestSystem)
    self._eventBus = eventBus
    self._definitions = {} -- id -> QuestTemplate
    return self
end

function QuestSystem:RegisterQuest(def)
    self._definitions[def.Id] = def
end

function QuestSystem:AssignQuestToPlayer(playerData, questId)
    local def = self._definitions[questId]
    if not def then return end
    playerData.Data.Quests[questId] = def:CreateInstance()
    self._eventBus:Emit("QuestAssigned", playerData.Player, playerData.Data.Quests[questId])
end

function QuestSystem:AddProgress(playerData, questId, amount)
    local q = playerData.Data.Quests[questId]
    if not q or q.Completed then return end
    q.Progress = q.Progress + (amount or 1)
    if q.Progress >= q.GoalAmount then
        q.Completed = true
        self._eventBus:Emit("QuestCompleted", playerData.Player, q)
        -- apply reward (emit event to let other systems handle)
        self._eventBus:Emit("QuestReward", playerData.Player, q.Reward)
    else
        self._eventBus:Emit("QuestProgress", playerData.Player, q)
    end
end

return QuestSystem
