rednet.open("top")

local program = coroutine.create(function ()
    while true do
        print("Hi")
        sleep(1)
    end
end)

program.resume()
sleep(10)
program.yeild()

while true do
    local message = rednet.receive("updates")
    
end