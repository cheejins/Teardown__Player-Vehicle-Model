#include "TDSU/tdsu.lua"
#include "scripts/prefab_data.lua"
#include "scripts/prefab_tags.lua"
#include "scripts/ragdoll_poser.lua"

--================================================================
-- Vehicle Player Model
-- By: Cheejins
--================================================================


CFG = {
    RUN_POSING = true,
    RUN_PRINTER = false,
    SPAWN_ALL_PREFABS = true,
}


Prefab_Positions = {}

CurrentPrefabPath = "-"



function init()

    Spawned = false
    RespawnCount = 0
    RespawnCountWarning = 10

    init_prefab_tags()
    init_prefab_objects()
    init_prefab_database()

    if CFG.SPAWN_ALL_PREFABS then
        SpawnAllPrefabs()
    end

end

function tick()

    -- DebugLine(Vec(0,0,0), Vec(0,2,0), 1,1,0, 1)

    -- Initial body spawn.
    if not Spawned then
        InstantiateRagdoll()
        Spawned = true
    end

    if InputPressed("mmb") then
        SetRandomRagdoll()
    end

    DebugWatch("#RagdollBodies", GetTableSize(RagdollBodies))
    DebugWatch("#RagdollOtherBodies", #RagdollOtherBodies)

end

function update()

    -- -- Repawn body if deleted.
    -- if not IsHandleValid(PlayerBody) then
    --     InstantiateBody()
    --     RespawnCount = RespawnCount + 1
    -- end

    update_DriverPosing()

end

function draw()

    uiSetFont(24)

    draw_selection_ui()


    draw_current_prefab_path()

    CheckRespawnCount()

    if CFG.SPAWN_ALL_PREFABS then
        draw_prefab_positions()
    end

end



-- Spawn a body, find its parts and store them in RagdollParts as the current driver.
function InstantiateRagdoll(path_xml)

    if CFG.RUN_PRINTER then
        local entities = Spawn("MOD/sit.xml", Transform(Vec(0, 0, 0)), true)
        print("Running printer. Regular spawn cancelled.")
        return
    end

    local xml = path_xml or GetRandomPrefab()

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
    InstantiateRagdoll()
    beep()
end

function GetRandomPrefab()
    local random_category  = GetRandomKey(PrefabObjects)
    local random_prefab    = GetRandomIndexValue(PrefabObjects[random_category]).path
    return RootPath .. random_category .. "/" .. random_prefab
end

function SpawnAllPrefabs()

    local spacing = 5
    local offset = 20
    local i, j = 1, 1
    for path, prefab_category in pairs(PrefabObjects) do

        for xml, prefab in pairs(prefab_category) do

            local spawn_xml = RootPath .. path .. "/" .. prefab
            local tr = Transform(Vec((i-offset)*spacing, 0, j*spacing))

            table.insert(Prefab_Positions, { pos = tr.pos, title = prefab})

            Spawn(spawn_xml, tr)

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
        SetTag(body, "nocull")
    end

end

function CheckRespawnCount()
    if RespawnCount > RespawnCountWarning then
    end
end



function draw_prefab_positions()

    for index, pos in ipairs(Prefab_Positions) do

        local camTr = GetCameraTransform()

        local isInfront = TransformToLocalPoint(camTr, pos.pos)[3] < 0
        local angle = QuatAngle(camTr.rot, QuatLookAt(camTr.pos, pos.pos)) < 10
        local dist = VecDist(camTr.pos, pos.pos)

        if isInfront and angle then

            UiPush()
                local x,y = UiWorldToPixel(pos.pos)
                UiTranslate(x,y)
                uiSetFont(20)
                UiColor(1,1,1, 1)
                UiAlign("center middle")
                UiText(pos.title)

                local s = 2000/VecDist(camTr.pos, pos.pos)
                UiImageBox("ui/common/box-outline-6.png", s, s, 6, 6)

            UiPop()

            break

        end

    end

end

function draw_current_prefab_path()
    UiPush()

        uiSetFont(32)
        UiTranslate(UiCenter(), UiHeight() - 300)
        UiAlign("center middle")

        UiText(CurrentPrefabPath)

    UiPop()
end
