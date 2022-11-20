function init()
	Location = FindShape("Spawn")
	if GetTagValue(Location, "Spawn") == "Friendly" then
		type = "Friend"
	end
	if GetTagValue(Location, "Spawn") == "Enemy" then
		type = "Enemy"
	end
	RagdollType = GetTagValue(Location, "Type")
	Diffragdolls = tonumber(GetTagValue(Location, "DiffRag"))
	timetonextspawn = 8
	maxragdollsatspawn = 5
	range = 2
	timer = 0
	chancefor1 = 10
	chancefor2 = 80
	chancefor3 = 95
	chancefor4 = 100
end
function tick(dt)
	if IsShapeBroken(Location) then
		Absolute = true
		start = true
		body = GetShapeBody(Location)
		RemoveTag(body, "enemy")
		RemoveTag(body, "friend")
	end
	if not Absolute then
	draw()
	LT = GetShapeWorldTransform(Location)
	if not start then
		LT2 = LT
		LT2.pos[2] = LT2.pos[2] + 1
		body = GetShapeBody(Location)
		if type == "Enemy" then
			SetTag(body, "enemy")
		DrawShapeOutline(Location, 0, 0, 1, 1)
		else
			SetTag(body, "friend")
		DrawShapeOutline(Location, 1, 0, 0, 1)
		end
	end
	if start then
	timer = timer + dt
	--DebugPrint(timer)
	if timer > timetonextspawn then
		--RandSpawn = Vec(LT[1] + math.random(-range,range), LT[2], LT[3] + math.random(-range, range))
		timer = 0
		rndragdoll = math.random(1, Diffragdolls)
		--if rndragdoll > 0 and rndragdoll < 50 then
		--	rndragdoll = 1
		--end
		--if rndragdoll > 50 and rndragdoll < 65 then
		--	rndragdoll = 2
		--end
		--if rndragdoll > 65 and rndragdoll < 83 then
		--	rndragdoll = 3
		--end
		--if rndragdoll > 83 then
		--	rndragdoll = 4
		--end
		Spawn("MOD/main/Gore Ragdolls 2/Agro pack/"..RagdollType..type..rndragdoll..".xml", Transform(LT.pos))
		--DebugPrint(type.." Spawned")
	end
end
end
cycled = false
	if InputPressed("j") and not start and not cycled then
		start = true
		cycled = true
	end
	if InputPressed("j") and start and not cycled then
		start = false
		cycled = true
	end
end

function draw()
	if not start then
	 UiPush()
      UiAlign("center middle")
      UiTranslate(400, 200)
      UiFont("bold.ttf", 30)
      UiText("J = Start/Disable spawning")
      UiTranslate(0, 50)
      UiText("L = Delete dead")
      UiTranslate(0, 50)
      UiText("M = Delete everyone")
    UiPop()
end
end