function tick()
	SetInt("health.ui.target.body",GetShapeBody(GetPlayerLookingShape()))	
end

function GetPlayerLookingShape()
	local hit, dist, normal, shape = QueryRaycast(GetPlayerCameraTransform().pos, TransformToParentVec(GetPlayerCameraTransform(), Vec(0,0,-1)), 1000)
	if hit then
		return shape
	end
	return nil
end