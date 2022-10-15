rednet.open("top")
os.loadAPI("json")


function Update()
    local newest_controller = http.get("https://raw.githubusercontent.com/JKincorperated/Tekkit2-Computercraft-Space-Station/main/controller.lua").readAll()
    local updates = http.get("https://raw.githubusercontent.com/JKincorperated/Tekkit2-Computercraft-Space-Station/main/updates.json").readAll()
    updates = json.decode(updates)
    for _, value in ipairs(updates) do
        rednet.send(value["id"], "UPDATE-PENDING")
        --value["link"]
    end
    sleep(60)
    for _, value in ipairs(updates) do
        rednet.send(value["id"], "UPDATE-START")
        --value["link"]
    end
    for _, value in ipairs(updates) do
        rednet.send(value["id"], "UPDATE-DOWNLOAD")
        
        local patch = http.get(value["link"]).readAll()

        rednet.send(value["id"], patch)
        
        rednet.send(value["id"], "UPDATE-RESTART")

        os.reboot()
    end
end

Update()