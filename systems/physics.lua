local PhysicsSystem = class("PhysicsSystem", System)

function PhysicsSystem:update(dt)

    for _, entity in pairs(self.targets) do
        local physics = entity:get("Physics")
        local p = entity:get("Position")
        local position = vec(p.x, p.y)
        physics.velocity = physics.velocity + physics.acceleration

        if entity:has("Friction") then physics.velocity = physics.velocity / entity:get("Friction").friction end
        if entity:has("Gravity")  then physics.velocity = physics.velocity + entity:get("Gravity").gravity end

        -- physics.velocity:trimInplace(physics.maxspeed)
        position = position + (physics.velocity * dt)

        entity:get("Position").x = position.x
        entity:get("Position").y = position.y
        physics.acceleration = vec(0, 0)
    end

end

function PhysicsSystem:requires()
    return {"Position", "Physics"}
end

return PhysicsSystem
