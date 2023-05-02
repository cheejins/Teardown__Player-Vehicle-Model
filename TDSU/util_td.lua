_Entity_Transform_Functions_Get = {
    ["shape"]     = _G["GetShapeWorldTransform"],
    ["body"]      = _G["GetBodyTransform"],
    ["light"]     = _G["GetLightTransform"],
    ["vehicle"]   = _G["GetVehicleTransform"],
    ["location"]  = _G["GetLocationTransform"],
    ["trigger"]   = _G["GetTriggerTransform"],
}

_Entity_Transform_Functions_Set = {
    ["shape"]     = _G["SetShapeWorldTransform"],
    ["body"]      = _G["SetBodyTransform"],
    ["light"]     = _G["SetLightTransform"],
    ["vehicle"]   = _G["SetVehicleTransform"],
    ["location"]  = _G["SetLocationTransform"],
    ["trigger"]   = _G["SetTriggerTransform"],
}


--[[TIMERS]]
do

    function TimerCreateSeconds(seconds, zeroStart)

        local timer = { rpm = seconds }

        if zeroStart then timer.time = 0 else timer.time = seconds end

        return timer

    end

    function TimerCreateRPM(rpm, zeroStart)

        local timer = { rpm = rpm }

        if zeroStart then timer.time = 0 else timer.time = 60 / rpm end

        return timer

    end

    ---Run a timer and a table of functions.
    ---@param timer table -- = {time, rpm}
    ---@param funcs_and_args table -- Table of functions that are called when time = 0. functions = {{func = func, args = {args}}}
    ---@param runTime boolean -- Decrement time when calling this function.
    function TimerRunTimer(timer, funcs_and_args, runTime)
        if timer.time <= 0 then
            TimerResetTime(timer)

            for i = 1, #funcs_and_args do
                funcs_and_args[i]()
            end

        elseif runTime then
            TimerRunTime(timer)
        end
    end

    -- Only runs the timer countdown if there is time left.
    function TimerRunTime(timer, stopPoint)
        if timer.time > (stopPoint or 0) then
            timer.time = timer.time - GetTimeStep()
        end
    end

    -- Set time left to 0.
    function TimerEndTime(timer)
        timer.time = 0
    end

    -- Reset time to start (60/rpm).
    function TimerResetTime(timer)
        timer.time = timer.rpm
    end

    function TimerConsumed(timer)
        return timer.time <= 0
    end

end


-- function CheckExplosions(cmd)

--     words = splitString(cmd, " ")
--     if #words == 5 then
--         if words[1] == "explosion" then

--             local strength = tonumber(words[2])
--             local x = tonumber(words[3])
--             local y = tonumber(words[4])
--             local z = tonumber(words[5])

--             -- DebugPrint('explosion: ')
--             -- DebugPrint('strength: ' .. strength)
--             -- DebugPrint('x: ' .. x)
--             -- DebugPrint('y: ' .. y)
--             -- DebugPrint('z: ' .. z)
--             -- DebugPrint('')

--         end
--     end

--     if #words == 8 then
--         if words[1] == "shot" then

--             local strength = tonumber(words[2])
--             local x = tonumber(words[3])
--             local y = tonumber(words[4])
--             local z = tonumber(words[5])
--             local dx = tonumber(words[6])
--             local dy = tonumber(words[7])
--             local dz = tonumber(words[8])

--             -- DebugPrint('shot: ')
--             -- DebugPrint('strength: ' .. strength)
--             -- DebugPrint('x: ' .. x)
--             -- DebugPrint('y: ' .. y)
--             -- DebugPrint('z: ' .. z)
--             -- DebugPrint('dx: ' .. dx)
--             -- DebugPrint('dy: ' .. dy)
--             -- DebugPrint('dz: ' .. dz)
--             -- DebugPrint('')

--         end
--     end

-- end


-- function AimSteerVehicle()

--     local v = GetPlayerVehicle()
--     if v ~= 0 then AimSteerVehicle(v) end

--     local vTr = GetVehicleTransform(v)
--     local camFwd = TransformToParentPoint(GetCameraTransform(), Vec(0, 0, -1))

--     local pos = TransformToLocalPoint(vTr, camFwd)
--     local steer = pos[1] / 10

--     DriveVehicle(v, 0, steer, false)

-- end


-- Find entities of a specific type (shape, body etc...) with the relevant id tag.
function MatchEntityIds(entity_table, tag_id, id)

    local e = {}

    for _, entity in ipairs(entity_table) do

        -- Check if the entity tag value has the correct id
        if GetTagValue(entity, tag_id) == id then
            table.insert(e, entity)
        end

    end

    if #e >= 1 then
        return e
    end

end


-- Check if the entity tag value has the correct id
function ExtractAllEntitiesByTag(entities, tag)

    local e = {}

    for _, entity in ipairs(entities) do
        if HasTag(entity, tag) then
            table.insert(e, entity)
        end
    end

    if #e >= 1 then
        return e
    end

end

-- Check if the entity tag value has the correct id
function ExtractEntityByTag(entities, tag)

    for _, entity in ipairs(entities) do
        if HasTag(entity, tag) then
            return entity
        end
    end

    print("Entity: " .. tag .. " not found.")

end

---Automatically matches the entity type and returns
---@param entity any
---@return table transform
---@return string entity_type
function GetEntityTransform(entity)

    local entity_type = GetEntityType(entity)

    if _Entity_Transform_Functions_Get[entity_type] then
        return _Entity_Transform_Functions_Get[entity_type](entity), entity_type
    else
        print("ERROR: GetEntityTransform()", "No entity type match found: " .. entity_type)
    end

end

---Automatically matches the entity type and sets the transform
---@param entity any
function SetEntityTransform(entity, tr)

    local entity_type = GetEntityType(entity)

    if _Entity_Transform_Functions_Set[entity_type] then
        _Entity_Transform_Functions_Set[entity_type](entity, tr)
    else
        print("ERROR: SetEntityTransform()", "No entity type match found: " .. entity_type)
    end

end
