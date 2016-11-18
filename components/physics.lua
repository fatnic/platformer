Physics = Component.create("Physics")

function Physics:initialize(maxspeed)
    self.velocity = vec(0, 0)
    self.acceleration = vec(0, 0)
    self.maxspeed = maxspeed or 1
end

function Physics:addForce(force)
    self.acceleration = self.acceleration + force
end
