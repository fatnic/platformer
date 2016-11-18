Sprite = Component.create("Sprite")

function Sprite:initialize(image)
    self.image = image
    self.width = image:getWidth()
    self.height = image:getHeight()
    self.origin = { x = self.width/2, y = self.height/2 }
end
