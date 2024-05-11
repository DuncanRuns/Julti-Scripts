-- hotkey-context=script-only

if not julti.scriptExists("Benchmark Until Warm") then
    julti.showMessageBox("This script requires the \"Benchmark Until Warm\" script!")
    return
end

julti.log("Making sure all instances are open...")
julti.clearWorlds()

julti.launchAllInstances()
for i = 1, julti.getInstanceCount() do
    julti.waitForInstanceLaunch(i)
end

julti.log("Waiting 15 seconds for title screen and OBS...")
julti.focusWall()
julti.sleep(5000)
julti.focusWall()
julti.sleep(5000)
julti.focusWall()
julti.sleep(5000)
julti.focusWall()

julti.resetAllInstances()
julti.sleep(2000)
julti.lockAllInstances()

julti.waitForAllInstancesLoad()

julti.log("Activating all instances to remove mouse jank and starting lag...")
for i = 1, julti.getInstanceCount() do
    julti.activateInstance(i, true)
    julti.pressEscOnInstance(i)
    julti.sleep(5000)
end

julti.runScript("Benchmark Until Warm")
