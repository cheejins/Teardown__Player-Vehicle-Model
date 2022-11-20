ak47projectileHandler = {
	shellNum = 1,
	shells = {},
	defaultShell = {active = false}
}

casing = {
	amount = 1,
	shells = {},
	defaultShell = {
		active = false,
		grenadeTimer = 0,
		boomTimer = 0,
		bounces = 0,
		pos = Vec(0,0,0),
		type = "casing",
		crot = 0
	}
}



function init()
	ShoulderJoints = FindJoints("shoulder")
	ArmJoints = FindJoints("hand1")
	Eyes = FindBody("Head")
	Torso = FindBody("Torso")
	RRARM = FindBody("LLARM")
	HipJoints = FindJoints("hip")
	KneeJoints = FindJoints("knee")
	walktim = 0
	speed = 0.07

	ShootTimer = 0
	shootTimer = 0
	shotDelay = 0.09
	damage = 0.15
	gravity = Vec(0, -40, 0)
	velocity = 300 --tonumber(GetTagValue(barrel, "bulletspeed"))
	maxMomentum = 6
	ShootTimMax = 0.5
	--GetTagValue(barrel,"gun")
	--shoot = LoadSound("MOD/snd/".."makarov"..".ogg")
	shoot = LoadSound("MOD/snd/"..GetTagValue(barrel, "gun")..".ogg")
	BulletsShot = 0
	oldbulletsshot = 0
	bulletsshot = 1
	reloading = false
	reloadtim = 0
	maxreloadtim = 3
	barrel = FindShape("barrel")
	MagSize = tonumber(GetTagValue(barrel, "magsize"))
	maxrange = tonumber(GetTagValue(barrel, "range"))/15
	damage = tonumber(GetTagValue(barrel, "damage"))
	firerate = tonumber(GetTagValue(barrel, "firerate"))
	Fucked = false
	Torso = FindBody("Torso")
	Head = FindBody("Head")
	canSeePlayer = false
	if GetTagValue(barrel, "team") == "friend" then
		SetTag(Torso, "friend")
		SetTag(Head, "friendhead")
		team = 1
	end
	if GetTagValue(barrel, "team") == "enemy"then
		SetTag(Torso, "enemy")
		SetTag(Head, "enemyhead")
		SetTag(Torso, "shooting_target")
		team = 2
	end
	for i=1, 150 do
		ak47projectileHandler.shells[i] = deepcopy(ak47projectileHandler.defaultShell)
	end
	if HasTag(barrel, "rpg") then
		rpg = true
		gravity = Vec(0, -2, 0)
		velocity = 70
	end
	if HasTag(barrel, "stationary") then
		nowalk = true
	end
	DrawTeam = true
