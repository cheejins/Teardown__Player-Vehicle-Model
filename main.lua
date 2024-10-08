------------------------------------------------------------------------------------------------
-- Vehicle Player Model
-- By: Cheejins
------------------------------------------------------------------------------------------------
-- Do not reupload this mod without permission.
------------------------------------------------------------------------------------------------


--[[
#include "scripts/controls.lua"
#include "scripts/prefab_data.lua"
#include "scripts/prefab_filter.lua"
#include "scripts/prefab_functions.lua"
#include "scripts/prefab_tags.lua"
#include "scripts/ragdoll_poser.lua"
#include "scripts/ragdoll_viewer.lua"
#include "scripts/ui/ui.lua"
#include "scripts/ui/ui_debug.lua"
#include "TDSU/tdsu.lua"
]]


Version = "1.04" -- 2024-05-02
-- Version = "1.03"
-- Version = "1.02"
-- Version = "1.01"
-- Version = "1.00"


function init()

    CFG = {
        -- RUN_POSING        = true, -- Pose the current ragdoll.
        RUN_PRINTER       = false, -- Prints the transform values for a manually posed ragdoll.
        SPAWN_ALL_PREFABS = false, -- Spawn all ragdoll entities.
        DEBUG             = false,
    }

    Ui = {
        interact = true,
        show_options = false,
        show_ragdollPlacerUi = false,
    }

    REG = {
        bool_DisableRagdoll = "savegame.mod.DisableRagdoll",

        string_SavedRagdollModelPath = "savegame.mod.SavedRagdollModelPath",
        string_QueryTags = "savegame.mod.QueryTags",

        options = {
            bool_keepRagdollInCar = "savegame.mod.options.keepRagdollInCar",
            bool_keepRagdollInCarWithMenu = "savegame.mod.options.keepRagdollInCarWithMenu",
            bool_debugmode = "savegame.mod.options.debugmode",
            bool_removeHead = "savegame.mod.options.removeHead"
        },

        float_ragdollOffset = {
            x = "savegame.mod.ragdollOffset.x",
            y = "savegame.mod.ragdollOffset.y",
            z = "savegame.mod.ragdollOffset.z"
        }
    }

    RootPath = "MOD/main/Gore Ragdolls 2/" --- Path to the root ragdoll prefabs folder.
    SpawnedPrefabs = {}
    CurrentPrefabPath = "-"
    SelectedPrefab = nil

    Spawned = false
    RespawnCount = 0
    RespawnCountWarning = 10

    CFG.SPAWN_ALL_PREFABS = GetBool("level.VehiclePlayerModel.SPAWN_ALL_PREFABS")
    if CFG.SPAWN_ALL_PREFABS then
        SpawnAllPrefabs()
    end

    init_draw()
    init_controls()

    init_prefab_tags()
    init_prefab_objects()
    init_prefab_database()
    init_ragdoll_poser()
    init_viewer()

    local driver = TransformToParentPoint( GetVehicleTransform( GetPlayerVehicle() ), GetVehicleDriverPos( GetPlayerVehicle() ) )
    IsFirstPerson = VecLength( VecSub( driver, GetCameraTransform().pos ) ) < 1

end

function tick()

    local playerDriving = GetPlayerVehicle() ~= 0
    local keepRagdoll = GetBool(REG.options.bool_keepRagdollInCar) and IsHandleValid(LastPlayerVehicle)
    local notPreviewingRagdoll = GetBool(REG.options.bool_keepRagdollInCarWithMenu) or (not GetBool(REG.options.bool_keepRagdollInCarWithMenu) and not Controls.toggles.showui.toggled)
    IsRagdollInVehicle = (not GetBool(REG.bool_DisableRagdoll)) and (playerDriving or (keepRagdoll and notPreviewingRagdoll))

    local driver = TransformToParentPoint( GetVehicleTransform( GetPlayerVehicle() ), GetVehicleDriverPos( GetPlayerVehicle() ) )
    IsFirstPerson = VecLength( VecSub( driver, GetCameraTransform().pos ) ) < 1

    CFG.DEBUG = GetBool(REG.options.bool_debugmode)

    tick_controls()
    tick_viewer()

    -- Initial body spawn.
    if not Spawned then
        local savedRagdollPath = GetString(REG.string_SavedRagdollModelPath)
        if savedRagdollPath == "" then
            SetRandomRagdoll()
        else
            CurrentPrefabPath = savedRagdollPath
            SelectedPrefab = FindPrefabByPath(CurrentPrefabPath)
        end

        InstantiateRagdoll(SelectedPrefab.path)
        Spawned = true
    end

    if GetPlayerVehicle() ~= 0 then
        LastPlayerVehicle = GetPlayerVehicle()
    end
    -- DrawBodyOutline(GetVehicleBody(LastPlayerVehicle), 0,1,0, 1)

    -- DebugWatch("#RagdollBodies", GetTableSize(RagdollBodies))
    -- DebugWatch("#RagdollOtherBodies", #RagdollOtherBodies)
    -- DebugWatch("QueryTags", table.concat(QueryTags))

    tick_ragdoll_poser()


    DidFilter = false
end

function update()

    update_ragdoll_poser()

end

function draw()

    uiSetFont(24)
    UiAlign("top left")

    UiPush()
        if CFG.SPAWN_ALL_PREFABS then draw_prefab_positions() end
    UiPop()

    if Controls.toggles.showui.toggled then
        draw_ui()
    end

end
