function tag_create(key, title)
    return {
        key   = key,
        title = title,
    }
end


function init_prefab_tags()

    -- Paths are stored in each prefab.
    Folders = {
        Agro            = "Agro pack/",
        Avertnus        = "Avertnus's ragdoll pack/",
        Darren          = "Darren's ragdoll pack/",
        EVGSTORE        = "EVGSTORE's ragdoll pack/",
        FoxyPlayzYT     = "FoxyPlayzYT's ragdoll pack/",
        idixticlol      = "idixticlol's ragdoll pack/",
        Jacob           = "Jacob's ragdoll pack/",
        Morvex          = "Morvex's ragdoll pack/",
        OffensivePDF    = "OffensivePDF's ragdoll pack/",
        Sitters         = "Sitters/",
        Snakey          = "SnakeyWakey's ragdoll pack/",
        Squareblock     = "Squareblock's ragdoll pack/",
    }


    --- Make sure there are no duplicate tag names.
    Tags = {

        --- Loose tags that can be applied to any prefab.
        business        = tag_create("business",        "Business"),
        civilian        = tag_create("civilian",        "Civilian"),
        creature        = tag_create("creature",        "Creatures"),
        emt             = tag_create("emt",             "EMT"),
        military        = tag_create("military",        "Military"),
        militia         = tag_create("militia",         "Militia"),
        dev             = tag_create("dev",             "Dev"),
        modder          = tag_create("modder",          "Modders"),
        pilot           = tag_create("pilot",           "Pilots"),
        police          = tag_create("police",          "Police"),
        teardown        = tag_create("teardown",        "Teardown"),
        tvShows         = tag_create("tvShows",         "TV Shows"),
        youtuber        = tag_create("youtuber",        "Youtubers"),


        --- Game specific tags.
        halfLife        = tag_create("halfLife",        "Half Life"),
        tombRaider      = tag_create("tombRaider",      "Tomb Raider"),


        --- TV and Movies specific tags.
        breakingBad     = tag_create("breakingBad",     "Breaking Bad"),

    }


    --- Tags with a common parent. Used for querying/filtering only.
    TagGroups = {
        creators   = { Tags.dev, Tags.modder, Tags.youtuber },
        combatives = { Tags.military, Tags.militia, Tags.police },
    }

end


--- Organizes prefab objects into a searchable database.
function init_prefab_database()

    Prefabs = {}


    -- Simple array of all prefab objects.
    Prefabs.all = {}
    for index, value in pairs(PrefabObjects) do
        for key, prefabObject in pairs(value) do
            table.insert(Prefabs.all, prefabObject)
        end
    end


    -- A table for each tag which holds all relevant prefabObjects.
    Prefabs.tags = {}
    for _, prefabFolder in pairs(PrefabObjects) do -- Root tables are associated with prefab folders.
        for _, prefabObject in ipairs(prefabFolder) do -- Objects returned by prefab_create()
            for _, tag in ipairs(prefabObject.tags) do

                if not Prefabs.tags[tag.key] then Prefabs.tags[tag.key] = {} end
                table.insert(Prefabs.tags[tag.key], prefabObject)

            end
        end
    end


    -- Corresponds to TagGroups table. I know this is kind of all slow method but the data set is small.
    -- Prefabs.groups = {}
    -- for groupKey, groupTags in pairs(TagGroups) do

    --     Prefabs.groups[groupKey] = {}

    --     for tagKey, tagPrefabs in pairs(Prefabs.tags) do
    --         -- Insert all prefabs of a tag into group
    --         for _, prefab in ipairs(tagPrefabs) do
    --             table.insert(Prefabs.groups[groupKey], prefab)
    --         end
    --     end

    -- end


    -- PrintTable(Prefabs.all, 1)

end
