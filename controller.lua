rednet.open("top")

function Update()
    local newest_controler = http.get("https://raw.githubusercontent.com/JKincorperated/Tekkit2-Computercraft-Space-Station/main/controller.lua").readAll()
    local indexs = http.get("https://raw.githubusercontent.com/JKincorperated/Tekkit2-Computercraft-Space-Station/main/index.lua").readAll()
    fs.open("index.lua", "w").write(indexs)
    local indexs2 = os.loadAPI("index")
    local updates = indexs2.updates
    print(updates)
end

Update()