function draw()

    UiTranslate(UiCenter(), UiMiddle())
    UiAlign("center middle")
    UiColor(1, 1, 1, 1)
    UiFont("bold.ttf", 24)

    if UiTextButton("Load Viewer Map", 300, 30) then
        StartLevel("", "MOD/map_viewer.xml", "")
    end

end
