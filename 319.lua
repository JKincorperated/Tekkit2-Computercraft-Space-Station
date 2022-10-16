rednet.open("top")

local args = {...}

if args[1] == "code" then
    while true do
        print("Hello World!")
        sleep(1)
    end
    
else
    if fs.open("prime", "r").read() ~= "true" then
        shell.openTab("319.lua", "code")
    end
    
    while true do
        local message = rednet.receive("updates")
        if message == "UPDATE-PRIME" then
            fs.open("prime", "w").write("true")
            os.reboot()
        end
        
    end
end