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
local particles = {x=-40, y=155, system = nil}

local image1 = LG.newImage("game/assets/square.png")
image1:setFilter("linear", "linear")

local ps = LG.newParticleSystem(image1, 204)
ps:setColors(1, 0, 0, 1, 1, 0, 0, 1, 0.171875, 0, 0, 1, 0.1328125, 0, 0, 1)
ps:setDirection(-1.5707963705063)
ps:setEmissionArea("none", 0, 0, 0, false)
ps:setEmissionRate(158.2266998291)
ps:setEmitterLifetime(-1)
ps:setInsertMode("top")
ps:setLinearAcceleration(26.998336791992, 0, 49.046127319336, 0)
ps:setLinearDamping(0, 0)
ps:setOffset(8, 8)
ps:setParticleLifetime(0, 1.0192612409592)
ps:setRadialAcceleration(0.10207310318947, 8.2679214477539)
ps:setRelativeRotation(false)
ps:setRotation(0, 0)
ps:setSizes(0.46416965126991)
ps:setSizeVariation(0)
ps:setSpeed(-97.194007873535, 133.94032287598)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(6.2831854820251)
ps:setTangentialAcceleration(0, 0)
particles.system = ps

return particles