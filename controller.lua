rednet.open("top")

function Update()
    local newest_controler = http.get("https://raw.githubusercontent.com/JKincorperated/Tekkit2-Computercraft-Space-Station/main/controller.lua").readAll()
    local index = http.get("https://raw.githubusercontent.com/JKincorperated/Tekkit2-Computercraft-Space-Station/main/index.lua").readAll()
    fs.open("index.lua", "w").write(index)
    local index = require("index")
    local updates = index.updates
end