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
local particles = {x=-114, y=87, id = nil }

local image1 = LG.newImage("game/assets/square.png")
image1:setFilter("linear", "linear")

local ps = LG.newParticleSystem(image1, 144)
ps:setColors(1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1)
ps:setDirection(-1.5707963705063)
ps:setEmissionArea("borderellipse", 51.115310668945, 51.115310668945, 0, true)
ps:setEmissionRate(102.43240356445)
ps:setEmitterLifetime(-1)
ps:setInsertMode("top")
ps:setLinearAcceleration(26.998336791992, 0, 49.046127319336, 0)
ps:setLinearDamping(0, 0)
ps:setOffset(8, 8)
ps:setParticleLifetime(0, 1.0192612409592)
ps:setRadialAcceleration(0.10207310318947, 0.10207310318947)
ps:setRelativeRotation(false)
ps:setRotation(0, 0)
ps:setSizes(0.47911778092384)
ps:setSizeVariation(0)
ps:setSpeed(-66.327102661133, 37.746635437012)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(6.2831854820251)
ps:setTangentialAcceleration(0, 0)
particles.id = {system=ps, kickStartSteps=0, kickStartDt=0, emitAtStart=34, blendMode="alpha", shader=nil, texturePath="square.png", texturePreset="", shaderPath="", shaderFilename="", x=0, y=0}

return particles
