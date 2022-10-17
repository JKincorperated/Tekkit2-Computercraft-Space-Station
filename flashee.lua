rednet.open("top")

local id = os.getComputerID()

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