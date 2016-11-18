Gravity = Component.create("Gravity")

function Gravity:initialize(gravity)
    self.gravity = gravity or vec(0, 50)
end
