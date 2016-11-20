Platformer = Component.create("Platformer")

function Platformer:initialize(args)
    args = args or {}
    self.velocity = {x=0, y=0}
    self.jumping = false
    self.grounded = false

    self.acceleration = args.acceleration or 20
    self.speed = args.speed or 40
    self.jumpheight = args.jumpheight or 8
    self.friction = args.friction or 0.8
    self.airresistance = args.airresistance or 0.84
    self.gravity = args.gravity or 0.3
end

function Platformer:moveRight(dt)
    if self.velocity.x < self.speed then self.velocity.x = self.velocity.x + (self.acceleration * dt) end
end

function Platformer:moveLeft(dt)
    if self.velocity.x > -self.speed then self.velocity.x = self.velocity.x - (self.acceleration * dt) end
end

function Platformer:jump(dt)
    if not self.jumping and self.grounded then
        self.jumping =  true
        self.grounded = false
        self.velocity.y = -self.jumpheight
    end
end
