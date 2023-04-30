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
        -- draw_debug_current_prefab_path()

        if CFG.SPAWN_ALL_PREFABS then
            draw_prefab_positions()
        end
    UiPop()

end


function draw_container(w, h, a)
    UiPush()

        local marginY = 0
        local marginX = 0

        if Ui.interact and not Controls.holds.disableInteractive.held then UiMakeInteractive() end


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

        --> Header
        UiPush()
            uiSetFont(FontSizes.header)
            UiText("Tag Selection")

            -- UiAlign("right top")
            -- UiTranslate(w-(Pad*2), 0)
            UiTranslate(0, FontSizes.header)

            UiButtonImageBox(ImageBoxSolid, 6, 6, 0.2,0.2,0.8, 0.8)
            if UiTextButton("Select All", 120, FontSizes.header) then
                FilterTags = GetTableKeys(Prefabs.tags)
            end

            UiTranslate(120 + Pad, 0)
            UiButtonImageBox(ImageBoxSolid, 6, 6, 0.8,0.2,0.2, 0.8)
            if UiTextButton("Clear All", 120, FontSizes.header) then
                FilterTags = {}
            end

        UiPop()

        UiTranslate(0, FontSizes.header)
        UiTranslate(0, FontSizes.header)
        UiTranslate(0, FontSizes.header)
        UiTranslate(0, FontSizes.header)


        uiSetFont(FontSizes.text)
        UiAlign("left middle")

        --> Button-list of filter tags
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

        -- Background
        UiColor(0,0,0, BgAlpha)
        UiImageBox(ImageBoxSolid, w, h, 6, 6)

        -- Create window
        UiTranslate(Pad, Pad)
        UiWindow(w - Pad*2, h, true)
        w, h = UiWidth(), UiHeight()


        local cellsCountHorizontal = 4
        local cellsCountVertical = 5
        local cellSize = w/cellsCountHorizontal
        local yUsed = 0


        local queryIndex = 1
        local queryLastIndex = #Prefabs.all
        local queryMouseHover = 1


        uiSetFont(FontSizes.text)
        UiPush()
            local gridH = cellsCountVertical * cellSize
            UiWindow(w, gridH, true)

            --> Scroll
            Scroll_Previews_Amount = Scroll_Previews_Amount or 0
            local scroll_dx = InputValue("mousewheel")
            if UiIsMouseInRect(w,h) and scroll_dx ~= 0 then
                Scroll_Previews_Amount = Scroll_Previews_Amount + scroll_dx * cellSize/3
                Scroll_Previews_Amount = clamp(Scroll_Previews_Amount, -math.huge, 0)
            end
            UiTranslate(0, Scroll_Previews_Amount)

            for y = 1, cellsCountVertical do

                UiPush()
                    for x = 1, cellsCountHorizontal do

                        local prefab = Prefabs.all[queryIndex]


                        local color = {1,1,1, 1}
                        if prefab == SelectedPrefab then
                            color = { 1/2,1,1/2, 1 }
                        elseif not UiIsMouseInRect(cellSize - Pad, cellSize - Pad) then
                            color = { 1/2,1/2,1/2, 1 }
                        end
                        UiColor(unpack(color))


                        UiButtonImageBox(ImageBoxOutline, 6,6, unpack(color))
                        if UiTextButton(" ", cellSize - Pad/2, cellSize - Pad/2) then
                            SelectedPrefab = prefab
                        end
                        UiWordWrap((FontSizes.text * cellsCountHorizontal) - Pad)
                        UiText(prefab.title)

                        UiTranslate(cellSize, 0)


                        queryIndex = queryIndex + 1
                        if queryIndex >= queryLastIndex then break end

                    end
                UiPop()

                UiTranslate(0, cellSize)
                yUsed = yUsed + cellSize

                if queryIndex >= queryLastIndex then break end

            end
        UiPop()


        local yRemaining = h - yUsed + Pad
        UiTranslate(0, yUsed)

        yRemaining = yRemaining - Pad*4
        UiImageBox(ImageBoxOutline, w - Pad/2, yRemaining+Pad, 6, 6)


        if SelectedPrefab then
            UiText(SelectedPrefab.title)
        end


        DebugWatch("#Prefabs.all", #Prefabs.all)
        DebugWatch("Scroll_Previews_Amount", Scroll_Previews_Amount)

    UiPop()
end
