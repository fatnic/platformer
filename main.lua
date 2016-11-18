lovetoys = require 'ext.lovetoys.lovetoys'
lovetoys.initialize({debug=true, globals=true})

sti = require 'ext.sti'
bump = require 'ext.bump'
vec = require 'ext.hump.vector'

-- compontents
require 'components.sprite'
require 'components.position'
require 'components.boundingbox'
require 'components.physics'
require 'components.friction'
require 'components.gravity'
require 'components.platformer'

-- systems
SpriteDrawingSystem = require 'systems.drawing.sprite'
PhysicsSystem       = require 'systems.physics'
PlatformerSystem    = require 'systems.platformer'

-- assets
assets = {
    img_player = love.graphics.newImage('assets/images/player.png'),
}

-- input
baton = require 'ext.baton'
Input = baton.new({
    left  = {'key:a', 'key:left'},
    right = {'key:d', 'key:right'},
    jump  = {'key:w', 'key:up'},

    ff = {'key:p'},
    rw = {'key:o'},
})

Window = {}

function love.load()

    engine = Engine()
    world = bump.newWorld(16)

    engine:addSystem(SpriteDrawingSystem())
    engine:addSystem(PlatformerSystem(world))

    map = sti('assets/maps/grid.lua', {'bump'})
    map:bump_init(world)
    
    -- player entity
    player = Entity()
    player:add(Sprite(assets.img_player))
    player:add(Position(100, 100))
    player:add(Platformer())
    engine:addEntity(player)

    world:add({}, -5, 0, 5, love.graphics.getHeight())
    world:add({}, love.graphics.getWidth(), 0, 5, love.graphics.getHeight())

    love.graphics.setBackgroundColor(255, 255, 255)

end

function love.update(dt)
    Input:update()
    
    if Input:down    'right' then player:get("Platformer"):moveRight(dt) end
    if Input:down    'left'  then player:get("Platformer"):moveLeft(dt) end
    if Input:pressed 'jump'  then player:get("Platformer"):jump(dt) end

    engine:update(dt)
end

function love.draw()
    map:draw()
    engine:draw()
end
