-- hotkey-context=game

local function toNumberOrElse(input, def)
    local out = tonumber(input)
    if out == nil then
        return def
    end
    return out
end

-- Support customization with an isCustomizing block
if julti.isCustomizing() then
    local windowSizeAns = julti.askTextBox(
        "Enter a window size:",                                                                   -- Message to user
        julti.getCustomizable("width", "384") .. "x" .. julti.getCustomizable("height", "16384"), -- Default value (widthxheight)
        function(input) return nil ~= input:match("^%d+x%d+$") end                                -- Validator function
    )

    if (windowSizeAns == nil) then
        return -- User pressed cancel so they probably don't wanna do this customization shit anymore :(
    else
        local width, height = windowSizeAns:match("(%d+)x(%d+)")
        julti.setCustomizable("width", tostring(math.min(toNumberOrElse(width, 384), 10000)))
        julti.setCustomizable("height", tostring(math.min(toNumberOrElse(height, 16384), 16384)))
    end

    local eyeSeeAns = julti.askYesNo("Do you want to use an EyeSee window?")

    -- eyeSeeAns could be nil meaning the user doesn't want to change it probably, so check both == true and == false
    if eyeSeeAns == true then
        julti.setCustomizable("useEyeSee", "true")
    elseif eyeSeeAns == false then
        julti.setCustomizable("useEyeSee", "false")
    end

    local cursorAns = julti.askYesNo("Do you want to set cursor speed to 1 when measuring?")
    if cursorAns == true then
        julti.setCustomizable("useCursorSpeed", "true")
    elseif cursorAns == false then
        julti.setCustomizable("useCursorSpeed", "false")
    end

    return -- If this return wasn't here, the script would continue in customization mode leading to an error
end

-- Get values
local width = toNumberOrElse(julti.getCustomizable("width", "384"), 384)
local height = toNumberOrElse(julti.getCustomizable("height", "16384"), 16384)
local useEyeSee = "true" == julti.getCustomizable("useEyeSee", "true")
local useCursorSpeed = "true" == julti.getCustomizable("useCursorSpeed", "true")

-- Customizing does not get here, run regular script

local i = julti.getSelectedInstanceNum()
if i == 0 then
    julti.log("No instance activate, can't run eye measuring script!")
    return
end

if julti.getInstanceState(i) ~= "INWORLD" then
    julti.log("Instance is not in a world, eye measuring script cancelled!")
    return
end

if julti.getInstanceInWorldState(i) == "GAMESCREENOPEN" then
    julti.log("Chat or inventory is open, cancelling eye measuring script!")
    return
end

local stretching = moveresize.toggleResize(i, width, height, useEyeSee)

if useCursorSpeed then
    if stretching then
        local cs = moveresize.getCursorSpeed()
        if cs > 1 then
            julti.setCustomizable("defCursorSpeed", tostring(cs))
        end
        moveresize.setCursorSpeed(1)
    else
        local cs = julti.getCustomizable("defCursorSpeed")
        if cs then
            moveresize.setCursorSpeed(toNumberOrElse(cs, 1))
        else
            julti.log("EYE MEASURE WARNING: No fallback cursor speed found!")
        end
    end
end
