rednet.open("top")
os.loadAPI("json")


function Update()
    local newest_controller = http.get("https://raw.githubusercontent.com/JKincorperated/Tekkit2-Computercraft-Space-Station/main/controller.lua").readAll()
    local updates = http.get("https://raw.githubusercontent.com/JKincorperated/Tekkit2-Computercraft-Space-Station/main/updates.json").readAll()
    local newstartup = http.get("https://raw.githubusercontent.com/JKincorperated/Tekkit2-Computercraft-Space-Station/main/startup.lua").readAll()
    updates = json.decode(updates)
    print("Downloaded Updates")
    sleep(5)
    for _, value in ipairs(updates) do
        rednet.send(value["id"], "UPDATE-PRIME", "updates")
        --value["link"]
    end
    print("Published Update Status")
    sleep(30)
    print("Updating Startup Files")
    for _, value in ipairs(updates) do
        rednet.send(value["id"], "UPDATE-STARTUP", "updates")
        rednet.send(value["id"], newstartup, "updates")
    end
    sleep(5)
    print("Updated Startup Files")
    print("Updating Program Files")
    for _, value in ipairs(updates) do
        rednet.send(value["id"], "UPDATE-DOWNLOAD", "updates")
        
        local patch = http.get(value["link"]).readAll()

        rednet.send(value["id"], patch, "updates")

        rednet.send(value["id"], "UPDATE-COMPLETE", "updates")
    end
    sleep(5)
    print("Updated Program Files")
    for _, value in ipairs(updates) do
        rednet.send(value["id"], "UPDATE-RESTART", "updates")
    end
    os.reboot()
end

Update()