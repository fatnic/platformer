local LightingSystem = class("LightingSystem", System)

function LightingSystem:initialize(lights)
    System.initialize(self)
    self.lights = lights
end

function LightingSystem:onAddEntity(entity)
    local pos = entity:get("Position")
    local le = entity:get("LightEmitter")
    le.light = self.lights:newLight(pos.x, pos.y, le.r, le.g, le.b, le.radius)
end

function LightingSystem:update(dt)
   
    for _, e in pairs(self.targets) do
        local pos = e:get("Position")
        local le = e:get("LightEmitter")

        if not le.static then le.light:setPosition(pos.x, pos.y) end

    end

    self.lights:update(dt)
end

function LightingSystem:render(lgts, mp, eng)
    lgts:draw(function() 
        mp:draw()
        eng:draw()
    end)
end

function LightingSystem:requires()
    return {"Position", "LightEmitter"}
end

return LightingSystem
