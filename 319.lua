rednet.open("top")

local program = coroutine.create(function ()
    while true do
        print("Hi")
        sleep(1)
    end
end)

	
coroutine.resume(program)
sleep(10)
coroutine.yeild(program)

while true do
    local message = rednet.receive("updates")
    
end