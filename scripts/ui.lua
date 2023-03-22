function draw_ui()
    UiPush()

        uiSetFont(24)
        UiAlign("top left")

        for _, prefabObject in ipairs(Prefabs.all) do
            UiText(prefabObject.title)
            UiTranslate(0, 24)
        end

    UiPop()
end
