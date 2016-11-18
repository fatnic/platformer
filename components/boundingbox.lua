BoundingBox = Component.create("BoundingBox")

function BoundingBox:initialize(r, g, b, a)
    self.color = {}    
    self.color.r = r or 0
    self.color.g = g or 255
    self.color.b = b or 0
    self.color.a = a or 255
end
