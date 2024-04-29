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


    for index, ent in ipairs(entities) do -- Process all shapes.

        if GetEntityType(ent) == "shape" then

            SetShapeCollisionFilter(ent, 0, 0) -- Disable all collisions.
            SetTag(ent, "unbreakable")

        elseif GetEntityType(ent) == "joint" then -- Delete all joints.

            Delete(ent)

        end

    end

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

end

function SetRandomRagdoll()
    DeleteRagdoll()
    SelectedPrefab = GetRandomPrefab()
    InstantiateRagdoll()
    beep()
end

function SetRagdoll(prefab)
    DeleteRagdoll()
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

function SetFavorite(path)
    SetBool("savegame.mod.favorites." .. path, true)
end

function RemoveFavorite(path)
    SetBool("savegame.mod.favorites." .. path, false)
end

function IsFavorite(path)
    return GetBool("savegame.mod.favorites." .. path)
end
