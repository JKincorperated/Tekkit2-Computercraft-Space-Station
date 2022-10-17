rednet.open("back")
os.loadAPI("json")

function Update()
    print("Downloading Updates")
    local newest_controller = http.get("https://raw.githubusercontent.com/JKincorperated/Tekkit2-Computercraft-Space-Station/main/controller.lua").readAll()
    local updates = http.get("https://raw.githubusercontent.com/JKincorperated/Tekkit2-Computercraft-Space-Station/main/updates.json").readAll()
    local newstartup = http.get("https://raw.githubusercontent.com/JKincorperated/Tekkit2-Computercraft-Space-Station/main/startup.lua").readAll()
    print("Success")
    print("Updating Mainframe Centeral Software...")
    updates = json.decode(updates)
    fs.delete("controller.lua")
    fs.open("controller.lua", "w").write(newest_controller)
    print("Success")
    for _, value in ipairs(updates) do
        rednet.send(value["id"], "UPDATE-PRIME", "updates")
        --value["link"]
    end
    print("Published Update Status")
    sleep(7.5)
    print("Updating Startup Files")
    for _, value in ipairs(updates) do
        rednet.send(value["id"], "UPDATE-STARTUP", "updates")
        rednet.send(value["id"], newstartup, "updates")
    end
    sleep(2)
    print("Updated Startup Files")
    print("Updating Program Files")
    for _, value in ipairs(updates) do
        rednet.send(value["id"], "UPDATE-DOWNLOAD", "updates")
        
        local patch = http.get(value["link"]).readAll()

        rednet.send(value["id"], patch, "updates")

        rednet.send(value["id"], "UPDATE-COMPLETE", "updates")
    end
    sleep(2)
    print("Updated Program Files")
    for _, value in ipairs(updates) do
        rednet.send(value["id"], "UPDATE-RESTART", "updates")
    end
    os.reboot()
end

sleep(1)

rednet.send(319, "MAINFRAME-LIGHTS-ON")
rednet.send(341, "LIGHTS-ON")

while true do
	term.write(">")
	local command = read()	
    if command == "update" then
        Update()
    elseif command == "shutdown" then
        os.shutdown()
    elseif command == "restart" or command == "reboot" then
        os.reboot()
    elseif command == "all lights off" then
        rednet.send(319, "MAINFRAME-LIGHTS-OFF")
        rednet.send(341, "LIGHTS-OFF")
    elseif command == "all lights on" then
        rednet.send(341, "LIGHTS-ON")
    else do
        print("Unkown command or syntax error")
    end
    end
end