end
function update(dt)
	if InputPressed("J") then
		canSeePlayer = true
	end
	if InputPressed("L") then
		optimizedead()
	end
	if InputPressed("M") then
		optimize()
	end
	if Fucked then
		RemoveTag(Torso, "friend")
		RemoveTag(Torso, "enemy")
		RemoveTag(Head, "friendhead")
		RemoveTag(Head, "enemyhead")
		RemoveTag(Torso, "shooting_target")
	end
	if InputPressed("H") then
		DrawTeam = false
	end
	if DrawTeam then
	if GetTagValue(barrel, "team") == "friend" and not Fucked then
		TT = GetBodyTransform(Torso)
		DrawLine(Vec(TT.pos[1], TT.pos[2] + 2.9, TT.pos[3]), Vec(TT.pos[1], TT.pos[2] + 3, TT.pos[3]), 1,0,0)
	end
	if GetTagValue(barrel, "team") == "enemy" and not Fucked then
		TT = GetBodyTransform(Torso)
		DrawLine(Vec(TT.pos[1], TT.pos[2] + 2.9, TT.pos[3]), Vec(TT.pos[1], TT.pos[2] + 3, TT.pos[3]), 0,0,1)
	end
	if Fucked then
		TT = GetBodyTransform(Torso)
		--DrawLine(Vec(TT.pos[1], TT.pos[2] + 2.9, TT.pos[3]), Vec(TT.pos[1], TT.pos[2] + 2, TT.pos[3]), 0.5,0.5,0.5)
	end
	end

	if HasTag(Torso, "dead") or HasTag(Torso, "panicked") then
		Fucked = true
	end
	-- LOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOLOOOLOLOLOLOLOL
	if team == 1 then
		enemies = FindBodies("enemy",true)
		enemieshead = FindBodies("enemyhead",true)
	end
	if team == 2 then
		enemies = FindBodies("friend",true)
		enemieshead = FindBodies("friendhead",true)
	end

	for k=1,#enemies do
		E = enemies[k]
		H = enemieshead[k]
		disttoenemy = VecLength(VecSub(GetBodyTransform(Torso).pos, GetBodyTransform(E).pos))
		if disttoenemy < 155 then
			enemyhead = GetBodyTransform(H)
			enemy = GetBodyTransform(E)
			for i=1,#enemies do
				Secondaryenemytrans = GetBodyTransform(enemies[i])
				disttosecondary = VecLength(VecSub(Secondaryenemytrans.pos, GetBodyTransform(Torso).pos))
				disttoenemy = VecLength(VecSub(GetBodyTransform(Torso).pos, enemy.pos))
				if disttosecondary < disttoenemy then
					enemy = Secondaryenemytrans
					--DebugCross(enemy)
				end
			end
		end
	end
	--DebugPrint(canSeePlayer())
	if #enemies > 0 then
	gunTrans = GetBodyTransform(Eyes)
	gunPos = gunTrans.pos
	direction = TransformToParentVec(gunTrans, Vec(0, -1, 0))
	shootPos = VecAdd(gunPos, VecScale(direction,0.2))
	disttoplayer = VecLength(VecSub(enemy.pos, gunTrans.pos))
	if reloading then
		reloadtim = reloadtim + dt
		if reloadtim > maxreloadtim then
			reloading = false
			reloadtim = 0
			BulletsShot = 0
		end
	end
	end

	ShootTimer = ShootTimer + dt
	if not Fucked and #enemies > 0 then
	faceplayer()
	end
	if canSeePlayer and ShootTimer > firerate and not reloading and not Fucked and #enemies > 0 then
		if not run then
		Shoot()
		BulletsShot = BulletsShot + 1
		bulletsshot = bulletsshot + 1
		if BulletsShot == MagSize then
			reloading = true
		end
		ShootTimer = 0
	end
	end

	if canSeePlayer and not Fucked and #enemies > 0 then
		agro = true
		aimweapon()
		runtoenemy()
		if disttoplayer > maxrange then
		run = true
	else
		run = false
		agro = false
	end
	end
end

function tick()
	for key, shell in ipairs(ak47projectileHandler.shells) do
		if shell.active then
			ProjectileOperations(shell)
		end
	end
    end

function canSeePlayer()
    local camTrans = GetPlayerCameraTransform()
	local playerPos = camTrans.pos

	--Direction to player
	local dir = VecSub(playerPos, shootPos)
	local dist = VecLength(dir)
	dir = VecNormalize(dir)

	QueryRejectVehicle(GetPlayerVehicle())
	rejectragdoll()
	bodypartz = FindBodies("bodypart",true)
	for i=1,#bodypartz do
		QueryRejectBody(bodypartz[i])	
	end
	return not QueryRaycast(shootPos, dir, dist, 0, true)
end

function rejectragdoll()
	bodyparts = FindBodies("bodyparts", true)
	for i=1,#bodyparts do
		QueryRejectBody(bodyparts[i])
	end
end

function aimweapon()
	if disttoplayer > 4 then
	SetJointMotor(ArmJoints[2], 0, 0)
	SetJointMotor(ShoulderJoints[1], 8)
	end
	if disttoplayer < 4 then
	SetJointMotor(ArmJoints[2], 8)
	SetJointMotor(ShoulderJoints[1], 0, 0)
	end
