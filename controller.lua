rednet.open("top")
os.loadAPI("json")

local vericode = require("vericode")

local key = vericode.loadKey("/keys/key.key")

function Update()
    local newest_controller = http.get("https://raw.githubusercontent.com/JKincorperated/Tekkit2-Computercraft-Space-Station/main/controller.lua").readAll()
    local updates = http.get("https://raw.githubusercontent.com/JKincorperated/Tekkit2-Computercraft-Space-Station/main/updates.json").readAll()
    updates = json.decode(updates)
    for _, value in ipairs(updates) do
        vericode.send(value["id"], "UPDATE-PENDING", key, "updates")
        --value["link"]
    end
    sleep(60)
    for _, value in ipairs(updates) do
        vericode.send(value["id"], "UPDATE-START", key, "updates")
        --value["link"]
    end
    for _, value in ipairs(updates) do
        vericode.send(value["id"], "UPDATE-DOWNLOAD", key, "updates")
        
        local patch = http.get(value["link"]).readAll()

        vericode.send(value["id"], patch, key, "updates")
        
        vericode.send(value["id"], "UPDATE-RESTART", key, "updates")

        os.reboot()
    end
end

Update()