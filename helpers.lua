function addVec(v1, v2)
    return v1.x + v2.x, v1.y + v2.y
end

function eqAdd(v, other)
    local x = v.x + other.x
    local y = v.y + other.y
    return x, y
end
