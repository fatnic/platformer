Position = Component.create("Position")

function Position:initialize(x, y)
    self.x = x or 0
    self.y = y or 0
end

function Position:unpack()
    return self.x, self.y
end
