import "CoreLibs/timer"
import 'asteroid'
import 'player'

local gfx = playdate.graphics

function hypot(x,y)
	return math.sqrt(x*x+y*y)
end

local aspeed = 3
local acount = 5
local bulletTimer = playdate.timer.new(1000)
bulletTimer.repeats = true
bulletTimer.timerEndedCallback = function(timer)
	player:shoot()
end

function setup()
	for i = 1,6 do
		a = Asteroid:new()
		
		local x,y,dx,dy
		
		repeat
			x,y = math.random(400), math.random(240)
			dx,dy = aspeed * (2*math.random() - 1), aspeed * (2*math.random() - 1)
		until hypot(x+10*dx-200, y+10*dy-120) > 100
		
		a:moveTo(0,y)
		a:setVelocity(dx, nil, math.random(100) / 200.0 - 0.25)
		a:addSprite()
	end
end

player = Player:new()
player:moveTo(390, 120)
player:setScale(3)
player:setFillPattern({0xf0, 0xf0, 0xf0, 0xf0, 0x0f, 0x0f, 0x0f, 0x0f})
player:setStrokeColor(gfx.kColorWhite)
player.wraps = 1
player:addSprite()

setup()

gfx.setColor(gfx.kColorBlack)
gfx.fillRect(0, 0, 400, 240)
gfx.setBackgroundColor(gfx.kColorBlack)

gfx.setColor(gfx.kColorWhite)
gfx.setImageDrawMode(playdate.graphics.kDrawModeFillWhite)

function playdate.update()
	gfx.sprite.update()
	playdate.timer.updateTimers()
	gfx.drawText("score: " .. userScore, 200, 10)
	gfx.drawText("<3: " .. player.health, 300, 10)
end

function playdate.downButtonDown()	player:startThrustLeft()	end
function playdate.downButtonUp()	player:stopThrustLeft()		end
function playdate.upButtonDown()	player:startThrustRight()	end
function playdate.upButtonUp()		player:stopThrustRight()	end

function levelCleared() setup() end
