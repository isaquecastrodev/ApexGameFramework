local EventBus = {}
EventBus.__index = EventBus

function EventBus.new()
    local self = setmetatable({}, EventBus)
    self._listeners = {}
    return self
end

function EventBus:On(eventName, callback)
    self._listeners[eventName] = self._listeners[eventName] or {}
    table.insert(self._listeners[eventName], callback)
end

function EventBus:Emit(eventName, ...)
    local listeners = self._listeners[eventName]
    if not listeners then return end
    for _, cb in ipairs(listeners) do
        -- pcall to avoid one listener breaking others
        local ok, err = pcall(cb, ...)
        if not ok then warn("EventBus listener error:", err) end
    end
end

return EventBus
