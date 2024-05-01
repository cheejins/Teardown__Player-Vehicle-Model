function draw_debug_prefab_info()
    UiPush()

        for _, prefabObject in ipairs(Prefabs.all) do
            UiText(prefabObject.title)
            UiTranslate(0, 24)
        end

    UiPop()
end


function draw_debug_current_prefab_path()
    UiPush()

        uiSetFont(32)
        UiTranslate(UiCenter(), UiHeight() - 100)
        UiAlign("center middle")

        UiText(CurrentPrefabPath)

    UiPop()
end

function draw_prefab_positions()

    for index, pos in ipairs(SpawnedPrefabs) do

        local camTr = GetCameraTransform()

        local isInfront = TransformToLocalPoint(camTr, pos.pos)[3] < 0
        local angle = QuatAngle(camTr.rot, QuatLookAt(camTr.pos, pos.pos)) < 10
        -- local dist = VecDist(camTr.pos, pos.pos)

        if isInfront and angle then
            UiPush()
                local x,y = UiWorldToPixel(pos.pos)
                UiTranslate(x,y)
                uiSetFont(24)
                UiColor(1,1,1, 1)
                UiAlign("left middle")
                UiText(pos.path)
                UiText(pos.path)
            UiPop()
        end

    end

end