end

function runtoenemy()
--if InputDown("o") then\
if run and not nowalk then
walktim = walktim + speed
--else
	--SetJointMotor(HipJoints[1], 0, 0)
	--SetJointMotor(HipJoints[2], 0, 0)
--end

if walktim > 1 and walktim < 1.1 then
	SetJointMotor(HipJoints[1], speed*275)
	SetJointMotor(HipJoints[2], -speed*275)
end
if walktim > 2 then
	SetJointMotor(HipJoints[2], speed*275)
	SetJointMotor(HipJoints[1], -speed*275)
	walktim = 0
end
else
	SetJointMotor(HipJoints[1], 0, 0)
	SetJointMotor(HipJoints[2], 0, 0)
end
end

function stoprunning()
	end

function faceplayer()
		armvel = -0.9
		local bmi, bma = GetBodyBounds(RRARM)
      	local bc = VecLerp(bmi, bma, 0.5)
      	local ppos = VecSub(GetPlayerCameraTransform().pos, Vec(0,1,0))
      	local dir = VecSub(bc, ppos)
      	local dist = VecLength(dir)
      	dir = VecScale(dir, 1.0 / dist)
     	local add = VecScale(dir, armvel*8)
      	local vel = GetBodyVelocity(RRARM)
      	Vel = VecAdd(vel, add)
      	--SetBodyVelocity(RRARM, Vel)

      	local target = enemy.pos
		local approachspeed = 35
		local smoothspeed = 35

		local ttr = GetBodyTransform(Torso)
		local currentavel = GetBodyAngularVelocity(Torso)

		local targetrot = QuatLookAt(ttr.pos, target)
		local ltargetrot = TransformToLocalTransform(ttr, Transform(Vec(), targetrot))
		local targetavel = VecScale(Vec(GetQuatEuler(ltargetrot.rot)), approachspeed)
		local diff = VecSub(targetavel, currentavel)
		diff[1] = 0 --math.max(math.min(diff[1], smoothspeed), -smoothspeed)
		diff[2] = math.max(math.min(diff[2], smoothspeed), -smoothspeed)
		diff[3] = 0 --math.max(math.min(diff[3], smoothspeed), -smoothspeed)
		SetBodyAngularVelocity(Torso, VecAdd(currentavel, diff))
		TorsoVel = VecLength(GetBodyVelocity(Torso))

		local target = enemy.pos
		local approachspeed = 1
		local smoothspeed = 1

		local ttr = GetBodyTransform(RRARM)
		local currentavel = GetBodyAngularVelocity(RRARM)
		x,y,z = GetQuatEuler(ttr.rot)
		ttr.rot = QuatEuler(x,y+90,z)
		local targetrot = QuatLookAt(ttr.pos, target)
		local ltargetrot = TransformToLocalTransform(ttr, Transform(Vec(), targetrot))
		local targetavel = VecScale(Vec(GetQuatEuler(ltargetrot.rot)), approachspeed)
		local diff = VecSub(targetavel, currentavel)
		diff[1] = 0 --math.max(math.min(diff[1], smoothspeed), -smoothspeed)
		diff[2] = math.max(math.min(diff[2], smoothspeed), -smoothspeed)
		diff[3] = 0 --math.max(math.min(diff[3], smoothspeed), -smoothspeed)
		SetBodyAngularVelocity(RRARM, VecAdd(currentavel, diff))
end

