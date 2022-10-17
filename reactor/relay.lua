

local args = { ... }

local id = os.getComputerID()


print(" --- System Online --- ")

if args[1] == "code" then
    local modem = peripheral.wrap("right")
    rednet.open("right")
    
    local monitorID = 15
    local isOn = false
    
    function WaitAndRelay()
        while true do
            local sender, message = rednet.receive()
            
            if string.find(message, "<on>") and isOn == false then
                redstone.setOutput("front", true)
                print("Received On call")
                isOn = true
            elseif string.find(message, "<off>") and isOn == true then
                redstone.setOutput("front", false)
                print("Received Off call")
                isOn = false
            else    
                print(message)
                rednet.send(monitorID, message)
            end
        end
    end
    
    WaitAndRelay()
else

    rednet.open("right")

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
