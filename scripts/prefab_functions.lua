--[[
    Settings
        bool: turn head
        bool: steer
        bool: first person view body
        bool: first person hide head
]]


Tags = {
    military = tag_create("military", "Military"),
    youtuber = tag_create("youtuber", "Youtuber"),
}


function tag_create(key, title)
    return {
        key   = key,
        title = title,
    }
end


function prefab_create(folder, file, title, tags)

end