function Shoot()

	local gt = GetShapeWorldTransform(barrel)
	local bb = enemy
	local fwdpos = enemy.pos
    local gunpos = TransformToParentPoint(gt, Vec(0, 0, 1))
	dir = VecNormalize(VecSub(fwdpos, gunpos))
	PlaySound(LoadSound("MOD/snd/"..GetTagValue(barrel, "gun")..".ogg"), gunpos, 1)

	local maxSpread = InputDown("ctrl") and 1.5 or 3
	if ironsight then maxSpread = maxSpread / 3 end
	local factor = 0.05 --GetTagValue(barrel, "accuracy")

	dir[1] = dir[1] + (math.random()-0.5)*factor
	dir[2] = dir[2] + (math.random()-0.5)*factor
	dir[3] = dir[3] + (math.random()-0.5)*factor

	ak47projectileHandler.shells[ak47projectileHandler.shellNum] = deepcopy(ak47projectileHandler.defaultShell)
	loadedShell = ak47projectileHandler.shells[ak47projectileHandler.shellNum] 
	loadedShell.active = true
	loadedShell.pos = gunpos
	loadedShell.momentum = maxMomentum
	loadedShell.predictedBulletVelocity = VecScale(dir, velocity)
	ak47projectileHandler.shellNum = (ak47projectileHandler.shellNum%#ak47projectileHandler.shells) + 1

	shootTimer = shotDelay

	--shootTimer = shotDelay
	--recoilTimer = shotDelay
	--lightTimer = shotDelay/2


	--if spentcasingsoption then
	--	SpentCasing()
	--end
end

function ProjectileOperations(projectile)
	projectile.predictedBulletVelocity = VecAdd(projectile.predictedBulletVelocity, (VecScale(gravity, GetTimeStep())))
	local point2 = VecAdd(projectile.pos, VecScale(projectile.predictedBulletVelocity, GetTimeStep()))
	local dir = VecNormalize(VecSub(point2, projectile.pos))
	local hit, dist, normal, shape = QueryRaycast(projectile.pos, dir, VecLength(VecSub(point2, projectile.pos)))
	

	local P = VecSub(VecAdd(GetPlayerTransform().pos, Vec(0, 1, 0)), projectile.pos)
	local T = VecSub(point2, projectile.pos)
	local N = VecScale(VecNormalize(T), VecDot(VecNormalize(T), P))
	local R = VecSub(P, N)

	if VecLength(R) < 0.7 and projectile.momentum ~= 0 then
		SetPlayerHealth(GetPlayerHealth()-damage)
		projectile.momentum = 0
	end

	if disttoplayer > 4 and bulletsshot > oldbulletsshot then
	PlaySound(LoadSound("MOD/snd/"..GetTagValue(barrel, "gun").."dist.ogg"), GetPlayerTransform().pos, disttoplayer/10)
	oldbulletsshot = bulletsshot
	end
	if rpg then
		SpawnParticle("smoke", projectile.pos, Vec(0,0,0), 10, 1)
		PointLight(projectile.pos, 0.8, 0.6, 0.1, 5)
	else
		if GetTagValue(barrel, "team") == "friend" then
		PointLight(projectile.pos, 1, 0, 0, 5)
		end
		if GetTagValue(barrel, "team") == "enemy" then
		PointLight(projectile.pos, 0, 0, 1, 5)
		end
	end

	if hit then
		hitPos = VecAdd(projectile.pos, VecScale(VecNormalize(VecSub(point2, projectile.pos)), dist))
		point2 = hitPos
		DrawLine(projectile.pos, point2)
		local mat, r, g, b, a = GetShapeMaterialAtPosition(shape, hitPos)

		if mat == "metal" or mat == "heavymetal" or mat == "hardmetal" then
			bounceangle = 20
		else
			bounceangle = 10
		end

		local hitangle = math.acos(VecDot(projectile.predictedBulletVelocity, normal)/VecLength(projectile.predictedBulletVelocity))*57.3-90
		if hitangle < bounceangle and math.random(0, 100)/100 > (hitangle/bounceangle)^2 then
			PlaySound(bouncesound, projectile.pos, 1, false)
			local dot = VecDot(normal, projectile.predictedBulletVelocity)
			projectile.predictedBulletVelocity = VecSub(projectile.predictedBulletVelocity, VecScale(normal, dot*(1+math.random(1,10)/10)))
		else
			ApplyBodyImpulse(GetShapeBody(shape), hitPos, VecScale(projectile.predictedBulletVelocity, velocity/200))

			if mat == "glass" and math.random() > 0.65 then
				MakeHole(hitPos, 0.75)
				projectile.momentum = projectile.momentum - 0.2
			elseif mat == "metal" or mat == "heavymetal" or mat == "hardmetal" then
				SpawnParticle("smoke", hitPos, Vec(0, 1.0+math.random(1,10)*0.1, 0), damage, 1)
				ParticleReset()
				ParticleType("plain")
				ParticleTile(6)
				ParticleSticky(0, 0)
				ParticleRadius(0.01, 0.01)
				ParticleAlpha(1, 0)
				ParticleEmissive(10, 10)
				ParticleColor(1, 0.75, 0.25, 1, 0.25, 0.25)
				ParticleGravity(-10, -10)
				for i = 1, math.random(10, 10*maxMomentum) do
					SpawnParticle(hitPos, Vec((math.random(-100,100)/100)*5,(math.random(-100,100)/100)*5, (math.random(-100,100)/100)*5), math.random(10,25)/20)
				end
				PointLight(hitPos, 1, 0.75, 0.25, 0.25)
				projectile.momentum = projectile.momentum - 1
			else
				ParticleReset()
				ParticleType("plain")
				ParticleTile(6)
				ParticleSticky(0, 0)
				ParticleRadius(0.05, 0.05)
				ParticleAlpha(a, 0)
				ParticleEmissive(0, 0)
				ParticleColor(r, g, b, r, g, b)
				ParticleGravity(-10, -10)
				for i = 1, math.random(10, 10*maxMomentum) do
					SpawnParticle(hitPos, Vec((math.random(-100,100)/100)*5,(math.random(-100,100)/100)*5, (math.random(-100,100)/100)*5), math.random(10,25)/20)
					if mat == "dirt" then
						ParticleTile(1)
						ParticleRadius(0.5, 0.1)
						SpawnParticle(hitPos, Vec((math.random(-100,100)/100),(math.random(-100,100)/100)*5, (math.random(-100,100)/100)), math.random(10,25)/20)
					end
				end
				projectile.momentum = projectile.momentum - 0.5
			end

			local factor = 1
			if not rpg then
			MakeHole(hitPos, damage*factor, damage*0.85*factor, damage*0.7*factor)
		else
			Explosion(hitPos, 1)
			projectile.active = false
			end
		end
	else
		point2 = VecAdd(projectile.pos, VecScale(projectile.predictedBulletVelocity, GetTimeStep()))
		DrawLine(projectile.pos, point2)
	end
	
	if projectile.momentum < 0.1 or projectile.pos[2] < 0 or VecLength(VecSub(point2, projectile.pos)) < 0.01 then
		projectile.active = false
	end

	projectile.pos = point2
end

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

function optimizedead()
	if Fucked then
	Bodies = FindBodies("")
	for i=1,#Bodies do
		Delete(Bodies[i])
	end
	shapes = FindShapes("")
	for i=1,#shapes do
		Delete(shapes[i])
	end
	Joints = FindJoints("")
	for i = 1,#Joints do
		Delete(Joints[i])
	end
end
end

function optimize()
	Bodies = FindBodies("")
	for i=1,#Bodies do
		Delete(Bodies[i])
	end
	shapes = FindShapes("")
	for i=1,#shapes do
		Delete(shapes[i])
	end
	Joints = FindJoints("")
	for i = 1,#Joints do
		Delete(Joints[i])
	end
end

function draw()
	if not canSeePlayer then
	 UiPush()
      UiAlign("center middle")
      UiTranslate(400, 200)
      UiFont("bold.ttf", 30)
      UiText("J = begin ragdoll agression")
      UiTranslate(0, 50)
      UiText("All ragdolls near a radio")
      UiTranslate(0, 50)
      UiText("will become agressive by themselves")
    UiPop()
end
end