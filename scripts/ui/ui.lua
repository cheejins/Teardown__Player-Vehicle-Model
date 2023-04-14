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
        draw_debug_prefab_info()
        draw_debug_current_prefab_path()

        if CFG.SPAWN_ALL_PREFABS then
            draw_prefab_positions()
        end
    UiPop()

end


function draw_container(w, h, a)
    UiPush()

        if Ui.interact then UiMakeInteractive() end

        UiColor(0, 0, 0, a or 0.8)
        UiRect(w, h)

    UiPop()
end



