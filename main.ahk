#SingleInstance Force
SetWorkingDir A_ScriptDir
CoordMode "Mouse", "Screen"

; Configure for smoother mouse movement
SetDefaultMouseSpeed 2

; Coordinates for buttons
BetAllX := 76
BetAllY := 353
HalfX := 117
HalfY := 285
MaxBallsX := 69
MaxBallsY := 316
RollX := 115
RollY := 408

; Function to add random small variation to coordinates
RandomMove(baseX, baseY) {
    offsetX := 0
    offsetY := 0
    MouseMove baseX + offsetX, baseY + offsetY
}

; Function to add random delay
RandomDelay(baseDelay := 500) {
    extraDelay := Random(0, 200)
    Sleep baseDelay + extraDelay
}

; Function to activate Roblox window
ActivateRoblox() {
    if (WinExist("ahk_exe RobloxPlayerBeta.exe")) {
        WinActivate
        Sleep 100  ; Give window time to activate
        return true
    }
    return false
}

; Main loop - Press F1 to start, F2 to stop
F1::{
    MsgBox "Bot starting! Press F2 to stop."
    loop {
        ; Check if window exists and activate it
        if (!ActivateRoblox()) {
            MsgBox "Roblox window not found!"
            break
        }

        ; Click Bet All
        RandomMove(BetAllX, BetAllY)
        Click
        RandomDelay()

        ; Click Half 6 times
        loop 6 {
            RandomMove(HalfX, HalfY)
            Click
            RandomDelay()
        }

        ; Click Max Balls
        RandomMove(MaxBallsX, MaxBallsY)
        Click
        RandomDelay()

        ; Click Roll
        RandomMove(RollX, RollY)
        Click

        ; Wait for game completion (16-18 seconds)
        waitTime := Random(16000, 18000)
        Sleep waitTime

        ; Check for F2 press
        if GetKeyState("F2") {
            break
        }
    }
}

F2::{
    MsgBox "Bot stopped!"
    Reload
}

Escape::{
    ExitApp  ; Emergency stop
}
