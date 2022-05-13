
import 'bullet'
import 'vectorsprite'

Player = {}
Player.__index = Player

local bulletspeed = 16
local maxspeed = 12
local turnspeed = 8
local thrustspeed = 0.6
local maxLeftPos = 240
local maxRightPos = 0

function Player:new()
	local self = VectorSprite:new({4,0, -4,3, -2,0, -4,-3, 4,0})

	self.thrust = { VectorSprite:new({-4, 3, -6,0, -4,-3}),
					VectorSprite:new({-4, 3, -9,0, -4,-3}) }

	self.thrust[1]:addSprite()
	self.thrust[2]:addSprite()

	self.thrust[1]:setVisible(false)
	self.thrust[2]:setVisible(false)
	self.thrustframe = 1

	self.da = 0
	self.dx = 0
	self.dy = 0
	self.angle = 180
	self.thrustingLeft = 0
	self.thrustingRight = 0
	self.wraps = false
	
	function self:collide(s)
		print(s)
	end
	
	function self:turn(d)
		self.da = turnspeed * d
	end

	function self:hit(asteroid)
		print("hit!")
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
		self:updatePosition()

		if self.thrustingLeft == 1 
		then
			self.thrust[self.thrustframe]:setVisible(false)
			self.thrustframe = 3 - self.thrustframe

			local t = self.thrust[self.thrustframe]

			t:setVisible(true)
			t.angle = 90
			t:setScale(self.xscale, self.yscale)
			t:moveTo(self.x, self.y)
			t:updatePosition()

			local dy = self.dy + thrustspeed * math.sin(math.rad(90))
			local m = hypot(0, dy)
			
			if m > maxspeed then
				dy *= maxspeed / m
			end
			
			self:setVelocity(0, dy)
		end

		if self.thrustingRight == 1 
		then
			self.thrust[self.thrustframe]:setVisible(false)
			self.thrustframe = 3 - self.thrustframe

			local t = self.thrust[self.thrustframe]

			t:setVisible(true)
			t.angle = 270
			t:setScale(self.xscale, self.yscale)
			t:moveTo(self.x, self.y)
			t:updatePosition()

			local dy = self.dy + thrustspeed * math.sin(math.rad(270))
			local m = hypot(0, dy)
			
			if m > maxspeed then
				dy *= maxspeed / m
			end
			
			self:setVelocity(0, dy)
		end
	end
	
	function self:startThrustLeft()
		self.thrust[self.thrustframe]:setVisible(true)
		self.thrustingLeft = 1
	end

	function self:stopThrustLeft()
		self.thrust[self.thrustframe]:setVisible(false)
		self.thrustingLeft = 0
	end

	function self:startThrustRight()
		self.thrust[self.thrustframe]:setVisible(true)
		self.thrustingRight = 1
	end

	function self:stopThrustRight()
		self.thrust[self.thrustframe]:setVisible(false)
		self.thrustingRight = 0
	end

	return self
end
