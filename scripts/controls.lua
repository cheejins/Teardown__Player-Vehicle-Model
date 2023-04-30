function init_controls()

    Controls = {}

    Controls.toggles = {
        showui = { key = "f1", toggled = true }
    }

    Controls.holds = {
        disableInteractive = { key = "rmb", held = false }
    }

end

function tick_controls()

    for _, value in pairs(Controls.toggles) do
        if InputPressed(value.key) then
            value.toggled = not value.toggled
        end
    end

    for _, value in pairs(Controls.holds) do
        value.held = InputDown(value.key)
    end

end
