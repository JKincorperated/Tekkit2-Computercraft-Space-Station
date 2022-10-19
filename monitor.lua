rednet.open("top")

local args = {...}

local id = os.getComputerID()

redstone.setOutput("bottom", false)

term.setCursorPos(0,0)

print(" --- System Online --- ")

local mon = peripheral.find("monitor")

local party = false

local pcolors = {
    2,
    4,
    16,
    32,
    512,
    1024,
    2048,
    8192,
    16384,
}

fs.open("message", "w").write("")

local x = 1

if args[1] == "code" then
    while true do
        sleep(0.25)
        local message = fs.open("message", "r").readAll()

        print(message)


        if party then
            mon.setCursorPos(1,1)
            mon.write("        PARTY TIME       ")
            mon.setCursorPos(1,7)
            mon.write("     THOU SHALL DANCE    ")
            mon.setTextColor(colors.black)
            mon.setBackgroundColor(pcolors[x])

            x = x + 1
            if x == 10 then
                x = 1
            end
        else
            mon.clear()
            mon.setTextColor(colors.white)
            mon.setBackgroundColor(colors.gray)
            mon.setCursorPos(1,1)
            mon.write("-- Mainframe System Status --")
            mon.setCursorPos(1,7)
            mon.write("        System Online        ")
            sleep(1)
        end

        if message == "MONPARTYTIME" then
            party = true
        end

        if message == "MONNOPARTY" then
            party = false
        end
        
    end    
else

    if fs.open("prime", "r") == nil or fs.open("prime", "r").read(5) ~= "true" then
        shell.openTab(id .. ".lua", "code")
    else
        print(" ---- Computer " .. id .. " Primed For Update ---- ")
        mon.clear()
        mon.setTextColor(colors.white)
        mon.setBackgroundColor(colors.gray)
        mon.setCursorPos(1,1)
        mon.write("-- Mainframe Issued Update --")
        mon.setCursorPos(1,7)
        mon.write("   Awaiting Update Package")
    end
    
    while true do
        local _, message = rednet.receive()
        print(message)
        fs.open("message", "w").write(message)
        if message == "UPDATE-PRIME" then
            fs.open("prime", "w").write("true")
            os.reboot()
        end
        if message == "UPDATE-STARTUP" then
            mon.setCursorPos(1,7)
            mon.write("      Upgrading BIOS      ")
            print("Updating Startup Files...")
            local _, patch = rednet.receive()
            fs.delete("startup.lua")
            fs.open("startup.lua", "w").write(patch)
            print("Success")
            mon.setCursorPos(1,7)
            mon.write("      Upgraded BIOS      ")
        end

        if message == "UPDATE-DOWNLOAD" then
            mon.setCursorPos(1,7)
            mon.write("     Upgrading System     ")
            print("Updating System Files...")
            local _, patch = rednet.receive()
            fs.delete(id .. ".lua")
            fs.open(id .. ".lua", "w").write(patch)
            print("Success")
            mon.setCursorPos(1,7)
            mon.write("     Upgraded System     ")
        end

        if message == "UPDATE-COMPLETE" then
            print("Update Complete")
            mon.setCursorPos(1,7)
            mon.write("     Upgrade Complete     ")
        end

        if message == "UPDATE-RESTART" then
            print("Rebooting...")
            fs.open("prime", "w").write()
            os.reboot()
        end
    end
end