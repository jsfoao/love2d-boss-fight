--[[
module = {
	x=emitterPositionX, y=emitterPositionY,
	[1] = {
		system=particleSystem1,
		kickStartSteps=steps1, kickStartDt=dt1, emitAtStart=count1,
		blendMode=blendMode1, shader=shader1,
		texturePreset=preset1, texturePath=path1,
		shaderPath=path1, shaderFilename=filename1,
		x=emitterOffsetX, y=emitterOffsetY
	},
	[2] = {
		system=particleSystem2,
		...
	},
	...
}
]]
local LG        = love.graphics
local particles = {x=0, y=0, id = nil}

local image1 = LG.newImage("game/assets/square.png")
image1:setFilter("linear", "linear")

local ps = LG.newParticleSystem(image1, 14)
ps:setColors(0.484375, 0.484375, 0.484375, 1, 0.25, 0.25, 0.25, 1)
ps:setDirection(-1.5707963705063)
ps:setEmissionArea("none", 0, 0, 0, false)
ps:setEmissionRate(0)
ps:setEmitterLifetime(1.026372551918)
ps:setInsertMode("top")
ps:setLinearAcceleration(0, 0, 0, 0)
ps:setLinearDamping(0, 0)
ps:setOffset(8, 8)
ps:setParticleLifetime(0.079045414924622, 0.31618165969849)
ps:setRadialAcceleration(0, 0)
ps:setRelativeRotation(false)
ps:setRotation(0, 0)
ps:setSizes(0.40000000596046)
ps:setSizeVariation(0)
ps:setSpeed(-176.56605529785, 176.56605529785)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(6.2831854820251)
ps:setTangentialAcceleration(0, 0)
particles.id = {system=ps, kickStartSteps=0, kickStartDt=0, emitAtStart=14, blendMode="alpha", shader=nil, texturePath="square.png", texturePreset="", shaderPath="", shaderFilename="", x=0, y=0}

return particles
