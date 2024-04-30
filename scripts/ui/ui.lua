ImageBoxSolid   = 'ui/common/box-solid-6.png'
ImageBoxOutline = 'ui/common/box-outline-6.png'
ImageFavOutline = 'MOD/img/fav_outline.png'
ImageFavSolid   = 'MOD/img/fav_solid.png'

SelectedPrefab = nil


function init_draw()

    FontSizes = {
        title   = 50,
        header  = 32,
        text    = 24,
    }

    Pad = 10
    Pad2 = Pad*2
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
end


function draw_container(w, h, a)
    UiPush()

        local marginY = 0
        local marginX = 0

        if Ui.interact and not Controls.down.disableInteractive.held then UiMakeInteractive() end


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

        -- Ragdoll preview section
        UiTranslate(marginX, 0)
        draw_container_ragdoll_preview(marginX, h - marginY)
        UiTranslate(-marginX, 0)


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

        UiPush()
            UiTranslate(w, 0)
            UiAlign("right top")
            UiButtonImageBox("MOD/img/close.png", 0, 0, 1, 1, 1, 1)
            if UiBlankButton(h/1.5, h/1.5) then
                Controls.toggles.showui.toggled = false
            end
        UiPop()

        UiPush()
            UiColor(1,1,1,1)
            UiTranslate(h*0.05, h*0.05)
            UiImageBox("MOD/img/Preview.png", h*0.9, h*0.9, 0, 0)
        UiPop()
        UiTranslate(h, 0)

        UiTranslate(Pad, Pad)
        UiWindow(w - Pad*2, h, true)
        UiColor(0,0,0, BgAlpha)

        uiSetFont(FontSizes.title)
        UiText("Vehicle Player Model")

        UiTranslate(0, FontSizes.title)
        uiSetFont(FontSizes.header)
        UiText("By: Cheejins")

    UiPop()
end

