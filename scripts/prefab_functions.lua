--[[

    Settings
        bool: turn head
        bool: steer
        bool: first person view body
        bool: first person hide head

    Savegame
        favorites

]]


-- Spawn a body, find its parts and store them in RagdollParts as the current driver.
function InstantiateRagdoll(path_xml)

    if CFG.RUN_PRINTER then
        local entities = Spawn("MOD/prefabs/sit.xml", Transform(Vec(0, 0, 0)), true)
        print("Running printer. Regular spawn cancelled.")
        return
    end

    local xml = SelectedPrefab.path

    CurrentPrefabPath = xml

    local entities = Spawn(xml, Transform(Vec(0,1000,0)), true)
    local otherBodies = {}
    for _, ent in ipairs(entities) do -- Check all entities.
        if GetEntityType(ent) == "body" and ent ~= GetWorldBody() then

            for tag, _ in pairs(BodyRelTransforms) do -- Check if body has a relevant tag.
                if HasTag(ent, tag) then
                    RagdollBodies[tag] = ent
                end

            end

        end
    end


    for _, ent in ipairs(entities) do -- Check all other bodies.

        if GetEntityType(ent) == "body" and ent ~= GetWorldBody() then

            local unique = true

            for _, otherBody in ipairs(otherBodies) do -- Check if already found.
                if ent == otherBody then
                    unique = false
                    break
                end
            end

            for _, body in pairs(RagdollBodies) do -- Check if already found.
                if ent == body then
                    unique = false
                    break
                end
            end

            if unique then
                table.insert(otherBodies, ent) -- Insert body that has no tag.
            else
                -- print("duplicate", ent)
            end

        end

    end

    -- print(#otherBodies)

    local headTr = GetBodyTransform(RagdollBodies["Head"])
    for index, body in ipairs(otherBodies) do -- Keep loose bodies relative to ragdoll head.

        local bodyTr = GetBodyTransform(body)
        local headRelTr = TransformToLocalTransform(headTr, bodyTr)

        table.insert(RagdollOtherBodies, { body = body, headRelTr = headRelTr })

    end

    local headBody = RagdollBodies["Head"]
    RagdollHeadShapes = GetBodyShapes(headBody)

    for index, ent in ipairs(entities) do -- Process all shapes.

        if GetEntityType(ent) == "shape" then

            SetShapeCollisionFilter(ent, 0, 0) -- Disable all collisions.
            SetTag(ent, "unbreakable")

            local joints = GetShapeJoints(ent)
            for _, joint in ipairs(joints) do
                if HasTag(joint, "eye") or HasTag(joint, "jaw") then
                    table.insert(RagdollHeadShapes, ent)
                end
            end

        elseif GetEntityType(ent) == "joint" then -- Delete all joints.

            Delete(ent)

        end

    end

    -- local mi, ma = GetBodyBounds(headBody)
    -- mi = VecAdd(mi, Vec(0.25,0.25,0.25))
    -- ma = VecAdd(ma, Vec(-0.25,-0.25,-0.25))

    -- local q_shapes = QueryAabbShapes(mi, ma)
    -- for _, s in ipairs(q_shapes) do
    --     if not HasTag(GetShapeBody(s), "TORSO") then
    --         table.insert(RagdollHeadShapes, s)
    --     end
    -- end

end

function DeleteRagdoll()

    for index, body in pairs(RagdollBodies) do
        Delete(body)
    end
    RagdollBodies = {}

    for index, rb in pairs(RagdollOtherBodies) do
        Delete(rb.body)
    end
    RagdollOtherBodies = {}

    RagdollHeadShapes = {}

end

function SetRandomRagdoll()
    DeleteRagdoll()
    SelectedPrefab = GetRandomPrefab()
    SetRagdoll(SelectedPrefab)
end

function SetRagdoll(prefab)
    DeleteRagdoll()
    SetString(REG.string_SavedRagdollModelPath, prefab.path)
    InstantiateRagdoll(prefab.path)
end

function GetRandomPrefab()
    local random_prefab_path = GetRandomIndexValue(GetRandomPairsValue(PrefabObjects))
    return random_prefab_path
end

function SpawnAllPrefabs()

    local spacing = 10
    local offset = 10
    local i, j = 1, 1
    for _, prefab_category in pairs(PrefabObjects) do

        for _, prefab in ipairs(prefab_category) do

            local spawn_xml = prefab.path
            local tr = Transform(Vec((i-offset)*spacing, 0, j*spacing), Quat())

            local entities = Spawn(spawn_xml, tr) -- Spawn ragdoll

            for index, ent in ipairs(entities) do -- Process all shapes.
                if GetEntityType(ent) == "joint" then -- Delete all joints.
                    Delete(ent)
                end
            end

            table.insert(SpawnedPrefabs, {
                pos = tr.pos,
                path = prefab.path,
                entities = entities
            })

            if j > 15 then
                i = i + 1
                j = 1
            else
                j = j + 1
            end

        end

        i = i + 2
        j = 1

    end

    for index, body in ipairs(FindBodies("", true)) do
        SetBodyDynamic(body, false)
        SetBodyActive(body, false)
        SetTag(body, "nocull")
    end

end

function CheckRespawnCount()
    if RespawnCount > RespawnCountWarning then
    end
end

function FindPrefabByPath(path)
    for _, folder in pairs(PrefabObjects) do
        for _, prefab in pairs(folder) do
            if path == prefab.path then
                return prefab
            end
        end
    end
end

function SetFavorite(path)
    SetBool("savegame.mod.favorites." .. path, true)
end

function RemoveFavorite(path)
    SetBool("savegame.mod.favorites." .. path, false)
end

function IsFavorite(path)
    return GetBool("savegame.mod.favorites." .. path)
end


function ragdoll_assign_vehicle(ragdoll, vehicle)
    
end