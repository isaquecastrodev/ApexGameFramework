local Utils = {}

function Utils:DeepCopy(tbl)
    if type(tbl) ~= "table" then return tbl end
    local copy = {}
    for k,v in pairs(tbl) do copy[k] = self:DeepCopy(v) end
    return copy
end

function Utils:Clamp(val, min, max)
    if val < min then return min end
    if val > max then return max end
    return val
end

function Utils:TableCount(t)
    local n = 0
    for _ in pairs(t) do n = n + 1 end
    return n
end

return Utils
