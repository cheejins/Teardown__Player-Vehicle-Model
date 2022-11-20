#include "UiHealthOverlay.lua"

function init()	
	MyHealthUiIsActive = false
	RagdollBody = {}

	sbloodval = {};
	bloodval = {};
	currentbloodvalue = {};
	Puddles = {};
	
	Torso = FindBody("Torso")
	
	bodyparts = FindBodies("bodypart")
	starttotalbloodvalue = 0
	for i=1,#bodyparts do		
			bodypart = bodyparts[i]
			bodypartshapes = GetBodyShapes(bodypart)
			--DebugPrint(#bodypartshapes)
			for h=1,#bodypartshapes do
			SetTag(bodypartshapes[h], "fxbreak","l3red")
			--DebugPrint("Set")
			end

		RagdollBody[bodypart] = 1
		bodypartstartmass = GetBodyMass(bodypart)
		table.insert(sbloodval, bodypartstartmass)
		table.insert(bloodval, bodypartstartmass)
		table.insert(currentbloodvalue, bodypartstartmass)
		--table.insert(puddles, {pos={x,y,z}, amount=3.0})
		starttotalbloodvalue = starttotalbloodvalue + GetBodyMass(bodypart)
	end
	bleed = 0
	puddleregtim = 0
	repuddle = 0.5
	mergepuddledistance = 1
	puddleneutspeed = 0.2
	GrowSpeed = 0.003
	Puddlemaxsize = 1
	upspeed = 50
	headvel = Vec(0,GetBodyMass(FindBody("RRLEG"))/upspeed,0)
	--DebugPrint("HeadMass: "..headvel)
	legvel = Vec(0,-GetBodyMass(FindBody("LLLEG"))/20,0)
	recoverfromtrip = 3
	triptim = 0
	tripped = false
	restartjoints = false
	trippingspeed = 10
	jointstrength = 10	
	sretractjoint = 12
	retractjoint = sretractjoint
	retractjoint1 = sretractjoint
	retractjoint2 = sretractjoint
	retractjoint3 = sretractjoint
	retractjoint4 = sretractjoint
	retractjoint5 = sretractjoint
	panictim = 0
	actualpanictim = 0
	criticalcough = LoadLoop("MOD/main/Gore Ragdolls 2/snd/criticalcondition.ogg")
	goresplat = LoadSound("MOD/main/Gore Ragdolls 2/snd/goresplat.ogg")
	headsplat = LoadSound("MOD/main/Gore Ragdolls 2/snd/headsplat.ogg")
	drowntim = 0
	inpostim = 0
	deadtim = 0
	
	SetHeadHealth(RED)
	AddHeadHealthEffect("argh",RED)
	UI = FindLocations("UIISADDED", true)
	--if UI == nil then
		Spawn("MOD/prefab/UISPAWN.xml", Vec(0,0,0))
		Spawn("MOD/prefab/GoreFX.xml", Vec(0,0,0))
	--end
	manualdietim = 0
	gorelevel = GetInt("savegame.mod.gore")
	bleedbool = GetBool("savegame.mod.bleed")
	if gorelevel == 4 then
		multiplier = 2
	else
		multiplier = 1
	end
	--DebugPrint(gorelevel)
	keytokill = GetString("savegame.mod.gore_kill")
end

function tick()
	CheckHealthUi()
end

function draw(dt)
	DrawUiHealthOverlay(dt)
	if warn then
	UiPush()
      UiAlign("center middle")
      --UiTranslate(400, 200)
      UiFont("bold.ttf", 30)
      UiColor(1,0,0)
      UiText("PRESS"..keytokill.." AGAIN TO KILL ALL RAGDOLLS: "..10 - manualdietim)
     UiPop()
 end
end

function update(dt)
	if manualdietim < 10 then
		if InputPressed(keytokill) and warn then
		entirelystop = true
		warn = false
		manualdietim = 0
		end
	else
		warn = false
		manualdietim = 0
	end
	if InputPressed(keytokill) and not warn and not entirelystop then
		warn = true
	end
	if warn then
		manualdietim = manualdietim + dt
	end
if not entirelystop then
	if not tripped and not sitting then
		knees = FindJoints("knee")
		for i=1,#knees do
			panick()
			--if not IsJointBroken(hips[i]) then
				SetJointMotor(knees[i], -retractjoint3/4,jointstrength)
			--end
		end
	end

	jaw = FindShape("jaw")
	if not dead then
		jaw = FindShape("jaw")
		evtelse = FindShapes("")
		SetShapeCollisionFilter(jaw, 2, 255-2)
		torsos = GetBodyShapes(FindBody("Torso"))
		for i=1,#torsos do
		SetShapeCollisionFilter(torsos[i], 2, 255-2)
		end
		jawjoints = GetShapeJoints(jaw)
		for i=1,#jawjoints do
			SetJointMotor(jawjoints[i], 0.5)
		end
	else
		jawjoints = GetShapeJoints(jaw)
		for i=1,#jawjoints do
			SetJointMotor(jawjoints[i], 0, 0)
		end
	end
	if panic then
		SetTag(Torso, "panicked")
		panictim = panictim + dt
		actualpanictim = actualpanictim + dt
	end
	bodyparts = FindBodies("bodypart")
	totalbloodvalue = 0
	if tripped then
		cower()
		triptim = triptim + dt
		if triptim > recoverfromtrip and VecLength(GetBodyVelocity(FindBody("Torso"))) < trippingspeed then
			tripped = false
			triptim = 0
		end
	end
	for i=1,#bodyparts do
		bodypart = bodyparts[i]
		SetTag(bodypart, "nocull")
		bodypartcurrentmass = GetBodyMass(bodypart)
		bloodval[i] = bodypartcurrentmass
		bodyparttransform = GetBodyTransform(bodypart)
		--DebugPrint(bloodval[i])
		bleedintensity = ((bloodval[i]/sbloodval[i]) - 1) * -10
		--DebugPrint(currentbloodvalue[i])
		currentbloodvalue[i] = currentbloodvalue[i] - bleedintensity/75
		totalbloodvalue = totalbloodvalue + currentbloodvalue[i]
		if HasTag(bodypart, "Torso") then
			torsovelocity = VecLength(GetBodyVelocity(bodypart))
			if torsovelocity > trippingspeed then
				tripped = true
			end
		end

		if sitting then
			sit()
		end

		if HasTag(bodypart,"Torso") then
			if HasTag(bodypart, "sit") then
				sitting = true
			end
				bodypartpos = GetBodyTransform(bodypart)
				disttobodypart = VecLength(VecSub(GetAimPossit(), bodypartpos.pos))
				cycled = true
				if InputPressed("P") and cycled and not sitting then
				if disttobodypart < 3 then
					sitting = true
					cycled = false
				end
				end

				if InputPressed("P") and cycled and sitting then
				if disttobodypart < 3 then
					sitting = false
					cycled = false
					restartjointsfunc()
					inposition = false
				end
				end
		end

		if HasTag(bodypart, "Head") then
			if IsPointInWater(bodyparttransform.pos) then
				tripped = true
				drowntim = drowntim + dt
			end
		end

		if drowntim > 5 then
			dead = true
		end

		if not tripped and HasTag(bodypart, "Head") and not dead and not sitting then
				--Paint(GetAimPos(), (bleedintensity/sbloodval[i])*1.3, "explosion")
				currentvel = GetBodyVelocity(bodypart)
				SetBodyVelocity(bodypart, VecAdd(currentvel, headvel))
				--DebugPrint(VecAdd(currentvel, headvel)[2])
				if IsBodyBroken(bodypart) then
					bodyState.head = BROKEN_BODY_PART	
					bodyState.overall = "dead"					
					dead = true
					if bloodval[i] < sbloodval[i] - sbloodval[i] / 4 then
					bods = GetBodyShapes(bodypart)
					for i = 1,#bods do
						j = GetShapeJoints(bods[i])
						for z = 1,#j do
							Delete(j[i])
						end
					end
				end
				end
		end

		if not tripped and HasTag(bodypart, "RRLEG") or HasTag(bodypart, "LLLEG") then
			if not dead and not sitting and not tripped then
				--Paint(GetAimPos(), (bleedintensity/sbloodval[i])*1.3, "explosion")
				currentvel = GetBodyVelocity(bodypart)
				SetBodyVelocity(bodypart, VecAdd(currentvel, legvel))
			end
		end

		if IsBodyBroken(bodypart) then

			if HasTag(bodypart, "Head") then
				dead = true
			end

			if bloodval[i] < sbloodval[i] - sbloodval[i]/10 then
				panic = true
				tripped = true
			end
		end

		if IsBodyBroken(bodypart) and currentbloodvalue[i] > 0 then
			if bodyState.overall == "healthy" then bodyState.overall = "injured" end
			
			if HasTag(bodypart, "LLLEG") or HasTag(bodypart, "LLEG") then
				bodyState.leftLeg = BROKEN_BODY_PART			
				if not diddit1 and bloodval[i] < sbloodval[i] - sbloodval[i]/3 then
					Spawn("MOD/main/Gore Ragdolls 2/internals/boner.xml", bodyparttransform)
					diddit1 = true
				end
			elseif HasTag(bodypart, "RRLEG") or HasTag(bodypart, "RLEG") then
				bodyState.rightLeg = BROKEN_BODY_PART					
				if not diddit2 and bloodval[i] < sbloodval[i] - sbloodval[i]/3 then
					Spawn("MOD/main/Gore Ragdolls 2/internals/boner.xml", bodyparttransform)
					diddit2 = true
				end
			elseif HasTag(bodypart, "RRARM") or HasTag(bodypart, "RARM") then
				bodyState.rightArm = BROKEN_BODY_PART	
				if not diddit3 and bloodval[i] < sbloodval[i] - sbloodval[i]/3 then
					Spawn("MOD/main/Gore Ragdolls 2/internals/boner.xml", bodyparttransform)
					diddit3 = true
				end				
			elseif HasTag(bodypart, "LLARM") or HasTag(bodypart, "LARM") then
				bodyState.leftArm = BROKEN_BODY_PART	
				if not diddit4 and bloodval[i] < sbloodval[i] - sbloodval[i]/3 then
					Spawn("MOD/main/Gore Ragdolls 2/internals/boner.xml", bodyparttransform)
					diddit4 = true
				end							
			end
		
		
			--Paint(GetAimPos(), bleedintensity/sbloodval[i], "explosion")

			puddleregtim = puddleregtim + dt

			PuddleHandleing()
			if puddleregtim > repuddle then
			--for i=1,bleedintensity/10 do
			--DebugPrint(bleedintensity)
			InsertPuddleToTable()
			bleedparticles()
			if bleedbool then
			--Paint(GetAimPos(), bleedintensity/sbloodval[i], "explosion")
			end
			--end
			puddleregtim = 0
			end
			bleedparticles()

			if bloodval[i] < 0.5 then ---------------------------------------------------------------
			bleedintensity = 1000
				for i=1,12 do
					InsertPuddleToTable()
				end
				currentbloodvalue[i] = 0
			end

			if HasTag(bodypart, "Torso") and bloodval[i] < sbloodval[i]/1.2 then			
				--DebugPrint("SUPPOSED TO BE LOL GUTTED XD")
				if not entrailed then
					bodyState.body = BROKEN_BODY_PART
					bodyState.overall = "dead"
					dead = true
					entrailed = true
					for i=1,4 do
						InsertPuddleToTable()
					end

					PlaySound(goresplat, GetBodyTransform(Torso).pos, 1)

					if gorelevel ~= 1 then
					Spawn("MOD/main/Gore Ragdolls 2/internals/entrails.xml", bodyparttransform)
					Spawn("MOD/main/Gore Ragdolls 2/internals/Heart.xml", bodyparttransform)
					Spawn("MOD/main/Gore Ragdolls 2/internals/Spine.xml", bodyparttransform)
					if gorelevel ~= 2 then
					for i=1,2 do
					Spawn("MOD/main/Gore Ragdolls 2/internals/Lung.xml", bodyparttransform)
					end
					for i=1,30 * multiplier do
						Spawn("MOD/main/Gore Ragdolls 2/internals/BrainMatter.xml", bodyparttransform)
					end
					end
					end
					--DebugPrint("LOL GUTTED XD")
				end
			end

			if HasTag(bodypart, "Head") then
				bodyState.head = BROKEN_BODY_PART	
				bodyState.overall = "dead"	
				eyej = FindJoints("eye")
				if bloodval[i] < sbloodval[i] - sbloodval[i]/4 then
				for i=1,#eyej do
					Delete(eyej[i])
				end
				end
				if bloodval[i] < sbloodval[i] - sbloodval[i]/3 then
				if not fragged then
					fragged = true
					PlaySound(headsplat, GetBodyTransform(Torso).pos, 1)
					if gorelevel ~= 1 then
					for i=1,4 do
						InsertPuddleToTable()
					end
					Spawn("MOD/main/Gore Ragdolls 2/internals/Skull_Jaw.xml.xml", bodyparttransform)
					for i=1,2 * multiplier do
					Spawn("MOD/main/Gore Ragdolls 2/internals/Skull_Eye_Socket.xml", bodyparttransform)
					Spawn("MOD/main/Gore Ragdolls 2/internals/Skull_Fragment.xml", bodyparttransform)
					end
					if gorelevel ~= 2 then
					for i=1,10 * multiplier do
						Spawn("MOD/main/Gore Ragdolls 2/internals/BrainMatter.xml", bodyparttransform)
					end
				end
					end
					--DebugPrint("LOL GUTTED XD")
				end
				end
			end
		end
	end
	if IsJointBroken(FindJoint("neck")) or totalbloodvalue < starttotalbloodvalue - starttotalbloodvalue/1.5 then
		bodyState.head = BROKEN_NECK						
		bodyState.overall = "dead"	
		dead = true
	end
	

	if restartjoints and not tripped then
		restartjointsfunc()
	end

	if dead then
		SetTag(Torso, "dead")
		restartjointsfunc()
		deadtim = deadtim + dt
		if deadtim > 10 then
			entirelystop = true
		end
	end
end

end

function GetAimPos()
     ct = bodyparttransform
    ctrot1, ctrot2, ctrot3 = GetQuatEuler(ct.rot)
    q = QuatEuler(-90, 0, 0)
    ct.rot = q
    local forwardPos = TransformToParentPoint(ct, Vec(0, 0, -150))
    local direction = VecSub(forwardPos, ct.pos)
    local distance = VecLength(direction)
    local direction = VecNormalize(direction)
    QueryRejectBody(bodypart)
    bodypartsB = FindBodies("")
	for i=1,#bodypartsB do
		bodypartB = bodyparts[i]
		QueryRejectBody(bodypartB)
	end 
	shapes = FindShapes("")
	for i=1,#shapes do
		bodypartS = shapes[i]
		QueryRejectShape(bodypartS)
	end 
    local hit, hitDistance = QueryRaycast(ct.pos, direction, distance)
    if hit then
        forwardPos = TransformToParentPoint(ct, Vec(0, 0, -hitDistance))
        distance = hitDistance
    end
    return forwardPos, hit, distance
end

function bleedparticles()
    --spawn sparks
    ParticleType("smoke")
    ParticleColor(0.3, 0.2, 0.2)
    ParticleRadius(0.05, 0.005)
    ParticleAlpha(1000)
    ParticleCollide(1)
    ParticleGravity(-14)
    ParticleSticky(0.5)
    ParticleDrag(0)
    ParticleStretch(1)
    for i=1,bleedintensity/5 do
    SpawnParticle(bodyparttransform.pos, Vec(math.random(-100,100)/100,math.random(0,bleedintensity*100)/40,math.random(-100,100)/100),10)
end
end

function PuddleHandleing()
	if bleedbool then
    --DebugCross(GetAimPos())    
    for i=1,#Puddles do
        --DebugPrint(Puddles[i].size)
        if Puddles[i] ~= nil then
        if Puddles[i].amount > 0 and Puddles[i].size < Puddlemaxsize then
            --Paint(Puddles[i].pos, Puddles[i].size, "explosion")
             Puddles[i].amount = Puddles[i].amount - puddleneutspeed/5
            Puddles[i].size = Puddles[i].size + (bleedintensity*GrowSpeed)
            Paint(Vec(Puddles[i].pos[1] + math.random(-Puddles[i].size * 100,Puddles[i].size * 100)/100, Puddles[i].pos[2], Puddles[i].pos[3] + math.random(-Puddles[i].size * 100,Puddles[i].size * 100)/100), math.random(0,200)/1000, "explosion")
        else
            table.remove(Puddles, i)
            i = i-1 -- <- this is super important since we are in the middle of a for loop and now we remove an item, this changes the whole table so if we would not reduce i by 1 we would jump over an element!
            --- Before [A,B,C,D] and we ar at position 2 so we are here: [A, (B), C , D]
            --- Now, withing the for loop, we remove position 2 so the table looks like this [A, C ,D], but i would still be 2 and in the next for loop iteration it will be 3! so We would then be here: [A, C, (D)] <-- see? We skipped C
        end
    end
end
end
end

function InsertPuddleToTable()
	if bleedbool then
    local merged = false
    for z=1,#Puddles do
        if Puddles[z] ~= nil then
            pos = Puddles[z].pos
            DistToOtherPuddle = VecLength(VecSub(GetAimPos(), pos))
            if DistToOtherPuddle < mergepuddledistance then
                Puddles[z].amount = bleedintensity + Puddles[z].amount
                merged = true
            end
        end
    end
    
    if not merged then
        table.insert(Puddles, {pos=GetAimPos(), amount=bleedintensity, size=0})
    end
end
end

function cower()
	if not panic then
	retractjoint1 = sretractjoint
	retractjoint2 = sretractjoint
	retractjoint3 = sretractjoint
	retractjoint4 = sretractjoint
	retractjoint5 = sretractjoint
	end
	if tripped and not dead then
	shoulders = FindJoints("shoulder")
	for i=1,#shoulders do
		panick()
		SetJointMotor(shoulders[i], retractjoint1,jointstrength)
	end
	hips = FindJoints("hip")
	for i=1,#hips do
		panick()
		SetJointMotor(hips[i], retractjoint2,jointstrength)
	end
	knees = FindJoints("knee")
	for i=1,#knees do
		panick()
		if not IsJointBroken(hips[i]) then
		SetJointMotor(knees[i], retractjoint3,jointstrength)
		end
	end
	hand1 = FindJoint("hand1")
	hand2 = FindJoint("hand2")
	panick()
	if not IsJointBroken(shoulders[1]) then
	SetJointMotor(hand1, -retractjoint4,jointstrength)
	end
	panick()
	if not IsJointBroken(shoulders[2]) then
	SetJointMotor(hand2, retractjoint5,jointstrength)
	end
	restartjoints = true
	end
end

function restartjointsfunc()
	--if tripped then
	if restartjoints then
	shoulders = FindJoints("shoulder")
	for i=1,#shoulders do
		SetJointMotor(shoulders[i], 0,0)
	end
	hips = FindJoints("hip")
	for i=1,#hips do
		SetJointMotor(hips[i], 0,0)
	end
	knees = FindJoints("knee")
	for i=1,#knees do
		if not IsJointBroken(hips[i]) then
		SetJointMotor(knees[i], 0,0)
	end
	end
	hand1 = FindJoint("hand1")
	hand2 = FindJoint("hand2")
	if not IsJointBroken(shoulders[1]) then
	SetJointMotor(hand1, 0,0)
	end
	if not IsJointBroken(shoulders[2]) then
	SetJointMotor(hand2, 0,0)
	end
	restartjoints = false
end
--end
end

function panick()
	if panic and not playedsnd then
		PlayLoop(criticalcough, GetBodyTransform(Torso).pos)
	end
	if panic and panictim > 2 then
		if actualpanictim > 0.05 then
			lol = math.random(0,6)
		if lol == 1 then
		retractjoint1 = math.random(-sretractjoint, sretractjoint)
		end
		if lol == 2 then
		retractjoint2 = math.random(-sretractjoint, sretractjoint)
		end
		if lol == 3 then
		retractjoint3 = math.random(-sretractjoint, sretractjoint)
		end
		if lol == 4 then
		retractjoint4 = math.random(-sretractjoint, sretractjoint)
		end
		if lol == 5 then
		retractjoint5 = math.random(-sretractjoint, sretractjoint)
		end
		if lol == 6 then
			jawjointss = FindJoints("jaw")
			for i=1,#jawjointss do
				SetJointMotor(jawjointss[i], math.random(-15,15), 200)
			end
		end
		actualpanictim = 0

	end
	end
	end

	function GetAimPossit()
   local ct = GetPlayerCameraTransform()
   local forwardPos = TransformToParentPoint(ct, Vec(0, 0, -200))
   local direction = VecSub(forwardPos, ct.pos)
   local distance = VecLength(direction)
   local direction = VecNormalize(direction)
   QueryRejectBody(sb)
   local hit, hitDistance = QueryRaycast(ct.pos, direction, distance)
   if hit then
      forwardPos = TransformToParentPoint(ct, Vec(0, 0, -hitDistance))
      distance = hitDistance
   end
   return forwardPos, hit, distance
end

function sit()
	if sitting and not panic and not inposition then
		inpostim = inpostim + 0.1
		if inpostim > 2 then
			inposition = true
			inpostim = 0
		end
		--DebugPrint(inpostim)
		shoulders = FindJoints("shoulder")
	for i=1,#shoulders do
		panick()
		--SetJointMotor(shoulders[i], retractjoint1,jointstrength)
	end
	hips = FindJoints("hip")
	for i=1,#hips do
		panick()
		SetJointMotor(hips[i], retractjoint2/15)
	end
	knees = FindJoints("knee")
	for i=1,#knees do
		panick()
		if not IsJointBroken(hips[i]) then
		SetJointMotor(knees[i], retractjoint3/15)
		end
	end
	hand1 = FindJoint("hand1")
	hand2 = FindJoint("hand2")
	panick()
	if not IsJointBroken(shoulders[1]) then
	--SetJointMotor(hand1, -retractjoint4,jointstrength)
	end
	panick()
	if not IsJointBroken(shoulders[2]) then
	--SetJointMotor(hand2, retractjoint5,jointstrength)
	end
	end
end

function CheckHealthUi()

	local lookingAtMe = GetInt("health.ui.target.body") ~= nil and RagdollBody[GetInt("health.ui.target.body")] ~= nil		
	
	if InputPressed("h") then 			
		if lookingAtMe and not MyHealthUiIsActive then
			MyHealthUiIsActive = true
			SetInt("health.ui.active.body", Torso)
			SetBool("health.ui.shown", true)
		else
			MyHealthUiIsActive = false			
			if GetInt("health.ui.active.body") == Torso then
				SetBool("health.ui.shown", false)
			end
		end							
	end	
	
	if not lookingAtMe and GetInt("health.ui.active.body") ~= Torso then
		MyHealthUiIsActive = false		
	end
	
	if lookingAtMe and GetBool("health.ui.shown") then		
		MyHealthUiIsActive = true
	end
	
	if MyHealthUiIsActive then
		SetInt("health.ui.active.body", Torso)		
		ShowUiHealthOverlay()	
	else
		HideUiHealthOverlay()	
	end
	
	if InputPressed("x") and MyHealthUiIsActive then
		ToggleUiHealthDetailsOverlay()
	end		
end