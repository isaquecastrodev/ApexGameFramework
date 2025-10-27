local EntityManager = {}
EntityManager.__index = EntityManager

function EntityManager.new()
    local self = setmetatable({}, EntityManager)
    self._entities = {}  -- id -> entity table
    self._nextId = 1
    return self
end

function EntityManager:CreateEntity(template)
    template = template or {}
    local id = self._nextId
    self._nextId = self._nextId + 1
    local entity = {
        Id = id,
        Data = template,
    }
    self._entities[id] = entity
    return entity
end

function EntityManager:GetEntity(id) return self._entities[id] end

function EntityManager:RemoveEntity(id) self._entities[id] = nil end

function EntityManager:ForEach(callback)
    for id, ent in pairs(self._entities) do callback(ent, id) end
end

return EntityManager
