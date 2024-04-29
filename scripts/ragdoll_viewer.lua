function init_viewer()

    ViewerIndex = 1
    ViewerPrefabs = SpawnedPrefabs

    for _, s_prefab in ipairs(ViewerPrefabs) do

        s_prefab.entity_trs = {} -- Holds the starting transform of each entity.

        for _, entity in ipairs(s_prefab.entities) do
            if GetEntityType(entity) == "body" then
                s_prefab.entity_trs[entity] = GetBodyTransform(entity)
            end
        end

    end

end

-- Sets camera to selected ragdoll for preview screenshots.
function tick_viewer()

    if not CFG.SPAWN_ALL_PREFABS then
        return
    end

    -- if InputPressed("f3") then
    --     ViewerIndex = GetTablePreviousIndex(ViewerPrefabs, ViewerIndex)
    --     beep()
    -- elseif InputPressed("f4") then
    --     ViewerIndex = GetTableNextIndex(ViewerPrefabs, ViewerIndex)
    --     beep()
    -- end


    local focusPrefab = ViewerPrefabs[ViewerIndex]

    for index, body in ipairs(focusPrefab.entities) do
        if GetEntityType(body) == "body" then
            DrawBodyOutline(body, 0,1,0, 1)
        end
    end


    if Controls.toggles.viewer_focus.toggled then
        -- viewer_focus(focusPrefab)
        viewer_view(focusPrefab)

        if InputPressed("space") then
            print(focusPrefab.path)
        end

    end


    -- DebugWatch("ViewerIndex", ViewerIndex)
    -- DebugWatch("Viewer selectedRagdoll", focusPrefab)

end


function viewer_focus(focusPrefab)

    for index, entity in ipairs(focusPrefab.entities) do

        if GetEntityType(entity) == "body" then

            DebugCross(entity, 1, 0, 0, 1)

            local focusTr = TransformToParentTransform(
                focusPrefab.entity_trs[index],
                Transform(Vec(0,100,0)))

            SetBodyTransform(entity, focusTr)

        end

    end

end

function viewer_defocus(focusPrefab)

    for index, entity in ipairs(focusPrefab.entities) do
        SetEntityTransform(entity, focusPrefab.entity_trs[index])
    end

end

function viewer_view(focusPrefab)

    for index, entity in ipairs(focusPrefab.entities) do
        if HasTag(entity, "Torso") then
            local tr = TransformToParentTransform(
                GetBodyTransform(entity),
                Transform(Vec(-4, 1, -4), QuatEuler(-15, -135, 0))
            )
            SetCameraTransform(tr, 50)
            break
        end
    end

end
