-- hotkey-context=game


local function toNumberOrElse(input, def)
    local out = tonumber(input)
    if out == nil then
        return def
    end
    return out
end

if julti.isCustomizing() then
    local windowSizeAns = julti.askTextBox(
        "Enter a window size:",                                                                 -- Message to user
        julti.getCustomizable("width", "250") .. "x" .. julti.getCustomizable("height", "750"), -- Default value (widthxheight)
        function(input) return nil ~= input:match("^%d+x%d+$") end                              -- Validator function
    )
    if windowSizeAns == nil or windowSizeAns == "" then
        return
    end
    local width, height = windowSizeAns:match("(%d+)x(%d+)")
    julti.setCustomizable("width", tostring(math.min(toNumberOrElse(width, 250), 10000)))
    julti.setCustomizable("height", tostring(math.min(toNumberOrElse(height, 750), 10000)))
    return
end

local width = toNumberOrElse(julti.getCustomizable("width", "250"), 384)
local height = toNumberOrElse(julti.getCustomizable("height", "750"), 16384)
moveresize.toggleResize(julti.getSelectedInstanceNum(), width, height, false)
