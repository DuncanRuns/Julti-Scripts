-- hotkey-context=script-only

if julti.isCustomizing() then
    local ans = julti.askYesNo("Clear worlds between benchmarks?")
    if ans == true then
        julti.setCustomizable("clearbetween", "t")
    elseif ans == false then
        julti.setCustomizable("clearbetween", "f")
    end
    return
end

julti.focusWall()
julti.clearWorldsAndWait()

local lastRPS = 0.0
local rps = 0.0
repeat
    lastRPS = rps
    benchmark.start(1000)
    benchmark.waitForBenchmarkEnd()
    if julti.getCustomizable("clearbetween", "f") == "t" then
        julti.clearWorldsAndWait()
    end
    julti.waitForAllInstancesLoad()
    rps = benchmark.getLatestRPS()
until rps <= lastRPS
julti.clearWorldsAndWait()

julti.log("Benchmark Until Warm Done")
