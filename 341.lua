rednet.open("top")

local args = { ... }

local id = os.getComputerID()

redstone.setOutput("back", false)

term.setCursorPos(0, 0)

print(" --- System Online --- ")


--if args[1] == "code" then
--    while true do
--        local _, message = rednet.receive()
--
--    end
--
--else
if fs.open("prime", "r") == nil or fs.open("prime", "r").read(5) ~= "true" then
    redstone.setOutput("bottom", true)
else
    print(" ---- Computer " .. id .. " Primed For Update ---- ")
end

local party = false

while true do
    local _, message = rednet.receive(nil, 0.5)

    if party then
        redstone.setOutput("bottom", redstone.getOutput("bottom") ~= true)
    end

    if message == "UPDATE-PRIME" then
        fs.open("prime", "w").write("true")
        os.reboot()
    end
    if message == "PARTY" then
        party = true
    end
    if message == "NOPARTY" then
        party = false
    end
    if message == "LIGHTS-ON" then
        redstone.setOutput("back", true)
    end
    if message == "LIGHTS-OFF" then
        redstone.setOutput("back", false)
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
--end
