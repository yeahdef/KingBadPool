
import 'bullet'
import 'vectorsprite'

Player = {}
Player.__index = Player

local bulletspeed = 16
local maxspeed = 12
local thrustspeed = 0.6
local maxLeftPos = 240
local maxRightPos = 0

function Player:new()
	local self = VectorSprite:new({4,0, -4,3, -2,0, -4,-3, 4,0})

	self.da = 0
	self.dx = 0
	self.dy = 0
	self.angle = 180
	self.thrustingLeft = 0
	self.thrustingRight = 0
	self.wraps = false
	self.type = "player"
	self.health = 100

	function self:collide(s)
		print(s)
	end
	
	function self:hit(asteroid)
		print("hit!")
		self.health -= 10
	end

	function self.collision(other)
		if other.type == "asteroid" then
			self:hit(other)
		end
	end

	function self:shoot()
		local b = Bullet:new()
		b:moveTo(self.x-1, self.y-1)
		b:setVelocity(self.dx + bulletspeed * math.cos(math.rad(self.angle)), self.dy + bulletspeed * math.sin(math.rad(self.angle)))
		b:addSprite()
	end
	
	function self:update()
		self.angle = playdate.getCrankPosition() - 90
		self:updatePosition()

		if self.thrustingLeft == 1 
		then
			local dy = self.dy + thrustspeed * math.sin(math.rad(90))
			local m = hypot(0, dy)
			
			if m > maxspeed then
				dy *= maxspeed / m
			end
			
			self:setVelocity(0, dy)
		end

		if self.thrustingRight == 1 
		then
			local dy = self.dy + thrustspeed * math.sin(math.rad(270))
			local m = hypot(0, dy)
			
			if m > maxspeed then
				dy *= maxspeed / m
			end
			
			self:setVelocity(0, dy)
		end
	end
	
	function self:startThrustLeft()
		self.thrustingLeft = 1
	end

	function self:stopThrustLeft()
		self.thrustingLeft = 0
	end

	function self:startThrustRight()
		self.thrustingRight = 1
	end

	function self:stopThrustRight()
		self.thrustingRight = 0
	end

	return self
end
