local SpriteDrawingSystem = class("SpriteDrawingSystem", System)

function SpriteDrawingSystem:draw()

    for _, entity in pairs(self.targets) do
        local sprite = entity:get("Sprite")
        local position = entity:get("Position")

        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(sprite.image, position.x, position.y)

        if entity:has("BoundingBox") then
            local color = entity:get("BoundingBox").color
            love.graphics.setColor(color.r, color.g, color.b, color.a)
            love.graphics.rectangle("line", position.x, position.y, sprite.width, sprite.height)
        end
    end

end

function SpriteDrawingSystem:requires()
    return {"Sprite", "Position"}
end

return SpriteDrawingSystem
