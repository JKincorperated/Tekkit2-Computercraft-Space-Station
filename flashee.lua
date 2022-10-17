rednet.open("top")

local id = os.getComputerID()

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