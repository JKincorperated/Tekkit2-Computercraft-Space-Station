rednet.open("top")
os.loadAPI("json")

function Update()
    local newest_controler = http.get("https://raw.githubusercontent.com/JKincorperated/Tekkit2-Computercraft-Space-Station/main/controller.lua").readAll()
    local updates = http.get("https://raw.githubusercontent.com/JKincorperated/Tekkit2-Computercraft-Space-Station/main/index.lua").readAll()
    updates = json.decode(updates)
    print(updates)
end

Update()