ImageBoxSolid = 'ui/common/box-solid-6.png'
ImageBoxOutline = 'ui/common/box-outline-6.png'

function init_draw()

    FontSizes = {
        title   = 50,
        header  = 32,
        text    = 24,
    }

    Pad = 10
    BgAlpha = 0.9

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
        -- UiImageBox(ImageBoxSolid, w, h, 6, 6) -- Container background

        UiAlign("top left")
        uiSetFont(24)

        -- Title section
        marginY = marginY + 100
        draw_container_title(w, marginY)

        -- Filter section
        UiTranslate(0, marginY)
        marginX = marginX + w/3
        draw_container_filter(marginX, h - marginY)

        -- Previews section
        marginX = marginX + w/3
        UiTranslate(marginX, 0)
        draw_container_previews(w - marginX, h - marginY)

    UiPop()
end

function draw_container_title(w, h)
    UiPush()

        UiColor(0,0,0, BgAlpha)
        UiImageBox(ImageBoxSolid, w, h, 6, 6)

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

        UiColor(0,0,0, BgAlpha)
        UiImageBox(ImageBoxSolid, w, h, 6, 6)

        UiTranslate(Pad, Pad)
        UiWindow(w - Pad*2, h, true)

        -- Header
        UiPush()
            uiSetFont(FontSizes.header)
            UiText("Tag Selection")

            UiAlign("right top")
            UiTranslate(w-(Pad*2), 0)

            UiButtonImageBox(ImageBoxSolid, 6, 6, 0.8,0.2,0.2, 0.8)
            if UiTextButton("Clear All", 120, FontSizes.header) then
                FilterTags = {}
            end

            UiTranslate(-120 - Pad, 0)
            UiButtonImageBox(ImageBoxSolid, 6, 6, 0.2,0.2,0.8, 0.8)
            if UiTextButton("Select All", 120, FontSizes.header) then
                FilterTags = GetTableKeys(Prefabs.tags)
            end

        UiPop()

        UiTranslate(0, FontSizes.header)
        UiTranslate(0, FontSizes.header)
        UiTranslate(0, FontSizes.header)


        uiSetFont(FontSizes.text)
        UiAlign("left middle")

        -- List
        local keys = GetTableKeys(Prefabs.tags)
        table.sort(keys)
        for index, prefab in ipairs(keys) do

            local selected = TableContainsValue(FilterTags, prefab)

            if selected then
                UiButtonImageBox(ImageBoxSolid, 6, 6, 0.2,0.5,0.2, 0.8)
            else
                UiButtonImageBox(ImageBoxSolid, 6, 6, 0.2,0.2,0.2, 0.8)
            end

            if UiTextButton(" ", w, FontSizes.header) then
                if selected then
                    TableRemoveUnique(FilterTags, prefab)
                else
                    TableInsertUnique(FilterTags, prefab)
                end
            end

            UiColor(1,1,1,1)
            UiText(Tags[prefab].title)

            UiTranslate(0, FontSizes.header + Pad)

        end

    UiPop()
end

function draw_container_previews(w, h)
    UiPush()

        UiColor(0,0,0, BgAlpha)
        UiImageBox(ImageBoxSolid, w, h, 6, 6)

        UiTranslate(Pad, Pad)
        UiWindow(w - Pad*2, h, true)
        w, h = UiWidth(), UiHeight()

        local cellsCountHorizontal = 4
        local cellW = w/cellsCountHorizontal

        UiColor(1,1,1, 1)
        for y = 1, cellsCountHorizontal do
            UiPush()
                for x = 1, cellsCountHorizontal do
                    UiImageBox(ImageBoxOutline, cellW - Pad/2, cellW - Pad/2, 6, 6)
                    UiTranslate(cellW, 0)
                end
            UiPop()
            UiTranslate(0, cellW)
        end

    UiPop()
end
