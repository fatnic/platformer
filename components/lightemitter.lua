LightEmitter = Component.create("LightEmitter")

function LightEmitter:initialize(r, g, b, radius, static)
    self.r = r or 255
    self.g = g or 255
    self.b = b or 255
    self.radius = radius or 100
    self.static = static or false
end
