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
local particles = {x=-210, y=56, id = nil}

local image1 = LG.newImage("game/assets/square.png")
image1:setFilter("linear", "linear")

local ps = LG.newParticleSystem(image1, 14)
ps:setColors(1, 0.4921875, 0, 1, 0.9921875, 0.53485107421875, 0, 1, 1, 1, 1, 0.5, 1, 1, 1, 0)
ps:setDirection(-1.5707963705063)
ps:setEmissionArea("none", 0, 0, 0, false)
ps:setEmissionRate(96.662742614746)
ps:setEmitterLifetime(0.051562707871199)
ps:setInsertMode("top")
ps:setLinearAcceleration(0, 0, 0, 0)
ps:setLinearDamping(0, 0)
ps:setOffset(8, 8)
ps:setParticleLifetime(0.27453583478928, 0.6277904510498)
ps:setRadialAcceleration(0, 0)
ps:setRelativeRotation(false)
ps:setRotation(0, 0)
ps:setSizes(0.40000000596046)
ps:setSizeVariation(0)
ps:setSpeed(542.39605712891, 1369.4332275391)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(0.11967971920967)
ps:setTangentialAcceleration(0, 0)
particles.id = {system=ps, kickStartSteps=0, kickStartDt=0, emitAtStart=8, blendMode="add", shader=nil, texturePath="square.png", texturePreset="", shaderPath="", shaderFilename="", x=0, y=0}

return particles
