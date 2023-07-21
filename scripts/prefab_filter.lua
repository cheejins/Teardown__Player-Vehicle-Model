QueryTags = {} --- Pairs table. Each key corresponds to a tag string.
QueryResults = {} --- ipairs table of all relevant prefabs.

DidFilter = false

-- Creates a new table of results based on the search.
function filter_update()

    QueryResults = {}

    for key, tag in pairs(QueryTags) do
        for index, prefab in pairs(Prefabs.tags[tag]) do -- Adds all tags to the result.
            TableInsertUnique(QueryResults, prefab)
        end
    end

    DidFilter = true

end
