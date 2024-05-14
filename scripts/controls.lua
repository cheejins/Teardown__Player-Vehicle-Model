function init_controls()

    Controls = {}

    Controls.toggles = {
        showui = { key = "f1", toggled = false },
        viewer_focus = { key = "f2", toggled = false },
    }

    Controls.down = {
        disableInteractive = { key = "rmb", held = false }
    }

    Controls.pressed = {
        disableInteractive = { key = "rmb", held = false }
    }

    if GetString("savegame.mod.controls.showui") == "" then
        SetString("savegame.mod.controls.showui", "f1")
    end
    Controls.toggles.showui.key = GetString("savegame.mod.controls.showui")

end

function tick_controls()

    Controls.toggles.showui.key = GetString("savegame.mod.controls.showui")

    for _, value in pairs(Controls.toggles) do
        if InputPressed(value.key) then
            value.toggled = not value.toggled
        end
    end

    for _, value in pairs(Controls.down) do
        value.held = InputDown(value.key)
    end

end
