#include "TDSU/tdsu.lua"
#include "scripts/controls.lua"
#include "scripts/prefab_data.lua"
#include "scripts/prefab_filter.lua"
#include "scripts/prefab_functions.lua"
#include "scripts/prefab_tags.lua"
#include "scripts/ragdoll_poser.lua"
#include "scripts/ragdoll_viewer.lua"
#include "scripts/ui/ui.lua"
#include "scripts/ui/ui_debug.lua"


------------------------------------------------------------------------------------------------
-- Vehicle Player Model
-- By: Cheejins
------------------------------------------------------------------------------------------------
-- Please do not reupload this mod without permission. If you would like to submit ragdolls
-- to be part of this mod, you can contact me on discord @Cheejins
------------------------------------------------------------------------------------------------

RootPath = "MOD/main/Gore Ragdolls 2/" --- Path to the root ragdoll prefabs folder.

SpawnedPrefabs = {}
CurrentPrefabPath = "-"


CFG = {
    RUN_POSING = true, -- Pose the current ragdoll.
    RUN_PRINTER = false, -- Prints the transform values for a manually posed ragdoll.
    SPAWN_ALL_PREFABS = true, -- Spawn all ragdoll entities.
}

Ui = {
    interact = true,
}


function init()

    Spawned = false
    RespawnCount = 0
    RespawnCountWarning = 10

    init_draw()
    init_controls()

    init_prefab_tags()
    init_prefab_objects()
    init_prefab_database()

    if CFG.SPAWN_ALL_PREFABS then
        SpawnAllPrefabs()
    end

    init_viewer()


end

function tick()

    tick_controls()
    tick_viewer()

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

    DidFilter = false

end

function update()

    -- -- Repawn body if deleted.
    -- if not IsHandleValid(PlayerBody) then
    --     InstantiateBody()
    --     RespawnCount = RespawnCount + 1
    -- end

    update_DriverPosing()

    CheckRespawnCount()


end

function draw()

    uiSetFont(24)
    UiAlign("top left")

    UiPush()
        -- draw_debug_prefab_info()
        -- draw_debug_current_prefab_path()
        if CFG.SPAWN_ALL_PREFABS then draw_prefab_positions() end
    UiPop()

    if Controls.toggles.showui.toggled then
        draw_ui()
    end

end


function draw_prefab_positions()

    for index, pos in ipairs(SpawnedPrefabs) do

        local camTr = GetCameraTransform()

        local isInfront = TransformToLocalPoint(camTr, pos.pos)[3] < 0
        local angle = QuatAngle(camTr.rot, QuatLookAt(camTr.pos, pos.pos)) < 10
        -- local dist = VecDist(camTr.pos, pos.pos)

        if isInfront and angle then
            UiPush()
                local x,y = UiWorldToPixel(pos.pos)
                UiTranslate(x,y)
                uiSetFont(24)
                UiColor(1,1,1, 1)
                UiAlign("left middle")
                UiText(pos.path)
                UiText(pos.path)
            UiPop()
        end

    end

end
