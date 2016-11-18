local PlatformerSystem = class("PlatformerSystem", System)

function PlatformerSystem:initialize(world)
    System.initialize(self)
    self.world = world
end

function PlatformerSystem:onAddEntity(entity)
    local sprite = entity:get("Sprite")
    local position = entity:get("Position")
    self.world:add(entity, position.x, position.y, sprite.width, sprite.height)
end

function PlatformerSystem:update(dt)

    for i, e in pairs(self.targets) do
        local sprite = e:get("Sprite")
        local platformer = e:get("Platformer")
        local position = e:get("Position")
        
        goal = {x=0, y=0}
        actual = {x=0, y=0}

        if platformer.grounded then 
            platformer.velocity.x = platformer.velocity.x * platformer.friction 
        else
            platformer.velocity.x = platformer.velocity.x * platformer.airresistance
        end

        platformer.velocity.y = platformer.velocity.y + platformer.gravity

        goal.x = position.x + platformer.velocity.x
        goal.y = position.y + platformer.velocity.y

        if goal.x ~= position.x or goal.y ~= position.y then 

            actual.x, actual.y, cols, len = self.world:check(e, goal.x, goal.y)

            for _, c in pairs(cols) do

                if c.normal.y == -1 then -- top of platform 
                    platformer.jumping = false 
                    platformer.grounded = true
                    platformer.velocity.y = 0 
                elseif c.normal.y == 1 then -- bottom of platform 
                    platformer.velocity.y = 0 
                end

            end

            position.x, position.y = actual.x, actual.y

            self.world:update(e, position.x, position.y)
        end

    end

end

function PlatformerSystem:requires()
    return {"Sprite", "Position", "Platformer"}
end

return PlatformerSystem
