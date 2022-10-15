rednet.open("top")

Freeze = false

local program = coroutine.create(function ()
    while true do
        if Freeze then
            coroutine.yield()
        end
        print("Hi")
        sleep(1)
    end
end)

	
coroutine.resume(program)
sleep(10)
Freeze = true

while true do
    local message = rednet.receive("updates")
    
end