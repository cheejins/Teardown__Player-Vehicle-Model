#include "TDSU/tdsu.lua"
#include "scripts/controls.lua"


activeAssignment = false
activePath = '.'
lastKeyPressed = '.'


function init()
    init_controls()
end

function draw()

    UiAlign("center middle")
    UiColor(1, 1, 1, 1)
    UiFont("bold.ttf", 24)

    UiTranslate(UiCenter(), 0)

    UiPush()
        UiTranslate(0, 50)

        UiPush()
            UiFont("bold.ttf", 50)
            UiText("Vehicle Player Model")
            UiTranslate(0, 60)
            UiText("By: Cheejins")
        UiPop()
        UiTranslate(0, 300)

        Ui_Option_Keybind("Show UI Menu Keybind", "controls.showui", 30)
        UiTranslate(0, 120)

        UiButtonImageBox('ui/common/box-outline-6.png', 6, 6, 1,1,1)
        if UiTextButton("Load Ragdoll Viewer Map", 400, 50) then
            StartLevel("", "MOD/map_viewer.xml", "")
        end
    UiPop()

    UiTranslate(0, UiHeight() - 100)
    UiButtonImageBox('ui/common/box-outline-6.png', 6, 6, 1,1,1)
    if UiTextButton("Close", 150, 50) then
        Menu()
    end

end

function tick()
    manageKeyAssignment()
end

function manageKeyAssignment()

    if activeAssignment and InputLastPressedKey() ~= '' then
        regSetString(activePath, string.lower(InputLastPressedKey()))
        activeAssignment = false
        activePath = ''
    end

end

function Ui_Option_Keybind(label, regPath, font_size)

    do UiPush()

        -- Label
        UiFont('regular.ttf', font_size)
        UiAlign('right middle')
        UiTranslate(0, font_size)
        UiText(label)

        -- Bind button
        UiTranslate(font_size, 0)
        UiAlign('left middle')
        UiButtonImageBox("ui/common/box-outline-6.png", 10,10)
        UiButtonHoverColor(0.5,0.5,1,1)
        if UiTextButton(regGetString(regPath), font_size*6, font_size*2) then

            if not activeAssignment then
                regSetString(regPath, 'Press key...')
                activeAssignment = true
                activePath = regPath
            end

        end

    UiPop() end

end

function regGetString(path)
    local p = 'savegame.mod.' .. path
    return GetString(p)
end
function regSetString(path, value)
    local p = 'savegame.mod.' .. path
    SetString(p, value)
end
