#Requires AutoHotkey v2.0
#SingleInstance Force
SetWorkingDir(A_ScriptDir)
CoordMode("Mouse", "Client")

; Configure for smoother mouse movement
SetDefaultMouseSpeed(2)

; Coordinates for buttons
BetAllX := 66
BetAllY := 322
HalfX := 115
HalfY := 254
MaxBallsX := 65
MaxBallsY := 286
RollX := 115
RollY := 381
SafeX := 171
SafeY := 256

; Function to add random small variation to coordinates
RandomMove(baseX, baseY) {
    offsetX := Random(-1, 1)
    offsetY := Random(-1, 1)
    MouseMove(baseX + offsetX, baseY + offsetY)
}

; Function to add random delay
RandomDelay(baseDelay := 100) {
    extraDelay := Random(0, 100)
    Sleep(baseDelay + extraDelay)
}

; Function to activate Roblox window
ActivateRoblox() {
    if WinExist("ahk_exe RobloxPlayerBeta.exe") {
        WinActivate()
        Sleep(100)  ; Give window time to activate
        WinWaitActive("ahk_exe RobloxPlayerBeta.exe",, 2)
        if (WinWaitActive() = 0) {  ; Check if activation failed
            MsgBox("Could not activate Roblox window.")
            return false
        }
        return true
    }
    return false
}

; Function to format time in HH:MM:SS format
FormatTime(seconds) {
    hours := Floor(seconds / 3600)
    minutes := Floor(Mod(seconds, 3600) / 60)
    remainingSeconds := Mod(seconds, 60)
    return Format("{:02d}:{:02d}:{:02d}", hours, minutes, remainingSeconds)
}

; Function to perform the rebirth actions
PerformRebirth() {
    ; Press S for 3.3 seconds
    Send("{S down}")
    Sleep(3300)
    Send("{S up}")

    Loop 3 {
        RandomDelay()
    }

    ; Click on the rebirth button
    RandomMove(481, 378)
    Click()
    Click()
    Click()

    RandomDelay()

    Send("{W down}")
    Sleep(3300)
    Send("{W up}")


}

; Main hotkey for starting the bot
F1::StartBot()

; Function to start the bot
StartBot() {
    MsgBox("Bot starting! Press F2 to stop.")
    startTime := A_TickCount  ; Record the start time
    lastRebirthTime := A_TickCount ; Record the last rebirth time

    while (true) {
        ; Check if window exists and activate it
        if (!ActivateRoblox()) {
            MsgBox("Roblox window not found!")
            break
        }

        ; Calculate elapsed time since start and last rebirth
        elapsedTime := (A_TickCount - startTime) // 1000
        elapsedTimeFormatted := FormatTime(elapsedTime)
        timeSinceRebirth := (A_TickCount - lastRebirthTime) // 1000
        timeSinceRebirthFormatted := FormatTime(timeSinceRebirth)

        ; Display the timers in the tray tip
        TrayTip("Time Since Start", elapsedTimeFormatted "`nTime Since Rebirth: " timeSinceRebirthFormatted)

        ; Run the main loop for 10 minutes
        if (elapsedTime < 600) {  ; 10 minutes = 600 seconds
            ; Click Bet All
            RandomMove(BetAllX, BetAllY)
            Click()
            Click()
            Click()

            ; Click Roll
            Loop 3 {
                RandomMove(RollX, RollY)
                Click()
                RandomDelay()
            }

            ; Move Mouse to safety
            RandomMove(SafeX, SafeY)
            RandomMove(SafeX, SafeY)

            ; Wait for game completion
            waitTime := Random(5000,5001)
            Sleep(waitTime)
        } else {
            ; After 10 minutes, perform rebirth actions
            PerformRebirth()

            ; Reset the start time to restart the main loop
            startTime := A_TickCount
            lastRebirthTime := A_TickCount
        }

        ; Check for F2 press to stop
        if GetKeyState("F2", "P") {
            break
        }
    }
}

; Hotkey to stop the bot
F2::StopBot()

; Function to stop the bot
StopBot() {
    MsgBox("Bot stopped!")
    Reload()
}

; Emergency stop
Escape::ExitApp()

F3::PerformRebirth()
