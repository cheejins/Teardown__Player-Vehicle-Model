QueryTags = {} --- Pairs table. Each key corresponds to a tag string.
QueryResults = {} --- ipairs table of all relevant prefabs.


-- Creates a new table of results based on the search.
function filter_update()

    QueryResults = {}


    local keys = GetTableKeys(Prefabs.tags)
    table.sort(keys)

    for key, tag in ipairs(keys) do
        if QueryTags[key] then -- Checks if query contains specific tag

            for index, prefab in ipairs(Prefabs.tags[tag]) do -- Adds all tags to the result.
                TableInsertUnique(QueryResults, prefab)
            end

        end
    end

end
