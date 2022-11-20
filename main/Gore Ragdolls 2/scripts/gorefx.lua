#include "script/common.lua"

function rnd(mi, ma) return math.random()*(ma-mi) + mi end
function rndVec(t) return Vec(rnd(-t, t), rnd(-t, t), rnd(-t, t)) end

breakables = {}
smokes = {}
flickers = {}

function init()
	local turnoff = FindShapes("fxturnoff", true)
	for i=1, #turnoff do
		SetShapeEmissiveScale(turnoff[i], 0.0)
	end

	local shapes = FindShapes("fxbreak", true)
	for i=1, #shapes do
		local v = GetTagValue(shapes[i], "fxbreak")
		local b = {}
		b.shape = shapes[i]
		b.broken = false
		b.voxelCount = GetShapeVoxelCount(b.shape)
		b.point = Vec()
		b.normal = Vec()
		b.age = 0
		b.radius = 0
		b.lifeTime = tonumber(string.sub(v, 2, 2))
		b.color = string.sub(v, 3, string.len(v))
		b.type = string.sub(v, 1, 1)
		if b.lifeTime and b.lifeTime > 0 then
			breakables[#breakables+1] = b		
		end
	end
	snd = {}
	snd["l"] = { LoadSound("liquid-s0.ogg"), LoadSound("liquid-m0.ogg"), LoadSound("liquid-m0.ogg")}
	snd["g"] = { LoadSound("gas-s0.ogg"), LoadSound("gas-m0.ogg"), LoadSound("gas-l0.ogg")}

	local locations = FindLocations("fxsmoke", true)
	for i=1, #locations do
		local l = locations[i]
		local v = GetTagValue(l, "fxsmoke")
		local s = {}
		local t = GetLocationTransform(l)
		local hit,point,normal,shape = QueryClosestPoint(t.pos, 0.5)
		if hit then
			s.shape = shape
			s.enabled = true
			local st = GetShapeWorldTransform(shape)
			s.point = TransformToLocalPoint(st, t.pos)
			s.normal = TransformToLocalVec(st, TransformToParentVec(t, Vec(0,0,-1)))
			s.spawn = 0
			s.color = string.sub(v, 3, string.len(v))
			s.type = string.sub(v, 1, 1)
			s.scale = tonumber(string.sub(v, 2, 2))
			s.timeOffset = rnd(0, 10)
			if not s.scale then
				s.scale = 1
			end
			smokes[#smokes+1] = s
		end
	end
	
	local lights = FindLights("fxflicker", true)
	for i=1, #lights do
		local l = lights[i]
		local shape = GetLightShape(l)
		if IsLightActive(l) then
			local v = GetTagValue(l, "fxflicker")
			local f = {}
			f.enabled = true
			f.light = l
			f.shape = shape
			f.timer = 0
			f.scale = 1
			f.period = tonumber(string.sub(v, 1, 1))
			if not f.period then
				f.period = 1
			end
			flickers[#flickers+1] = f
		end
	end
end


function cancelAllBreakables()
	for i=1, #breakables do
		local b = breakables[i]
		if b.broken then
			b.age = b.lifeTime
		end
	end
end


function disableJointed(shape)
	local body = GetShapeBody(shape)
	if IsBodyDynamic(body) then
		local bodies = GetJointedBodies(body)
		for i=1, #bodies do
			local shapes = GetBodyShapes(bodies[i])
			for j=1, #shapes do
				if IsShapeBroken(shapes[j]) then
				RemoveTag(shapes[j], "fxbreak")
				end
			end
		end
	end
end


function tick(dt)
	local hasBreakage = GetBool("game.break")
	local breakPoint = Vec(GetFloat("game.break.x"), GetFloat("game.break.y"), GetFloat("game.break.z"))
	for i=1, #breakables do
		local b = breakables[i]
		if not b.broken then
			if IsShapeBroken(b.shape) then
				b.age = b.lifeTime
				b.broken = true
				if HasTag(b.shape, "fxbreak") and hasBreakage then
					disableJointed(b.shape)
					cancelAllBreakables()
					local t = GetShapeWorldTransform(b.shape)
					local h,cp,cn = GetShapeClosestPoint(b.shape, breakPoint)
					if h and VecLength(VecSub(cp, breakPoint)) < 1.0 then
						local mi, ma = GetShapeBounds(b.shape)
						if b.type == "l" then
							local center = VecLerp(mi, ma, 0.5)
							center[2] = math.max(breakPoint[2], center[2])
							b.normal = TransformToLocalVec(t, VecNormalize(VecSub(breakPoint, center)))
						else
							b.normal = TransformToLocalVec(t, VecNormalize(VecSub(breakPoint, cp)))
						end
						b.point = TransformToLocalPoint(t, VecAdd(cp, VecScale(cn, 0.2)))
						b.radius = clamp(VecLength(VecSub(breakPoint, cp))*0.8-0.1, 0.1, 0.25)
						b.age = 0
						if snd[b.type] then
							if b.lifeTime < 1.5 then
								PlaySound(snd[b.type][1], breakPoint)
							elseif b.lifeTime < 2.5 then
								PlaySound(snd[b.type][2], breakPoint)
							else
								PlaySound(snd[b.type][3], breakPoint)
							end
						end
					end
				end
			end
		end
	end
	
	for i=1, #smokes do
		local s = smokes[i]
		if s.enabled then
			if IsShapeBroken(s.shape) then
				s.enabled = false
			end
		end
	end
	
	for i=1, #flickers do
		local f = flickers[i]
		if f.enabled then
			if IsShapeBroken(f.shape) then
				f.enabled = false
			else
				f.timer = f.timer - dt
				if f.timer < 0 then
					if f.scale == 1 then
						f.scale = rnd(0.2, 0.5)
						SetShapeEmissiveScale(f.shape, f.scale)
						f.timer = rnd(0.0, f.period*0.3)
					else
						f.scale = 1
						SetShapeEmissiveScale(f.shape, f.scale)
						f.timer = rnd(0.0, f.period)
					end
				end
			end
		end
	end
end


function update(dt)
	for i=1, #breakables do
		local b = breakables[i]
		if b.broken and b.age < b.lifeTime then
			b.age = math.min(b.age + dt, b.lifeTime)
			effect(b)
		end
	end

	for i=1, #smokes do
		local s = smokes[i]
		if s.enabled then
			emitSmoke(s)
		end
	end
end


function effect(b)
	local q = 1.0 - b.age/b.lifeTime
	local shape = b.shape
	local t = GetShapeWorldTransform(shape)
	local p = TransformToParentPoint(t, b.point)
	local n = TransformToParentVec(t, b.normal)
	local body = GetShapeBody(shape)
	local bv = GetBodyVelocityAtPos(p)
	
	--Sanity check, shape might have shifted
	local h,cp = GetShapeClosestPoint(shape, p)
	if VecLength(VecSub(cp, p)) > 0.3 then
		b.age = b.lifeTime
		return
	end
	
	ParticleReset()
	if b.type == "l" then
		ParticleRadius(0.02+q*0.05, 0.01, "linear", 0.02, 0.1)
		ParticleStretch(2)
		ParticleSticky(0.02)
		local w = rnd(0.9, 1.1)
		if b.color == "yellow" then
			ParticleColor(0.6*w, 0.55*w, 0.35*w)
		elseif b.color == "black" then
			ParticleColor(0.1*w, 0.1*w, 0.1*w)
		elseif b.color == "blue" then
			ParticleColor(0.25*w, 0.3*w, 0.4*w)
		elseif b.color == "green" then
			ParticleColor(0.15*w, 0.19*w, 0.16*w)
		elseif b.color == "brown" then
			ParticleColor(0.25*w, 0.2*w, 0.1*w)
		elseif b.color == "red" then
			ParticleColor(0.1*w, 0.0*w, 0.0*w)
		else
			ParticleColor(0.67*w, 0.65*w, 0.63*w)
		end
		ParticleType("plain")
		ParticleOrientation("normalup flat")
		ParticleGravity(-8)
		ParticleSticky(0.4)
		for i=1, 1+64*q do
			local pos = VecAdd(p, rndVec(b.radius))
			local dir = VecNormalize(VecAdd(n, rndVec(0.5*q)))
			local vel = VecScale(dir, 3*q)
			SpawnParticle(pos, vel, rnd(1,2))
		end	
	elseif b.type == "g" then
		local pc = 4
		if b.lifeTime < 2 then
			ParticleRadius(0.1, 0.1+0.2*q)
			pc = 8
		else
			ParticleRadius(0.1, 0.1+0.3*q)
		end
		if b.color == "yellow" then
			ParticleColor(0.9, 0.9, 0.6, 1, 1, 1)
		elseif b.color == "blue" then
			ParticleColor(0.7, 0.8, 0.9, 1, 1, 1)
		elseif b.color == "green" then
			ParticleColor(0.7, 0.8, 0.7, 1, 1, 1)
		else
			ParticleColor(0.85, 0.8, 0.75, 1, 1, 1)
		end
		ParticleType("smoke")
		ParticleGravity(2)
		ParticleSticky(0.4)
		ParticleDrag(2.0)
		for i=1, 1+pc*q do
			local pos = VecAdd(p, rndVec(b.radius))
			local dir = VecNormalize(VecAdd(n, rndVec(0.05*q)))
			local vel = VecScale(dir, 8*q)
			SpawnParticle(pos, vel, rnd(2,3))
		end
	end
end


function emitSmoke(s)
	local t = GetShapeWorldTransform(s.shape)
	local p = TransformToParentPoint(t, s.point)
	local n = TransformToParentVec(t, s.normal)
	local scale = 1.0
	if s.type == "p" then
		scale = 1.0 + math.sin(s.timeOffset + GetTime()*3.0)*0.9
	end
	ParticleReset()
	ParticleType("smoke")
	ParticleRadius(0.25, 0.6, "linear")
	ParticleAlpha(0.4, 0.0)
	ParticleSticky(0.4)
	ParticleDrag(0.2*(s.scale-1))
	if s.color == "brown" then
		ParticleColor(0.35, 0.3, 0.25, 0.8, 0.8, 0.8)
	elseif s.color == "subtle" then
		ParticleColor(0.8, 0.8, 0.8)
		ParticleAlpha(0.2, 0.0)
	else
		ParticleColor(0.8, 0.8, 0.8)
	end
	local vel = VecScale(n, s.scale*scale)
	local dist = VecLength(VecSub(GetCameraTransform().pos, p))
	if dist < 30 then
		local distScale = 1.0 - dist/30
		s.spawn = s.spawn + scale * distScale
	end
	while s.spawn > 1 do
		local offset = rndVec(0.4)
		offset = VecSub(offset, VecScale(n, VecDot(n, offset)))
		SpawnParticle(VecAdd(p, offset), VecAdd(vel, rndVec(s.scale*scale*0.5)), rnd(2.0, 3.0))
		s.spawn = s.spawn - 1
	end
end