function draw_container_ragdoll_preview(w, h)
    UiPush()

        UiColor(0,0,0, BgAlpha)
        UiImageBox(ImageBoxSolid, w, FontSizes.header*2.5 - (Pad/2) - 2, 6, 6)

        local scroll = InputValue("mousewheel")

        UiPush()

            UiAlign("left top")
            UiFont("regular.ttf", 30)
            UiColor(1,1,1, 1)

            -- Random ragdoll button
            local btnW = 280
            UiPush()
                UiTranslate(Pad/2, Pad/2)
                UiButtonImageBox(ImageBoxSolid, 6, 6, 0.2,0.2,0.2, 0.8)
                if UiTextButton("Set Random Ragdoll", btnW, FontSizes.header*2) then
                    SetRandomRagdoll()
                end
            UiPop()

            if SelectedPrefab then

                -- Ragdoll title
                UiPush()
                    UiAlign("center top")
                    UiTranslate(w/2, FontSizes.header*2.5)
                    uiSetFont(FontSizes.header * 1.25)
                    UiText(SelectedPrefab.title)
                UiPop()

                -- Next and prev buttons
                UiPush()
                    local favSize = FontSizes.header*2 - (Pad/2)
                    UiAlign("left top")
                    UiTranslate(btnW + Pad/2, Pad)

                    local isFav = IsFavorite(SelectedPrefab.path)
                    if isFav then
                        UiButtonImageBox(ImageFavSolid, 0,0, 0.8,0.6,0.2, 1)
                    else
                        UiButtonImageBox(ImageFavOutline, 0,0, 0.75,0.75,0.75, 1)
                    end
                    if UiTextButton(" ", favSize, favSize) then
                        if isFav then
                            RemoveFavorite(SelectedPrefab.path)
                        else
                            SetFavorite(SelectedPrefab.path)
                        end
                        if IsFavoritesSelected then SelectFavorites() end
                    end
                UiPop()
            end


        UiPop()

        UiPush()
            if UiIsMouseInRect(w, h) then

                for key, body in pairs(RagdollBodies) do
                    DrawBodyOutline(body, 1, 1, 1, 0.5)
                end
                for key, body in ipairs(RagdollOtherBodies) do
                    DrawBodyOutline(body.body, 1, 1, 1, 0.5)
                end

                if GetPlayerVehicle() == 0 then

                    if Controls.toggles.showui.toggled then

                        if scroll ~= 0 then
                            RagdollPreviewPosDist.val = clamp(RagdollPreviewPosDist.val + (scroll * RagdollPreviewPosDist.scale * 10), RagdollPreviewPosDist.min, RagdollPreviewPosDist.max)
                        end

                        if InputDown("lmb") or InputDown("shoot") then
                            RagdollPreviewRot = QuatRotateQuat(RagdollPreviewRot, QuatEuler(
                                0,
                                InputValue("mousedx"),
                                -- InputValue("mousedy"),
                                0
                            ))
                            -- RagdollPreviewPosDist.val = clamp(RagdollPreviewPosDist.val + (-InputValue("mousedy") * RagdollPreviewPosDist.scale), RagdollPreviewPosDist.min, RagdollPreviewPosDist.max)
                        end

                    end

                else

                    if scroll ~= 0 then
                        RagdollPreviewZoomFOV.val = clamp(RagdollPreviewZoomFOV.val + (-scroll * RagdollPreviewZoomFOV.scale), RagdollPreviewZoomFOV.min, RagdollPreviewZoomFOV.max)
                    end

                end

            end

            if Controls.toggles.showui.toggled and GetPlayerVehicle() ~= 0 then
                SetCameraFov(RagdollPreviewZoomFOV.val)
            end

            local ragdollPreviewDir = QuatToDir(RagdollPreviewRot)
            RagdollPreviewRot = DirToQuat(ragdollPreviewDir)

            UiTranslate(Pad, Pad)
            UiWindow(w - Pad*2, h, true)
        UiPop()

        SelectedQueryResultIndex = SelectedQueryResultIndex or 0 -- Iterate through queried ragdolls.
        if #QueryResults >= 2 then
            UiPush()
                local fontSize = FontSizes.header * 0.8
                local btnW = 150
                UiTranslate(w - 4, 4)
                UiAlign("right top")
                uiSetFont(fontSize)

                UiButtonImageBox(ImageBoxSolid, 6, 6, 0.2,0.2,0.2, 0.8)
                if UiTextButton("Next", btnW, fontSize * 1.25) then
                    SelectedQueryResultIndex = GetTableNextIndex(QueryResults, SelectedQueryResultIndex)
                    SelectedPrefab = QueryResults[SelectedQueryResultIndex]
                    SetRagdoll(SelectedPrefab)
                    PreviewIterated = true
                end
                UiTranslate(0, fontSize * 1.25)

                UiButtonImageBox(ImageBoxSolid, 6, 6, 0.2,0.2,0.2, 0.8)
                if UiTextButton("Previous", btnW, fontSize * 1.25) then
                    SelectedQueryResultIndex = GetTablePreviousIndex(QueryResults, SelectedQueryResultIndex)
                    SelectedPrefab = QueryResults[SelectedQueryResultIndex]
                    SetRagdoll(SelectedPrefab)
                    PreviewIterated = true
                end
            UiPop()
        end

    UiPop()
end

