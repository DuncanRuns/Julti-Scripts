-- hotkey-context=game
if (julti.getCurrentTime() - julti.getLastActivation(julti.getSelectedInstanceNum()) < 20000) then
    julti.replicateHotkey("reset")
end
