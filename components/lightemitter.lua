LightEmitter = Component.create("LightEmitter")

function LightEmitter:initialize(r, g, b, radius, args)
    local args = args or {}
    self.r = r or 255
    self.g = g or 255
    self.b = b or 255
    self.radius = radius or 100
end
