ImageBoxSolid = 'ui/common/box-solid-6.png'
ImageBoxOutline = 'ui/common/box-outline-6.png'

function init_draw()

    FontSizes = {
        title   = 48,
        header  = 32,
        text    = 20,
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

    UiPop()
end

function draw_container_previews(w, h)
    UiPush()

        UiColor(1,1,1, 0.5)
        UiImageBox(ImageBoxOutline, w, h, 6, 6)

    UiPop()
end
