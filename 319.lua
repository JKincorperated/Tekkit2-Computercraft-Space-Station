rednet.open("top")

local args = {...}

local id = os.getComputerID()

if args[1] == "code" then
    while true do
        print("Hello World!")
        sleep(1)
    end
    
else

    if fs.open("prime", "r") == nil or fs.open("prime", "r").read(5) ~= "true" then
        shell.openTab(id .. ".lua", "code")
    end
    
    while true do
        local _, message = rednet.receive()
        if message == "UPDATE-PRIME" then
            fs.open("prime", "w").write("true")
            os.reboot()
        end

        if message == "UPDATE-STARTUP" then
            local _, patch = rednet.receive()
            fs.delete("startup.lua")
            fs.open("startup.lua", "w").write(patch)
        end

        if message == "UPDATE-DOWNLOAD" then
            local _, patch = rednet.receive()
            fs.delete(id .. ".lua")
            fs.open(id .. ".lua", "w").write(patch)
        end

        if message == "UPDATE-COMPLETE" then
            --pass
            local ob = nil
        end

        if message == "UPDATE-RESTART" then
            fs.open("prime", "w").write()
            os.reboot()
        end
    end
end