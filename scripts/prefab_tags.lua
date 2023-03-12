RootPath = "MOD/main/Gore Ragdolls 2/" --- Path to the root ragdoll prefabs folder.



--[[

    > Database
        > Parses date from all prefab objects and creates a global database that is used for querying.
        - databse
            - tags

    > Prefab
        - path: full path
        - data: query data
            - pack
            - tags
                - all
                - groups

    > Common
        - tags
            all
            groups

    > Requirements
        - Sorting

]]



function init_prefab_tags()

    -- Paths are stored in each prefab.
    Folders = {
        Agro            = "Agro pack/",
        Avertnus        = "Avertnus's ragdoll pack/",
        Darren          = "Darren's ragdoll pack/",
        FoxyPlayzYT     = "FoxyPlayzYT's ragdoll pack/",
        idixticlol      = "idixticlol's ragdoll pack/",
        Jacob           = "Jacob's ragdoll pack/",
        Morvex          = "Morvex's ragdoll pack/",
        OffensivePDF    = "OffensivePDF's ragdoll pack/",
        Sitters         = "Sitters/",
        Snakey          = "SnakeyWakey's ragdoll pack/",
        Squareblock     = "Squareblock's ragdoll pack/",
    }


    Tags = {

        --- Loose tags that can be applied to any prefab.
        Common = {
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
            youtuber        = tag_create("youtuber",        "Youtubers"),
        },

        -- Game specific tags.
        Games = {
            halfLife        = tag_create("halfLife",        "Half Life"),
            tombRaider      = tag_create("tombRaider",      "Tomb Raider"),
        },

        -- TV and Movies specific tags.
        TV = {
            breakingBad     = tag_create("breakingBad",     "Breaking Bad"),
        },

    }


    --- Tags with a common parent. Used for querying only.
    TagGroups = {
        creators   = { Tags.Common.dev, Tags.Common.modder, Tags.Common.youtuber },
        combatives = { Tags.Common.military, Tags.Common.militia, Tags.Common.police },
    }

end


--- Organizes prefab objects into a searchable database.
function init_prefab_database()

    Prefabs = {}


    -- Simple list of all prefab objects.
    Prefabs.all = {}
    for key, prefabObject in pairs(PrefabObjects) do
        table.insert(Prefabs.all, prefabObject)
    end


    -- A table for each tag which holds all relevant prefabObjects.
    Prefabs.tags = {}
    for _, prefabObject in ipairs(PrefabObjects) do -- Objects returned by prefab_create()
        for _, tag in ipairs(prefabObject.tags) do

            table.insert(Prefabs.tags, tag, prefabObject)

        end
    end


    -- Prefabs.groups = {}
    -- for key, tags in pairs(TagGroups) do
    -- end

    PrintTable(Prefabs.tags, 2)

end
