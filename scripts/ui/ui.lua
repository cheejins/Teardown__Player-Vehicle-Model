ImageBoxSolid = 'ui/common/box-solid-6.png'
ImageBoxOutline = 'ui/common/box-outline-6.png'

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
            if UiBlankButton(h/2, h/2) then
                Controls.toggles.showui.toggled = false
            end
        UiPop()

        UiTranslate(Pad, Pad)
        UiWindow(w - Pad*2, h, true)

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
        -- UiImageBox(ImageBoxOutline, w, h, 6, 6)

        local scroll = InputValue("mousewheel")

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

            UiTranslate(160 + Pad, 0)
            UiButtonImageBox(ImageBoxSolid, 6, 6, 0.8,0.8,0.8, 0.8)
            if UiTextButton("Random Ragdoll", 160, FontSizes.header) then
                SetRandomRagdoll()
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

        local cellsCountHorizontal = 4
        local cellsCountVertical = 5
        local cellW = w/(cellsCountHorizontal)
        local cellH = h/(cellsCountVertical)
        local yUsed = 0
        local gridH = ((cellsCountVertical - 1) * cellH)

        local dataSet = QueryResults
        local queryIndex = 1
        local queryLastIndex = #dataSet
        local rows = math.ceil(#dataSet / cellsCountVertical)
        --todo Add tooltip details for icon hover

        -- Grid container
        UiColor(1,1,1, BgAlpha)
        UiImageBox(ImageBoxOutline, w, gridH, 6, 6)
        uiSetFont(FontSizes.text)
        UiPush()
            UiWindow(w, gridH, true)

            --> Scroll
            Scroll_Previews_Amount = Scroll_Previews_Amount or 0
            if DidFilter then Scroll_Previews_Amount = 0 end
            local scroll_dx = InputValue("mousewheel")
            if UiIsMouseInRect(w,h) and scroll_dx ~= 0 then
                Scroll_Previews_Amount = Scroll_Previews_Amount + scroll_dx * cellW/3
                Scroll_Previews_Amount = clamp(Scroll_Previews_Amount, (-rows+cellsCountVertical/2) * cellW, 0)
            end

            UiTranslate(2, Scroll_Previews_Amount)

            --> Previews grid
            for y = 1, rows do
                UiPush()
                    for x = 1, cellsCountHorizontal do

                        local prefab = dataSet[queryIndex]


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
                        UiWordWrap((FontSizes.text * cellsCountHorizontal) - Pad)

                        UiPush()
                            UiTranslate(4,4)
                            UiText(prefab.title)
                        UiPop()

                        -- if UiIsMouseInRect(w, gridH) then --! Bleeds into details panel.
                        --     DebugWatch("ingrid", GetTime())
                        -- end

                        UiTranslate(cellW, 0)

                        queryIndex = queryIndex + 1
                        if queryIndex >= queryLastIndex then break end

                    end
                UiPop()

                if queryIndex >= queryLastIndex then break end

                UiTranslate(0, cellW) -- Moves to next row
                yUsed = yUsed + cellW

            end
        UiPop()

        UiTranslate(0, gridH)

        -- Draw details container.
        local detailsW = w
        local detailsH = cellH
        UiImageBox(ImageBoxOutline, detailsW, detailsH, 6, 6)

        if SelectedPrefab then

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
                UiText(table.concat(SelectedPrefab.tags, ", "))
            UiPop()

        else

            UiText("no prefab")

            SelectedPrefab = findPrefabObject(CurrentPrefabPath)

        end

    UiPop()
end
