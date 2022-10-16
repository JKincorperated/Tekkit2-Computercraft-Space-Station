rednet.open("top")



while true do
    local message = rednet.receive("updates")
    print(message)
    
end