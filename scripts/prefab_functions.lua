--[[

    Settings
        bool: turn head
        bool: steer
        bool: first person view body
        bool: first person hide head

    Savegame
        favorites

]]

function SetRagdoll(prefab)
    DeleteRagdoll()
    InstantiateRagdoll(prefab.path)
end