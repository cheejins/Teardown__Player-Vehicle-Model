#include "../TDSU/tdsu.lua"

--================================================================
-- This script prints the transform values of a ragdoll prefab.
--================================================================


local part_tags = {
    "Head",
    "Torso",
    "LARM",
    "LLARM",
    "LLEG",
    "LLLEG",
    "RARM",
    "RLEG",
    "RRARM",
    "RRLEG",
}

function init()

    -- Everything stays relative to the head. Head stays at vehicle driver pos.
    local head = FindBody("Head")
    if IsHandleValid(head) and head ~= 0 then
        print("Head: found")
    end

    local head_tr = GetBodyTransform(head)
    local min, max = GetBodyBounds(head)
    local head_center_pos = VecLerp(min, max, 0.5)
    local head_center_tr = Transform(head_center_pos, head_tr.rot)

    for _, body in ipairs(FindBodies("", false)) do
        for _, part_tag in ipairs(part_tags) do

            SetBodyDynamic(body, false)

            if HasTag(body, part_tag) then

                local bodyTr = TransformToLocalTransform(head_tr, GetBodyTransform(body))
                local p = bodyTr.pos
                local r = bodyTr.rot

                local pos_string = "Vec(" .. Sub(p[1]) .. ", " .. Sub(p[2]) .. ", " .. Sub(p[3]) .. ")"
                local quat_string = "Quat(" .. Sub(r[1]) .. ", " .. Sub(r[2]) .. ", " .. Sub(r[3]) .. ", " .. Sub(r[4]) .. ")"
                local transform_string = "Transform(" .. pos_string .. ", " .. quat_string .. ")"

                print(part_tag, " = ",  transform_string .. ",")

                break

            end
        end

    end

end

function Sub(s)
    return s
end
