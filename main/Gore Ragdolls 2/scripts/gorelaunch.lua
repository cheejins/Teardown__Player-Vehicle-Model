function init()
	yeeeeeeeeted = false
	force = 5
	tim = 0
end

function tick()
	body = FindBody("gore")
	if not yeeeeeeeeted then
		local pos = Vec(0,0,0)
		imp = Vec(math.random(-force,force),math.random(force/3,force),math.random(-force,force))
		SetBodyVelocity(body, imp)
		imp = Vec(math.random(-force,force),math.random(force/3,force),math.random(-force,force))
		SetBodyAngularVelocity(body, imp)
		yeeeeeeeeted = true
	end
	tim = tim + 1
	if tim < 75 then
	Paint(GetAimPos(), 0.11, "explosion")
	end
	if InputPressed("L") then
		body = FindBody("gore")
		Delete(body)
	end
end

function GetAimPos()
     ct = GetBodyTransform(body)
    ctrot1, ctrot2, ctrot3 = GetQuatEuler(ct.rot)
    ct.pos[1] = ct.pos[1] + math.random(-100,100)/500
    ct.pos[2] = ct.pos[2] + math.random(-100,100)/500
    ct.pos[3] = ct.pos[3] + math.random(-100,100)/500
    q = QuatEuler(-90, 0, 0)
    ct.rot = q
    local forwardPos = TransformToParentPoint(ct, Vec(0, 0, -150))
    local direction = VecSub(forwardPos, ct.pos)
    local distance = VecLength(direction)
    local direction = VecNormalize(direction)
    local hit, hitDistance = QueryRaycast(ct.pos, direction, distance)
    if hit then
        forwardPos = TransformToParentPoint(ct, Vec(0, 0, -hitDistance))
        distance = hitDistance
    end
    return forwardPos, hit, distance
end