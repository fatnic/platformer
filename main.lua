lovetoys = require 'ext.lovetoys.lovetoys'
lovetoys.initialize({debug=true, globals=true})

sti = require 'ext.sti'
bump = require 'ext.bump'
vec = require 'ext.hump.vector'
Timer = require 'ext.hump.timer'

LightWorld = require 'ext.lightworld'

-- compontents
require 'components.sprite'
require 'components.position'
require 'components.color'
require 'components.boundingbox'
require 'components.physics'
require 'components.friction'
require 'components.gravity'
require 'components.platformer'
require 'components.lightemitter'
require 'components.particles'

-- systems
SpriteDrawingSystem = require 'systems.drawing.sprite'
PhysicsSystem       = require 'systems.physics'
PlatformerSystem    = require 'systems.platformer'
LightingSystem      = require 'systems.lighting'
ParticlesSystem      = require 'systems.particles'

-- assets
assets = {
    img_player   = love.graphics.newImage('assets/images/smallplayer.png'),
    img_particle = love.graphics.newImage('assets/images/particle.png'),
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

    lights = LightWorld({ ambient={20, 20, 20} })
    lights:setShadowBlur(4)

    engine:addSystem(SpriteDrawingSystem())
    engine:addSystem(PlatformerSystem(world))
    engine:addSystem(LightingSystem(lights))
    engine:addSystem(ParticlesSystem())

    map = sti('assets/maps/grid.lua')

    local collisions = map.layers['collision'].objects
    local lighting   = map.layers['lighting'].objects

    for _, c in pairs(collisions) do
        world:add({properties=c.properties}, c.x, c.y, c.width, c.height)
        lights:newRectangle(c.x + c.width/2 + 1, c.y + c.height/2 + 1, c.width - 2, c.height - 2)
    end

    for _, lt in pairs(lighting) do
        local lp = lt.properties
        
        local l = Entity()
        l:add(Position(lt.x + lt.width / 2, lt.y + lt.height / 2))
        l:add(LightEmitter(lp.r, lp.g, lp.b, lt.width / 2, true))

        engine:addEntity(l)

        if lp.direction then l:get("LightEmitter").light:setDirection(math.rad(lp.direction)) end
        if lp.angle then l:get("LightEmitter").light:setAngle(math.rad(lp.angle)) end
    end

    map.layers['collision'].visible = false
    map.layers['lighting'].visible = false
    
    -- player entity
    player = Entity()
    player:add(Sprite(assets.img_player))
    player:add(Position(100, 100))
    player:add(Platformer())
    player:add(LightEmitter(255, 127, 63, 300))
    -- player:add(ParticlesSystem(assets.img_particle))
    engine:addEntity(player)

    smoke = love.graphics.newParticleSystem(assets.img_particle, 62)
    smoke:setParticleLifetime(0.5, 1)
    smoke:setLinearAcceleration(-5, -10, 5, -40)
    smoke:setColors(50, 50, 50, 50, 100, 100, 100, 50, 150, 150, 150, 50)
    smoke:setEmitterLifetime(-1)
    smoke:setSizes(0.05, 0.1, 0.15, 0.2, 0.25)
    smoke:setSpread(math.rad(55))
    smoke:setTangentialAcceleration(3, 10)
end

function love.update(dt)
    love.window.setTitle("Lights -- fps: " .. love.timer.getFPS())

    Timer.update(dt)
    Input:update()
    
    if Input:down    'right' then player:get("Platformer"):moveRight(dt) end
    if Input:down    'left'  then player:get("Platformer"):moveLeft(dt) end
    if Input:pressed 'jump'  then player:get("Platformer"):jump(dt) end

    -- light flicker
    Timer.every(0.4, function() player:get("LightEmitter").light:setRange(math.random(200, 250)) end)

    engine:update(dt)

    smoke:moveTo(player:get("Position"):unpack())
    smoke:emit(62)
    smoke:update(dt)
end

function love.draw()
    LightingSystem:render(lights, map, engine)
    love.graphics.draw(smoke, 1)
end
