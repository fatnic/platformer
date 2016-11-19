local ParticlesSystem = class("ParticlesSystem", System)

function ParticlesSystem:onAddEntity(entity)
   local pos = entity:get("Position") 
   local par = entity:get("Particles")

    entity.particles = love.graphics.newParticleSystem(par.image, 32)
    entity.particles:setParticleLifetime(0.5, 1)
    entity.particles:setLinearAcceleration(-5, -10, 5, -40)
    entity.particles:setColors(50, 50, 50, 50, 100, 100, 100, 50, 150, 150, 150, 50)
    entity.particles:setEmitterLifetime(-1)
    entity.particles:setSizes(0.05, 0.1, 0.15, 0.2, 0.25)
    entity.particles:setSpread(math.rad(55))
    entity.particles:setTangentialAcceleration(3, 10)
end

function ParticlesSystem:initialize()
    System.initialize(self)
end

function ParticlesSystem:update(dt)
    for _, e in pairs(self.targets) do
        local pos = entity:get("Position")
        local par = entity:get("Particles").particles

        par:moveTo(pos:unpack())
        par:emit(32)
        par:update(dt)
    end
end

function ParticlesSystem:draw()
    for _, e in pairs(self.targets) do
        local par = e:get("Particles").particles
        love.graphics.draw(par)
    end
end

function ParticlesSystem:requires()
    return {"Position", "Particles"}
end

return ParticlesSystem
