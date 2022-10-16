rednet.open("top")
os.loadAPI("json")


function Update()
    local newest_controller = http.get("https://raw.githubusercontent.com/JKincorperated/Tekkit2-Computercraft-Space-Station/main/controller.lua").readAll()
    local updates = http.get("https://raw.githubusercontent.com/JKincorperated/Tekkit2-Computercraft-Space-Station/main/updates.json").readAll()
    updates = json.decode(updates)
    for _, value in ipairs(updates) do
        rednet.send(value["id"], "UPDATE-PRIME", "updates")
        --value["link"]
    end
    sleep(60)
    for _, value in ipairs(updates) do
        rednet.send(value["id"], "UPDATE-START", "updates")
        --value["link"]
    end
    for _, value in ipairs(updates) do
        rednet.send(value["id"], "UPDATE-DOWNLOAD", "updates")
        
        local patch = http.get(value["link"]).readAll()

        rednet.send(value["id"], patch, "updates")
        
        rednet.send(value["id"], "UPDATE-RESTART", "updates")

        os.reboot()
    end
end

Update()