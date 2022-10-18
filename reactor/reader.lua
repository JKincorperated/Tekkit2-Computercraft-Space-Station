rednet.open("right")

local args = { ... }

local id = os.getComputerID()


print(" --- System Online --- ")

if args[1] == "code" then
    local reactor = peripheral.wrap("ic2:nuclear reactor_5")
    local wired = peripheral.wrap("left")
    local wireless = peripheral.wrap("top")

    local relayID = 343

    local active, euOutput, heat, heatMax
    local failsafeOn = false

    function OpenWireless()
        rednet.open("top")
        rednet.close("left")
    end

    function OpenWired()
        rednet.open("left")
        rednet.close("top")
    end

    function SendToRelay(msg)
        rednet.send(relayID, msg)
    end

    function MainLoop()
        while true do
            sleep(1)
            OpenWired()
            term.clear()

            active = reactor.isReactorActive()
            euOutput = reactor.getEUOutput() * 5
            heat = reactor.getHeat()
            heatMax = reactor.getMaxHeat()

            OpenWireless()
            SendToRelay("<active>" .. tostring(active))
            SendToRelay("<euoutput>" .. euOutput)
            SendToRelay("<heat>" .. heat)
            SendToRelay("<heatmax>" .. heatMax)
        end
    end

    function FailSafe()
        sleep(5)
        if heat > (heatMax - 900) and failsafeOn == false then
            redstone.setOutput("front", false)
            failsafeOn = true
        end
    end

    redstone.setOutput("front", true)
    MainLoop()
else

    if fs.open("prime", "r") == nil or fs.open("prime", "r").read(5) ~= "true" then
        shell.openTab(id .. ".lua", "code")
    else
        print(" ---- Computer " .. id .. " Primed For Update ---- ")
    end

    while true do
        local _, message = rednet.receive()
        if message == "UPDATE-PRIME" then
            fs.open("prime", "w").write("true")
            os.reboot()
        end
        if message == "UPDATE-STARTUP" then
            print("Updating Startup Files...")
            local _, patch = rednet.receive()
            fs.delete("startup.lua")
            fs.open("startup.lua", "w").write(patch)
            print("Success")
        end

        if message == "UPDATE-DOWNLOAD" then
            print("Updating System Files...")
            local _, patch = rednet.receive()
            fs.delete(id .. ".lua")
            fs.open(id .. ".lua", "w").write(patch)
            print("Success")
        end

        if message == "UPDATE-COMPLETE" then
            print("Update Complete")
        end

        if message == "UPDATE-RESTART" then
            print("Rebooting...")
            fs.open("prime", "w").write()
            os.reboot()
        end
    end
end