function draw_container_filter(w, h)
    UiPush()

        UiColor(0,0,0, BgAlpha)
        UiImageBox(ImageBoxSolid, w, h, 6, 6)

        UiTranslate(Pad, Pad)
        UiWindow(w - Pad*2, h, true)

        local updateFilter = false

        --> Header
        UiPush()

            uiSetFont(FontSizes.header)
            UiText("Tag Selection")

            -- UiAlign("right top")
            -- UiTranslate(w-(Pad*2), 0)
            UiTranslate(0, FontSizes.header)

            UiButtonImageBox(ImageBoxSolid, 6, 6, 0.2,0.2,0.8, 0.8)
            if UiTextButton("Select All", 120, FontSizes.header) then
                QueryTags = GetTableKeys(Prefabs.tags)
                updateFilter = true
            end

            UiTranslate(120 + Pad, 0)
            UiButtonImageBox(ImageBoxSolid, 6, 6, 0.8,0.2,0.2, 0.8)
            if UiTextButton("Clear All", 120, FontSizes.header) then
                QueryTags = {}
                updateFilter = true
            end

        UiPop()


        UiTranslate(0, FontSizes.header)
        UiTranslate(0, FontSizes.header)
        UiTranslate(0, FontSizes.header)
        UiTranslate(0, FontSizes.header)


        --> Button-list of filter tags
        uiSetFont(FontSizes.text)
        UiAlign("left middle")
        local keys = GetTableKeys(Prefabs.tags)
        table.sort(keys)
        for index, tag_id in ipairs(keys) do

            local selected = TableContainsValue(QueryTags, tag_id)

            if selected then
                UiButtonImageBox(ImageBoxSolid, 6, 6, 0.2,0.5,0.2, 0.8)
            else
                UiButtonImageBox(ImageBoxSolid, 6, 6, 0.2,0.2,0.2, 0.8)
            end

            if UiTextButton(" ", w, FontSizes.header) then
                if selected then
                    TableRemoveUnique(QueryTags, tag_id)
                else
                    TableInsertUnique(QueryTags, tag_id)
                end
                updateFilter = true
            end

            UiColor(1,1,1,1)
            UiText(Tags[tag_id].title)

            UiTranslate(0, FontSizes.header + Pad)

        end

        if updateFilter then
            filter_update()
            beep()
        end

    UiPop()

    UiPush()
        UiTranslate(w/2, h-Pad)
        UiAlign("center bottom")
        UiFont("bold.ttf", 35)
        if IsFavoritesSelected then
            UiButtonImageBox(ImageBoxSolid, 6, 6, 0.8,0.7,0.2, 1)
        else
            UiButtonImageBox(ImageBoxSolid, 6, 6, 0.2,0.2,0.2, 1)
        end
        if UiTextButton("Favorites", w - (Pad*2), 40) then
            if IsFavoritesSelected then
                IsFavoritesSelected = false
                QueryResults = {}
            else
                SelectFavorites()
            end
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
        w, h = UiWidth(), UiHeight() - Pad2

        local dataSet = QueryResults

        local previewCellsWidthCount = 4
        local previewCellsHeightCount = 5
        local cellW = w/(previewCellsWidthCount) - 4
        local cellH = h/(previewCellsHeightCount)
        local gridH = ((previewCellsHeightCount - 1) * cellH)
        local rows = math.ceil(#dataSet / previewCellsWidthCount)

        -- Grid container
        UiColor(1,1,1, BgAlpha)
        UiImageBox(ImageBoxOutline, w, gridH, 6, 6)
        uiSetFont(FontSizes.text)
        UiPush()
            UiWindow(w, gridH, true)

            -- Calculate scroll
            Scroll_Previews_Amount = Scroll_Previews_Amount or 0
            if DidFilter then Scroll_Previews_Amount = 0 end
            local scroll_dx = InputValue("mousewheel") * cellW/2
            local scroll_h_min = (-rows + 1) * cellW
            local scroll_h_max = 0
            if UiIsMouseInRect(w, h) and scroll_dx ~= 0 then
                Scroll_Previews_Amount = clamp(Scroll_Previews_Amount + scroll_dx, scroll_h_min, scroll_h_max)
            end

            --todo align scroll to selected ragoll row
            -- if PreviewIterated then
            --     local row = #QueryResults - SelectedQueryResultIndex
            --     (previewCellsWidthCount * previewCellsHeightCount)
            --     PreviewIterated = false
            -- end

            -- Scroll bar ui
            Scroll_Previews_Amount_Progress = Scroll_Previews_Amount / scroll_h_min
            UiPush()
                UiAlign("right top")

                UiTranslate(w - 5, Pad/2)
                UiColor(0.25, 0.25, 0.25, 1)
                UiImageBox(ImageBoxSolid, 12, gridH - Pad, 6, 6)

                if rows >= previewCellsHeightCount then
                    UiColor(1, 1, 1, 1)
                    UiTranslate(0, Scroll_Previews_Amount_Progress * (gridH - 30 - Pad))
                    UiImageBox(ImageBoxSolid, 12, 30, 6, 6)
                end

                -- Scroll_Previews_Amount = UiSlider("ui/common/dot.png", "y", Scroll_Previews_Amount, scroll_h_min, 0)
                -- Scroll_Previews_Amount = clamp(Scroll_Previews_Amount, scroll_h_min, scroll_h_max)
            UiPop()

            UiTranslate(2, Scroll_Previews_Amount)

            -- DebugWatch("Scroll_Previews_Amount", Scroll_Previews_Amount)
            -- DebugWatch("rows", rows)
            -- DebugWatch("cellW", cellW)
            -- DebugWatch("scroll max", scroll_h_min)
            -- DebugWatch("Scroll_Previews_Amount_Progress", Scroll_Previews_Amount_Progress)

            -- for index, value in ipairs(dataSet) do DebugWatch("index " .. index, value.title) end

            if IsFavoritesSelected and #dataSet <= 0 then
                UiAlign("center top")
                uiSetFont(30)
                UiTranslate(w/2, 20)
                UiText("No Favorites Saved Yet")
            end

            UiTranslate(0, 2)

            for index, prefab in ipairs(dataSet) do

                local color = { 1/2,1/2,1/2, 1 }
                if prefab == SelectedPrefab then
                    color = { 1/2,1,1/2, 1 }
                elseif UiIsMouseInRect(cellW - Pad, cellW - Pad) then
                    color = { 1/2,1/2,1/2, 1 }
                end
                UiColor(unpack(color))

                UiButtonImageBox(ImageBoxOutline, 6, 6, unpack(color))
                if UiTextButton(" ", cellW - Pad/2, cellW - Pad/2) then
                    SelectedPrefab = prefab
                    SetRagdoll(SelectedPrefab)
                end

                UiPush()
                    UiWordWrap((FontSizes.text * previewCellsWidthCount) - Pad)
                    UiTranslate(4,4)
                    UiText(prefab.title)
                UiPop()

                UiPush()
                    local favSize = 50
                    UiAlign("right bottom")
                    UiTranslate(cellW - Pad/1.5, cellW - Pad/1.5)

                    local isFav = IsFavorite(prefab.path)
                    if isFav then
                        UiButtonImageBox(ImageFavSolid, 0,0, 0.8,0.6,0.2, 1)
                    else
                        UiButtonImageBox(ImageFavOutline, 0,0, 0.5,0.5,0.5, 1)
                    end
                    if UiTextButton(" ", favSize, favSize) then
                        if isFav then
                            RemoveFavorite(prefab.path)
                        else
                            SetFavorite(prefab.path)
                        end
                        if IsFavoritesSelected then SelectFavorites() end
                    end
                UiPop()

                UiTranslate(cellW, 0)

                if index % previewCellsWidthCount == 0 then
                    UiTranslate(-cellW * previewCellsWidthCount, cellW) -- Moves to next row
                end

            end

        UiPop()

        UiTranslate(0, gridH)

        -- Draw details container.
        local detailsW = w
        local detailsH = cellH
        UiImageBox(ImageBoxOutline, detailsW, detailsH, 6, 6)

        if SelectedPrefab then
            UiPush()
                UiTranslate(Pad, Pad)
                UiPush()
                    UiText("Name:")
                    UiTranslate(FontSizes.text * 5)
                    UiText(SelectedPrefab.title)
                UiPop()
                UiTranslate(0, FontSizes.text)

                UiPush()
                    UiText("Author:")
                    UiTranslate(FontSizes.text * 5)
                    UiText(SelectedPrefab.folder)
                UiPop()
                UiTranslate(0, FontSizes.text)

                UiPush()
                    UiText("Tags:")
                    UiTranslate(FontSizes.text * 5)
                    local tags = {}
                    for _, tag in ipairs(SelectedPrefab.tags) do
                        table.insert(tags, tag.title)
                    end
                    UiText(table.concat(tags, ", "))
                UiPop()

                UiPush()
                    local favSize = 50
                    UiAlign("right bottom")
                    UiTranslate(w - Pad*1.5, 0)

                    local isFav = IsFavorite(SelectedPrefab.path)
                    if isFav then
                        UiButtonImageBox(ImageFavSolid, 0,0, 0.8,0.6,0.2, 1)
                    else
                        UiButtonImageBox(ImageFavOutline, 0,0, 0.5,0.5,0.5, 1)
                    end
                    if UiTextButton(" ", favSize, favSize) then
                        if isFav then
                            RemoveFavorite(SelectedPrefab.path)
                        else
                            SetFavorite(SelectedPrefab.path)
                        end
                        if IsFavoritesSelected then SelectFavorites() end
                    end
                UiPop()
            UiPop()
        end

    UiPop()
end
