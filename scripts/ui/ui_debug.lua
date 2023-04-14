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
