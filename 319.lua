rednet.open("top")

local args = {...}

local id = os.getComputerID()

redstone.setOutput("bottom", false)

term.setCursorPos(0,0)

print(" --- System Online --- ")

if args[1] == "code" then
    while true do
        local _, message = rednet.receive()
        if message == "MAINFRAME-LIGHTS-ON" then
            redstone.setOutput("bottom", true)
        end
        if message == "MAINFRAME-LIGHTS-OFF" then
            redstone.setOutput("bottom", false)
        end
    end
    
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