QueryTags = {} --- Pairs table. Each key corresponds to a tag string.
QueryResults = {} --- ipairs table of all relevant prefabs.
DidFilter = false

IsFavoritesSelected = false


-- Creates a new table of results based on the search.
function filter_update()

    IsFavoritesSelected = false

    QueryResults = {}

    for key, tag in pairs(QueryTags) do
        for index, prefab in pairs(Prefabs.tags[tag]) do -- Adds all tags to the result.
            TableInsertUnique(QueryResults, prefab)
        end
    end

    DidFilter = true
end

function SelectFavorites()
    IsFavoritesSelected = true

    QueryTags = {}
    QueryResults = {}

    for _, folder in pairs(PrefabObjects) do
        for _, prefab in pairs(folder) do
            if IsFavorite(prefab.path) then
                TableInsertUnique(QueryResults, prefab)
            end
        end
    end

end
