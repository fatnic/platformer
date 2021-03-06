lovetoys = require 'ext.lovetoys.lovetoys'
lovetoys.initialize({debug=true, globals=true})

assets = require 'assets'

sti = require 'ext.sti'
bump = require 'ext.bump'
lume = require 'ext.lume'
colorise = require 'ext.colorise'
vec = require 'ext.hump.vector'
Timer = require 'ext.hump.timer'
Gamera = require 'ext.gamera'

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

function hex2rgb(hex)
    hex = hex:gsub("#","")
    if(string.len(hex) == 3) then
        return tonumber("0x"..hex:sub(1,1)) * 17, tonumber("0x"..hex:sub(2,2)) * 17, tonumber("0x"..hex:sub(3,3)) * 17
    elseif(string.len(hex) == 6) then
        return tonumber("0x"..hex:sub(1,2)), tonumber("0x"..hex:sub(3,4)), tonumber("0x"..hex:sub(5,6))
    end
end

function love.load()

    engine = Engine()
    world = bump.newWorld(16)

    lights = LightWorld({ ambient={20, 20, 20} })
    lights:setShadowBlur(2)

    engine:addSystem(SpriteDrawingSystem())
    engine:addSystem(PlatformerSystem(world))
    engine:addSystem(LightingSystem(lights))

    map = sti('assets/maps/grid.lua')
    mapw, maph = map.width * map.tilewidth, map.height * map.tileheight
    camera = Gamera.new(0, 0, mapw, maph)

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
        local _, red, green, blue = colorise.hex2rgba(lp.color)
        l:add(LightEmitter(red, green, blue, lt.width / 2, true))

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
    engine:addEntity(player)

    local px, py = player:get("Position"):unpack()
    local pw, ph = player:get("Sprite").width, player:get("Sprite").height
    -- plight = lights:newRectangle(px + pw/2, py + ph/2, pw, ph)
end

function love.update(dt)
    love.window.setTitle("Lights -- fps: " .. love.timer.getFPS())

    Timer.update(dt)
    Input:update()
    
    if Input:down    'right' then player:get("Platformer"):moveRight(dt) end
    if Input:down    'left'  then player:get("Platformer"):moveLeft(dt) end
    if Input:pressed 'jump'  then player:get("Platformer"):jump(dt) end

    -- light flicker
    -- Timer.every(0.4, function() player:get("LightEmitter").light:setRange(math.random(200, 250)) end)
    player:get("LightEmitter").light:setRange(math.random(200, 250)) 

    engine:update(dt)

    local px, py = player:get("Position"):unpack()
    local pw, ph = player:get("Sprite").width, player:get("Sprite").height
    
    -- plight:setPosition(px + pw/2, py + ph/2)
    camera:setPosition(px, py)
    
    local cx, cy = camera:getPosition()
    lights:setTranslation(-cx + love.graphics.getWidth()/2, -cy + love.graphics.getHeight()/2)
end

function love.draw()
    camera:draw(function(l,t,w,h) 
        
        lights:draw(function() 
            map:draw()
            engine:draw()
        end)
    
    end)    
end

