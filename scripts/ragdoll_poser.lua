--================================================================
--This script positions the ragdoll body parts relative to the
--Thethe transform data is then extracted from the posed npc.
--================================================================


-- Contains the body references of the current driver ragdoll.
RagdollBodies = {}
RagdollOtherBodies = {}


-- From sit.xml using MOD/ragdoll_xml_extractor.lua to extract and print the lua data to Thomasim's extrenal console.
BodyRelTransforms = {
    RRLEG = Transform(Vec(-0.30000004172325, -0.70000004768372, 0.099999971687794), Quat(-0.25881904363632, 0, 0, 0.96592581272125)),
    Head  = Transform(Vec(0, 0, 0), Quat(0, 0, 0, 1)),
    Torso = Transform(Vec(1.2617366706991e-08, -0.40000009536743, -0.19999998807907), Quat(0, -1, 0, -4.3711388286738e-08)),
    LARM  = Transform(Vec(0.5, -0.20000004768372, -0.24999994039536), Quat(-0.5712525844574, -0.084108546376228, -0.022537779062986, 0.81614238023758)),
    RRARM = Transform(Vec(-0.10000001639128, -0.30000007152557, 0.1000000089407), Quat(0.56774789094925, -0.11312747746706, -0.13403674960136, -0.80430006980896)),
    LLARM = Transform(Vec(0.39999997615814, -0.30000007152557, 0.20000006258488), Quat(-0.56486254930496, -0.14224433898926, -0.099600560963154, 0.80670726299286)),
    RARM  = Transform(Vec(-0.19999998807907, -0.20000004768372, -0.29999998211861), Quat(0.5712525844574, -0.084108471870422, -0.022537726908922, -0.81614238023758)),
    LLLEG = Transform(Vec(-1.0033978981028e-08, -0.70000004768372, 0.10000002384186), Quat(-0.25881904363632, 0, 0, 0.96592581272125)),
    LLEG  = Transform(Vec(1.2617366706991e-08, -0.70000004768372, -0.19999998807907), Quat(0.81915205717087, 5.014364745648e-08, 7.1612547003497e-08, -0.5735764503479)),
    RLEG  = Transform(Vec(-0.30000001192093, -0.70000004768372, -0.20000001788139), Quat(0.81915205717087, 5.014364745648e-08, 7.1612547003497e-08, -0.5735764503479)),
}


function update_DriverPosing()

    if GetPlayerVehicle() ~= 0 then -- Move player body to driving position.

        -- Vehicle.
        local vBody = GetVehicleBody(GetPlayerVehicle())
        local vehicleTr = GetVehicleTransform(GetPlayerVehicle())
        local vehicleVel = VecScale(GetBodyVelocity(vBody), 1 / 30)

        -- Vehicle driver pos.
        local driverPos = TransformToParentPoint(vehicleTr, GetVehicleDriverPos(GetPlayerVehicle()))
        driverPos = VecAdd(driverPos, vehicleVel)

        -- Make model face forward.
        vehicleTr.rot = QuatLookAt(vehicleTr.pos, TransformToParentPoint(vehicleTr, Vec(0,0,1)))

        -- Position the ragdoll
        for key, body in pairs(RagdollBodies) do

            local bodyTr   = GetBodyTransform(body)
            local driverTr = TransformToParentTransform(Transform(driverPos, vehicleTr.rot), BodyRelTransforms[key])

            ConstrainPosition(body, GetWorldBody(), bodyTr.pos, driverTr.pos)
            ConstrainOrientation(body, GetWorldBody(), bodyTr.rot, driverTr.rot)

            DebugCross(bodyTr.pos, 1,0,0, 1)

        end

        -- Position all other ragdoll bodies relative to head.
        for index, rs in ipairs(RagdollOtherBodies) do

            local body = rs.body
            local headRelTr = rs.headRelTr

            local bodyTr = GetBodyTransform(body)
            local tr = TransformToParentTransform(GetBodyTransform(RagdollBodies["Head"]), headRelTr)
            tr.pos = VecAdd(tr.pos, vehicleVel)

            DebugCross(tr.pos, 1,1,0, 1)

            ConstrainPosition(body, GetWorldBody(), bodyTr.pos, tr.pos)
            ConstrainOrientation(body, GetWorldBody(), bodyTr.rot, tr.rot)

        end


    else -- Store the player body somewhere in another freaking universe.

        -- Position the ragdoll
        for key, body in pairs(RagdollBodies) do
            SetBodyTransform(body, Transform(Vec(0,1000,0)))
            SetBodyVelocity(body, Vec(0,0,0))
        end

    end

end
