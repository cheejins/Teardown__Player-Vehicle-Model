ImageBoxSolid = 'ui/common/box-solid-6.png'
ImageBoxOutline = 'ui/common/box-outline-6.png'

function init_draw()

    FontSizes = {
        title   = 50,
        header  = 36,
        text    = 24,
    }

    Pad = 10

end

function draw_ui()
    UiPush()

        local scale = 0.9
        local w = UiWidth()
        local h = UiHeight()

        UiPush()
            UiTranslate(w * (1-scale)/2, h * (1-scale)/2)
            draw_container(w * scale, h * scale)
        UiPop()

    UiPop()

    UiPush()
    --     draw_debug_prefab_info()
        draw_debug_current_prefab_path()

        if CFG.SPAWN_ALL_PREFABS then
            draw_prefab_positions()
        end
    UiPop()

end


function draw_container(w, h, a)
    UiPush()

        local marginY = 0
        local marginX = 0

        if Ui.interact then UiMakeInteractive() end


        UiColor(0, 0, 0, a or 0.8)
        UiImageBox(ImageBoxSolid, w, h, 6, 6) -- Container background

        UiAlign("top left")
        uiSetFont(24)

        -- Title section
        marginY = marginY + 100
        draw_container_title(w, marginY)

        -- Filter section
        UiTranslate(0, marginY)
        marginX = marginX + 500
        draw_container_filter(marginX, h - marginY)

        -- Previews section
        UiTranslate(marginX, 0)
        draw_container_previews(w - marginX, h - marginY)

        uiDrawSquare()

    UiPop()
end

function draw_container_title(w, h)
    UiPush()

        UiColor(1,1,1, 0.5)
        UiImageBox(ImageBoxOutline, w, h, 6, 6)

        UiTranslate(Pad, Pad)
        UiWindow(w - Pad*2, h, true)

        uiSetFont(FontSizes.title)
        UiText("Vehicle Player Model")

        UiTranslate(0, FontSizes.title)
        uiSetFont(FontSizes.header)
        UiText("By: Cheejins")

    UiPop()
end

function draw_container_filter(w, h)
    UiPush()

        UiColor(1,1,1, 0.5)
        UiImageBox(ImageBoxOutline, w, h, 6, 6)

        UiTranslate(Pad, Pad)
        UiWindow(w - Pad*2, h, true)

        UiPush()
            uiSetFont(FontSizes.header)
            UiText("Tag Selection")

            UiAlign("right top")
            UiTranslate(w-(Pad*2), 0)

            UiButtonImageBox(ImageBoxSolid, 6, 6, 0.2,0.2,0.8, 0.8)
            if UiTextButton("Clear Filters", 200, FontSizes.header) then
                beep()
            end
        UiPop()

        UiTranslate(0, FontSizes.header)
        UiTranslate(0, FontSizes.header)


        uiSetFont(FontSizes.text)
        UiAlign("left middle")

        local keys = GetTableKeys(Prefabs.tags)
        table.sort(keys)
        for index, prefab in ipairs(keys) do

            UiButtonImageBox(ImageBoxSolid, 6, 6, 0.2,0.2,0.2, 0.8)
            if UiTextButton(" ", w/2, FontSizes.header) then
                beep()
            end

            UiColor(1,1,1,1)
            UiText(prefab)

            UiTranslate(0, FontSizes.header + Pad)

        end

    UiPop()
end

function draw_container_previews(w, h)
    UiPush()

        UiColor(1,1,1, 0.5)
        UiImageBox(ImageBoxOutline, w, h, 6, 6)

        UiTranslate(Pad, Pad)
        UiWindow(w - Pad*2, h, true)

    UiPop()
end
