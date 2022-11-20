function init()
	TORSO = FindShape("TORSO")
end
function tick()
	if not done then
	bodyparts = FindShapes("bodypart")

		for i=1,#bodyparts do
			if IsShapeBroken(bodyparts[i]) then
			deleteandspawn = true
			cooltrans = GetShapeWorldTransform(TORSO)
			end
		end

		if deleteandspawn then
		shapes = FindShapes("")
		ragdollname = GetTagValue(TORSO, "ragdollname")
			for i=1,#shapes do
				Delete(shapes[i])
			end
			--DebugPrint("Ragdoll name: ".. ragdollname)
			Spawn("MOD/main/Gore Ragdolls 2/Sitters/" .. ragdollname .. ".xml", Transform(cooltrans.pos, cooltrans.rot))
			done = true
			--DebugPrint("MOD/main/Gore Ragdolls 2/Sitters/" .. ragdollname .. ".xml")
		end
	end
end	
