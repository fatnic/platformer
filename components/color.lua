Color = Component.create("color")

function Color:initialize(r, g, b, a)
    self.r = r or 255
    self.g = g or 255
    self.b = b or 255
    self.a = a or 255
end
