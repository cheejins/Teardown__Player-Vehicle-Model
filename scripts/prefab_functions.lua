--[[

    Settings
        bool: turn head
        bool: steer
        bool: first person view body
        bool: first person hide head

    Savegame
        favorites
]]


-- Loose tags that can be applied to any prefab.
Tags = {
    business        = tag_create("business",        "Business"),
    civilian        = tag_create("civilian",        "Civilian"),
    creature        = tag_create("creature",        "Creatures"),
    emt             = tag_create("emt",             "EMT"),
    games           = tag_create("games",           "Games"),
    military        = tag_create("military",        "Military"),
    militia         = tag_create("militia",         "Militia"),
    dev             = tag_create("militia",         "Militia"),
    modder          = tag_create("modder",          "Modders"),
    pilot           = tag_create("pilot",           "Pilots"),
    police          = tag_create("police",          "Police"),
    teardown        = tag_create("teardown",        "Teardown"),
    tv_shows        = tag_create("tv_shows",        "TV Shows"),
    youtuber        = tag_create("youtuber",        "Youtubers"),
}

-- Tags with a common parent.
TagGroups = {
    creators   = { Tags.modder, Tags.dev, Tags.youtuber },
    combatives = { Tags.military, Tags.militia, Tags.police },
}


function tag_create(key, title)
    return {
        key   = key,
        title = title,
    }
end


function prefab_create(folder, file, title, tags)
    return {
        folder  = folder,
        file    = file,
        title   = title,
        tags    = tags,
    }
end
