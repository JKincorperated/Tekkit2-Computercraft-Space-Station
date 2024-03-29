local args = { ... }

local id = os.getComputerID()


print(" --- System Online --- ")

if args[1] == "code" then



    rednet.open("bottom")

    local m = peripheral.wrap("right")
    m.setTextScale(0.5)
    m.clear()

    local w, h = m.getSize()
    local isActive = false
    local euStored = 0
    local euCapacity = 0
    local heat = 0
    local heatMax = 0
    local euOutput = 0
    local autoShutoff = 0
    local lastAutoShutoff = 0
    local autoShutoffBar = "[                                 ]"
    local autoShutoffBarLength = 33
    local autoShutoffBarPercentPerChar = autoShutoffBarLength / 100.0
    local relayID = 18
    local sentOffSignal = false

    function DrawInfoBox()
        term.redirect(m)
        paintutils.drawLine(3, 3, 4, 3, colors.white)
        paintutils.drawLine(11, 3, ((w / 5) * 3) - 2, 3, colors.white)
        paintutils.drawLine(3, 3, 3, h - 2, colors.white)
        paintutils.drawLine(3, h - 2, ((w / 5) * 3) - 2, h - 2, colors.white)
        paintutils.drawLine(((w / 5) * 3) - 2, 3, ((w / 5) * 3) - 2, h - 2, colors.white)
        m.setBackgroundColor(colors.black)
        m.setCursorPos(6, 3)
        m.write("INFO")
    end

    function DrawControlsBox()
        term.redirect(m)
        paintutils.drawLine(((w / 5) * 3), 3, ((w / 5) * 3) + 1, 3, colors.white)
        paintutils.drawLine(((w / 5) * 3), 3, ((w / 5) * 3), ((h / 5) * 3) - 2, colors.white)
        paintutils.drawLine(((w / 5) * 3), ((h / 5) * 3) - 2, w - 2, ((h / 5) * 3) - 2, colors.white)
        paintutils.drawLine(((w / 5) * 3) + 12, 3, w - 2, 3, colors.white)
        paintutils.drawLine(w - 2, 3, w - 2, ((h / 5) * 3) - 2, colors.white)
        m.setBackgroundColor(colors.black)
        m.setCursorPos(((w / 5) * 3) + 3, 3)
        m.write("CONTROLS")
    end

    function DrawStatsBox()
        term.redirect(m)
        paintutils.drawLine(((w / 5) * 3), ((h / 5) * 3), ((w / 5) * 3) + 1, ((h / 5) * 3), colors.white)
        paintutils.drawLine(((w / 5) * 3) + 9, ((h / 5) * 3), w - 2, ((h / 5) * 3), colors.white)
        paintutils.drawLine(((w / 5) * 3), ((h / 5) * 3), (w / 5) * 3, 35, colors.white)
        paintutils.drawLine(((w / 5) * 3), h - 2, w - 2, h - 2, colors.white)
        paintutils.drawLine(w - 2, ((h / 5) * 3), w - 2, h - 2, colors.white)
        m.setBackgroundColor(colors.black)
        m.setCursorPos(((w / 5) * 3) + 3, ((h / 5) * 3))
        m.write("STATS")
        m.setCursorPos(4, 4)
    end

    local onButtonX = ((w / 5) * 3) + 2
    local onButtonY = 5
    local onButtonXX = w - (((w - 2) - ((w / 5) * 3)) / 2) - 3
    local onButtonYY = 7

    function DrawOnButton()
        term.redirect(m)
        local x = ((w / 5) * 3) + 2
        local y = 5
        local xx = w - (((w - 2) - ((w / 5) * 3)) / 2) - 3
        local yy = 7
        local color = 0
        if isActive then
            color = colors.green
        else
            color = colors.red
        end
        paintutils.drawFilledBox(onButtonX, onButtonY, onButtonXX, onButtonYY, color)
        m.setTextColor(colors.white)
        m.setCursorPos(onButtonX + 8, onButtonY + 1)
        m.write("ON")
        m.setBackgroundColor(colors.black)
    end

    local offButtonX = ((w / 5) * 3) + (((w - 2) - ((w / 5) * 3)) / 2) + 1
    local offButtonY = 5
    local offButtonXX = w - 4
    local offButtonYY = 7

    function DrawOffButton()
        term.redirect(m)
        color = 0
        if isActive then
            color = colors.red
        else
            color = colors.green
        end
        paintutils.drawFilledBox(offButtonX, offButtonY, offButtonXX, offButtonYY, color)
        m.setTextColor(colors.white)
        m.setCursorPos(offButtonX + 7, offButtonY + 1)
        m.write("OFF")
        m.setBackgroundColor(colors.black)
    end

    function DrawStats()
        term.redirect(m)
        local x = ((w / 5) * 3) + 2
        local y = ((h / 5) * 3) + 2
        m.setCursorPos(x, y)
        m.write("ENERGY OUTPUT:      " .. euOutput)
        m.setCursorPos(x + 31, y)
        m.write("EU/t")
        m.setCursorPos(x, y + 3)
        m.write("ENERGY STORED: " .. euStored .. "/" .. euCapacity .. "")
        m.setCursorPos(x + 33, y + 3)
        m.write("EU")
        m.setCursorPos(x, y + 6)
        m.write("HEAT         :      " .. heat)
        m.setCursorPos(x + 33, y + 6)
        m.write("hU")
        m.setCursorPos(x, y + 9)
        m.write("MAX HEAT     :      " .. heatMax)
        m.setCursorPos(x + 33, y + 9)
        m.write("hU")
    end

    function DrawHeatBar()
        term.redirect(m)
        local x = 5
        local y = 6
        local xx = ((w / 5) * 3) - 4
        local yy = 12
        local barLength = 51.0;
        m.setCursorPos(x, y - 1)
        m.setBackgroundColor(colors.black)
        m.write("HEAT / MAX")

        paintutils.drawFilledBox(x, y, xx, yy, colors.lightGray)

        if heat > 0 and heatMax > 0 then
            pixelsPerHeatUnit = barLength / heatMax;
            progressX = math.ceil(pixelsPerHeatUnit * heat)
            paintutils.drawFilledBox(x, y, x + progressX, yy, colors.green)
        end

        m.setBackgroundColor(colors.black)
    end

    function DrawEUOutputBar()
        term.redirect(m)
        local x = 5
        local y = 16
        local xx = ((w / 5) * 3) - 4
        local yy = 22
        local barLength = 51.0
        pixelsPerEU = barLength / 2048.0
        m.setCursorPos(x, y - 1)

        m.setBackgroundColor(colors.black)
        m.write("EU OUTPUT / TICK")

        paintutils.drawFilledBox(x, y, xx, yy, colors.lightGray)
        if euOutput > 0 then
            progressX = math.ceil(euOutput * pixelsPerEU)
            paintutils.drawFilledBox(x, y, x + progressX, yy, colors.green)
        end

        m.setBackgroundColor(colors.black)
    end

    function DrawEUProgressBar()
        term.redirect(m)
        local x = 5
        local y = 27
        local xx = ((w / 5) * 3) - 4
        local yy = 33
        local barLength = 51.0
        m.setCursorPos(x, y - 1)

        m.setBackgroundColor(colors.black)
        m.write("EU STORED / CAPACITY")

        paintutils.drawFilledBox(x, y, xx, yy, colors.lightGray)
        if euStored > 0 and euCapacity > 0 then
            pixelsPerEU = barLength / euCapacity
            progressX = math.ceil(euStored * pixelsPerEU)
            paintutils.drawFilledBox(x, y, x + progressX, yy, colors.green)
        end
        m.setBackgroundColor(colors.black)
    end

    local shutoffButtonY, shutoffButtonYY = 0, 0
    local minusTenX, minusTenXX = 0, 0
    local minusFiveX, minusFiveXX = 0, 0
    local plusFiveX, plusFiveXX = 0, 0
    local plusTenX, plusTenXX = 0, 0

    function DrawAutoShutoff()
        local x = ((w / 5) * 3) + (((w - 2) - ((w / 5) * 3)) / 4) + 4
        local y = 11
        local xx = w - (((w - 2) - ((w / 5) * 3)) / 2) - 13
        local yy = 13

        m.setCursorPos(x, y - 2)
        m.setBackgroundColor(colors.black)
        m.write("AUTO-SHUTOFF")
        x = ((w / 5) * 3) + 3

        shutoffButtonY = y
        shutoffButtonYY = yy
        minusTenX = x
        minusTenXX = xx
        minusFiveX = xx + 4
        minusFiveXX = xx + (xx - x) + 4
        plusFiveX = xx + (xx - x) + 8
        plusFiveXX = xx + ((xx - x) * 3) + 3
        plusTenX = xx + ((xx - x) * 3) + 7
        plusTenXX = xx + ((xx - x) * 5) + 2

        paintutils.drawFilledBox(minusTenX, shutoffButtonY, minusTenXX, shutoffButtonYY, colors.purple)
        m.setCursorPos(minusTenX + 1, shutoffButtonY + 1)
        m.write("-10%")

        paintutils.drawFilledBox(minusFiveX, shutoffButtonY, minusFiveXX, shutoffButtonYY, colors.purple)
        m.setCursorPos(minusFiveX + 1, shutoffButtonY + 1)
        m.write("-5%")

        paintutils.drawFilledBox(plusFiveX, shutoffButtonY, plusFiveXX, shutoffButtonYY, colors.purple)
        m.setCursorPos(plusFiveX + 1, shutoffButtonY + 1)
        m.write("+5%")

        paintutils.drawFilledBox(plusTenX, shutoffButtonY, plusTenXX, shutoffButtonYY, colors.purple)
        m.setCursorPos(plusTenX + 1, shutoffButtonY + 1)
        m.write("+10%")

        m.setBackgroundColor(colors.black)
        m.setCursorPos(minusFiveXX + 1, shutoffButtonYY + 3)
        m.write(autoShutoff .. " %")

        HandleAutoShutoffProgressBar()
        m.setCursorPos(x - 1, shutoffButtonYY + 4)
        m.write(autoShutoffBar)
    end

    function HandleAutoShutoffProgressBar()
        if lastAutoShutoff ~= autoShutoff then
            local progress = math.ceil(autoShutoffBarPercentPerChar * autoShutoff) + 1
            local newBar = ""
            local toConcat


            for i = 1, autoShutoffBarLength + 2 do
                if i == 1 then
                    toConcat = '['
                elseif i <= progress then
                    toConcat = '-'
                elseif i == autoShutoffBarLength + 2 then
                    toConcat = ']'
                else
                    toConcat = ' '
                end

                newBar = (newBar .. toConcat)
            end

            autoShutoffBar = newBar
        end
    end

    function HandleTouch()
        while true do
            local _, _, x, y = os.pullEvent("monitor_touch")
            m.setCursorPos(4, 4)
            if x >= onButtonX and x <= onButtonXX and y >= onButtonY and y <= onButtonYY then
                rednet.send(relayID, "<on>")
            elseif x >= offButtonX and x <= offButtonXX and y >= offButtonY and y <= offButtonYY then
                rednet.send(relayID, "<off>")
            elseif x >= minusTenX and x <= minusTenXX and y >= shutoffButtonY and y <= shutoffButtonYY then
                if autoShutoff - 10 < 0 then autoShutoff = 0
                else autoShutoff = autoShutoff - 10 end
            elseif x >= minusFiveX and x <= minusFiveXX and y >= shutoffButtonY and y <= shutoffButtonYY then
                if autoShutoff - 5 < 0 then autoShutoff = 0
                else autoShutoff = autoShutoff - 5 end
            elseif x >= plusFiveX and x <= plusFiveXX and y >= shutoffButtonY and y <= shutoffButtonYY then
                if autoShutoff + 5 > 100 then autoShutoff = 100
                else autoShutoff = autoShutoff + 5 end
            elseif x >= plusTenX and x <= plusTenXX and y >= shutoffButtonY and y <= shutoffButtonYY then
                if autoShutoff + 10 > 100 then autoShutoff = 100
                else autoShutoff = autoShutoff + 10 end
            end
        end
    end

    function AutoShutoff()
        if not isActive then sentOffSignal = false end
        if heat >= ((autoShutoff * 0.01) * heatMax) and isActive and not sentOffSignal then
            rednet.send(relayID, "<off>")
            sentOffSignal = true
        end
    end

    function HandleReceivedData()
        local sender, message = rednet.receive();
        m.clear()

        if string.find(message, "<active>") then
            if string.find(message, "false") then
                isActive = false
            else
                isActive = true
            end
        elseif string.find(message, "<eustored>") then
            euStored = tonumber(tostring(string.gsub(message, "<eustored>", "")))
        elseif string.find(message, "<eucapacity>") then
            euCapacity = tonumber(tostring(string.gsub(message, "<eucapacity>", "")))
        elseif string.find(message, "<euoutput>") then
            euOutput = tonumber(tostring(string.gsub(message, "<euoutput>", "")))
        elseif string.find(message, "<heat>") then
            heat = tonumber(tostring(string.gsub(message, "<heat>", "")))
        elseif string.find(message, "<heatmax>") then
            heatMax = tonumber(tostring(string.gsub(message, "<heatmax>", "")))
        end
    end

    function MainLoop()
        while true do
            parallel.waitForAny(HandleReceivedData, HandleTouch)
            Draw()
            AutoShutoff()
            lastAutoShutoff = autoShutoff
        end
    end

    function Draw()
        DrawInfoBox()
        DrawHeatBar()
        DrawEUOutputBar()
        DrawEUProgressBar()
        DrawControlsBox()
        DrawOnButton()
        DrawOffButton()
        DrawAutoShutoff()
        DrawStatsBox()
        DrawStats()
    end

    Draw()
    MainLoop()
else

    rednet.open("right")

    if fs.open("prime", "r") == nil or fs.open("prime", "r").read(5) ~= "true" then
        shell.openTab(id .. ".lua", "code")
    else
        print(" ---- Computer " .. id .. " Primed For Update ---- ")
    end

    while true do
        local _, message = rednet.receive()
        if message == "UPDATE-PRIME" then
            fs.open("prime", "w").write("true")
            os.reboot()
        end
        if message == "UPDATE-STARTUP" then
            print("Updating Startup Files...")
            local _, patch = rednet.receive()
            fs.delete("startup.lua")
            fs.open("startup.lua", "w").write(patch)
            print("Success")
        end

        if message == "UPDATE-DOWNLOAD" then
            print("Updating System Files...")
            local _, patch = rednet.receive()
            fs.delete(id .. ".lua")
            fs.open(id .. ".lua", "w").write(patch)
            print("Success")
        end

        if message == "UPDATE-COMPLETE" then
            print("Update Complete")
        end

        if message == "UPDATE-RESTART" then
            print("Rebooting...")
            fs.open("prime", "w").write()
            os.reboot()
        end
    end
end
