rednet.open("top")

local args = {...}

local id = os.getComputerID()

redstone.setOutput("bottom", false)

term.setCursorPos(0,0)

print(" --- System Online --- ")

local mon = peripheral.find("monitor")

if args[1] == "code" then
    while true do
        mon.clear()
        mon.setTextColor(colors.white)
        mon.setBackgroundColor(colors.gray)
        mon.setCursorPos(1,1)
        mon.write("-- Mainframe Issued Update --")
        mon.setCursorPos(1,15)
        mon.write("   Awaiting Update Package")
        sleep(1)
    end    
else

    if fs.open("prime", "r") == nil or fs.open("prime", "r").read(5) ~= "true" then
        shell.openTab(id .. ".lua", "code")
    else
        print(" ---- Computer " .. id .. " Primed For Update ---- ")
        mon.clear()
        mon.setTextColor(colors.white)
        mon.setBackgroundColor(colors.gray)
        mon.setCursorPos(1,1)
        mon.write("-- Mainframe Issued Update --")
        mon.setCursorPos(1,15)
        mon.write("   Awaiting Update Package")
    end
    
    while true do
        local _, message = rednet.receive()
        if message == "UPDATE-PRIME" then
            fs.open("prime", "w").write("true")
            os.reboot()
        end
        if message == "UPDATE-STARTUP" then
            mon.setCursorPos(1,15)
            mon.write("      Upgrading BIOS      ")
            print("Updating Startup Files...")
            local _, patch = rednet.receive()
            fs.delete("startup.lua")
            fs.open("startup.lua", "w").write(patch)
            print("Success")
            mon.setCursorPos(1,15)
            mon.write("      Upgraded BIOS      ")
        end

        if message == "UPDATE-DOWNLOAD" then
            mon.setCursorPos(1,15)
            mon.write("     Upgrading System     ")
            print("Updating System Files...")
            local _, patch = rednet.receive()
            fs.delete(id .. ".lua")
            fs.open(id .. ".lua", "w").write(patch)
            print("Success")
            mon.setCursorPos(1,15)
            mon.write("     Upgraded System     ")
        end

        if message == "UPDATE-COMPLETE" then
            print("Update Complete")
            mon.setCursorPos(1,15)
            mon.write("     Upgrade Complete     ")
        end

        if message == "UPDATE-RESTART" then
            print("Rebooting...")
            fs.open("prime", "w").write()
            os.reboot()
        end
    end
end