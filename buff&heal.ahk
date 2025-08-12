#NoEnv
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%
#include findtext2.ahk
setbatchlines, 15
SetKeyDelay, 100, 50

; Set proper file encoding to prevent INI corruption
FileEncoding, UTF-8
; Request admin privileges
if not A_IsAdmin
{
    Run *RunAs "%A_ScriptFullPath%"
    ExitApp
}
; ------------------------------------
; Helper to ensure our target game window is active
ActivateGameWindow() {
    global win1
    if (TargetGameWindow) {
        WinActivate, ahk_id %win1%
        Sleep, 30
    }
}
; ------------------------------------
; ========= AutoOracle Variables =========
global HealthPattern := "|<>##000000$0/0/00AA90,1/0/00AA90"
HealthPattern .= "|<>##000000$0/0/42D019"
healthpattern.="|<>##0.90$0/0/51CA2F,0/1/48C723,0/2/42D019,0/3/25A800,0/4/259F00"

global BoundingBoxes := []
global PlayerCoords := []
global PetCoords := []

; Portrait patterns
global magus := "|<>F9FEFA-0.90$18.1zsMDy0Ty3zzC1zE0z04T0AD0MD1kD3UB3UB3U91U930E40U810E00U"
global Corruptor := "|<>502668-0.86$18.U010000003zlTaMxkQ3Dz1zz1xb0vr0wP1NX3rp6Ds7/k5705WV7q3U"
global windixie := "|<>AEAD43-0.69$18.0400A00A00A0UA0sS0sS0kQ1xR1vTHNz7VTDlRDsQTwATsAMwANU"
global gnoll := "|<>887868-0.74$17.uXZk7bE2L0SR1IwBVtHnakj1lT6rsr3lpL/pT+kz5LyHLzITk"
global etherealpixie := "|<>CA4EB0-0.73$18.0400400A00800800+00S00Q04Q12TH0z7UTDUQDsATwATsAMwAMU"
global partywindow := "|<>*142$15.Tzszy80azus0yzvqvSuvrjSuvqvTTrxxymPjjjzzzzw"
global partywindowlogo := "|<>*137$16.TzwTz208rzLU3xzrqvTRRxvrrLTPhyzjxxzNBvvvU"

; Global variables for patterns
global iniFile := A_ScriptDir "\CapturedText.ini"
global patterns := {} ; Store all loaded patterns in this object
global patternKeys := {} ; Store key assignments for each pattern
global patternNames := {} ; Store custom names for each pattern
global patternCounter := 1 ; Counter for automatic pattern naming
global HealerStatusText := ""
global healControlCounter := 1 ; Counter for heal control naming
global TargetGameWindow := "" ; Store target game window ID
global TargetGameTitle := "" ; Store target game window title
global healPriorities := [] ; Array to store heal skill priority order
global healCheckInterval := 30 ; Heal check interval in milliseconds
global healanddps := false
global dpstargetedhealing := false
; Manual healing variables
global PlayerCount := 0
global PetCount := 0
global ManualPlayerCoords := []
global ManualPetCoords := []
global isManualHealingActive := false
; DPS targeted healing variables
global DPSTargetedPlayerCoords := []
global DPSTargetedPetCoords := []
; ========= DPS Variables =========
global dpsPatterns := {} ; Store all DPS patterns
global dpsPatternKeys := {} ; Store key assignments for DPS patterns
global dpsPatternNames := {} ; Store custom names for DPS patterns
global dpsCounter := 1 ; Counter for automatic DPS pattern naming
global dpsPriorities := [] ; Array to store skill priority order
global isDpsRunning := false ; Flag for DPS monitoring
global isSystemBusy := false ; Flag to coordinate between healing/DPS/keypresser

; Define healing skill patterns
global healing := "|<>**50$13.txUTU30CA0A3I68EQ8C6N37Vckk8E"
global restoration := "|<>**50$13.03U000402010DUQEMcSQC2C064XME"
global rapidhealing := "|<>**50$13.Y5C6wCC5i3t38UMEM9d1U000Q1e+E"
global masshealing := "|<>**50$13.R4/07Z3m01CA4C65X2rV5EzsFw83k"
;other globals
global TemplarTargetCount := 1
global TemplarTargetCoords := []
global HolygroundHotkey := ""
global TemplarTargetCountEdit := ""
global HolygroundHotkeyEdit := ""
global RandomXVariation := 5
global RandomYVariation := 5
global MinDelay := 80
global MaxDelay := 150
global activeMonitors := 0
global maxMonitors := 8

; Coordinate variables for checkweight and snapshot (shared coordinates)
global checkweightX1 := 880
global checkweightY1 := 472
global checkweightX2 := 981
global checkweightY2 := 488
; ; Define skill bar search area (bottom portion of screen)
; global SkillBarX1 := 92
; global SkillBarY1 := 594
; global SkillBarX2 := 953
; global SkillBarY2 := 755

; ========= KeyPresser Variables =========
; Global variables
global TargetWindow := ""
global win1 := ""
global SettingsFile := "keypresser_settings.ini"
global SkipInitial1 := false

; Sequence 1 variables
global KeyCombination1 := ""
global KeyDelay1 := 0.1
global TimerInterval1 := 1
global IsRunning1 := false
global KeySequence1 := []
global NextExecutionTime1 := 0

; Sequence 2 variables
global KeyCombination2 := ""
global KeyDelay2 := 0.1
global TimerInterval2 := 2
global IsRunning2 := false
global KeySequence2 := []
global NextExecutionTime2 := 0

; Sequence 3 variables
global KeyCombination3 := ""
global KeyDelay3 := 0.1
global TimerInterval3 := 3
global IsRunning3 := false
global KeySequence3 := []
global NextExecutionTime3 := 0

; GUI control variables
global TargetWindowEdit := ""
global KeyCombinationEdit1 := ""
global KeyDelayEdit1 := ""
global TimerIntervalEdit1 := ""
global KeyCombinationEdit2 := ""
global KeyDelayEdit2 := ""
global TimerIntervalEdit2 := ""
global KeyCombinationEdit3 := ""
global KeyDelayEdit3 := ""
global TimerIntervalEdit3 := ""
global farming := false
global CurrentChar := 1
global selectedChars := []
global launcherstartbutton := "|<>F68800-0.68$111.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzsC00S3s0w00zzzzzzzwqDzxjizUTzvzzzzzzzE50081k0E01Tzzzzzzo0801E60000/zzzzzzw0300c2o0601Tzzzzzzc200006U8003zzzzzzx5V00oEI0000zzzzzzzcHz0SU+UU40zzyDzzzx0Xs3UV411U7zzUzzzzo1D0R50Xkg0zzs7zzzyE2s3c8Y01U7zz0DzzzsUL0M74U0Q0zyU0zzzzl0M300Y03U7zU07zzzkW/0O00UWQ0zk00lzzwlFO2FwI03Ubw0003zzdU+EEE2UFA4z0000Dzs12G2W2405Ubk00033z80KE46FU8Y4w00007zwkAm04uA02Ua000007zkyD00300U400000007zU7w600001k00000003zzzzz0DU3zk0000000Dzzzzs0c0Dk00000000Dzzzy0000M0000000001zzk00000000004"
launcherstartbutton .= "|<>FF7C00-0.68$111.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzvzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzQzz3s0w00zzzzzzzzzzzzzizlTzvzzzzzzzk700w1o0G01Tzzzzzzw0M05E6U0E0/zzzzzzz0300c2o0601TzzzzzzsSgUF0KU8U07zzzzzzz7dg8oEI4001zzmzzzzcTzUSW+UkA1zzs7zzzx1bs3kVI15UDzz0Tzzzo1D0R50Xkg1zzU0zzzyE6s3c8Y01UDzU07zzztUL0N74U3Q1zw00zzzzl1O3E0YM3Ujy007zzztW/EO02UWQ4yU000TzynFO2FwI4/Ubk0001zzda/EEE2UFA4w00007zt32u2W2415Ub00000Hzc0LE40FU8Y4U00000zwkBu0Y2A0WUU000000DlyT000000400000000DU7w600001k00000000zzzzw0000C000000001zzzz00001000004"
global iD := "|<>*93$13.61rSPjZrmvxRyiyLTPj8ES"
global loginbutton := "|<nohighlight>*65$111.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzw0000000000000000zz00000000000000003zs0000000000000000Tz00000000000000003zw0000000000000001zzp000000000000003jzyE000000000000009zzy000000000000001zzzk00000000000040Dzzwzzzzz7Uk03zzzzzzzzzzzzzwsUM3DzzzzzzzzzzzzzbC78tzzzzzzzzzzzzzwtkt7DzzzzzzzzzzzzzbC7+tzzzzzzzzzzzzzwsk1LDzzzzzzzzzzzzzU0k+tzzzzzzzzzzzzzzzzvzzzzzzzzzzzzzzzzzkTzzzzzzzzzzzzzzzzy7zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzw"
loginbutton .= "|<highlight>**50$109.2080000000000001042zzzzzzzzzzzzzzzzx2k0000000000000003FE0000000000000000cc0000000000000000IJ0000000000000000e+300000000000000A54100000s00C0000000W100000Q005000000UEk00000+002U000000s8U000057zzzk00004E4000002X3Vc80000082000001HRipq0000041000000d+JOf0000020W00000IZ2hIU0000F0F00000+Ohqek00008U8k00005xqvJM0000A0080000237Zeg0000400000001zzyzS000000000000000GE00000000000000008s00000000000000007s000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001"
global confirm := "|<>**50$109.0000000000000000001zzzzzzzzzzzzzzzzs1U00000000000000060U00000000000000010E0000000000000000U80000000000000000E000000000000000000000000T007s0000000000000Rs06I0000000000000Mg02u0000000000000PzzzTzzk0000000000Bb7FWeaM00000000006XRirLRo00000000003FvrOfiu00000000001cZ+hJJJ00000000000qyxKeeeU0000000000BxqfJJJE0000000000737Jeeec00000000001zzvxxrQ0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001"
; ========= Initialization =========
; Load saved text patterns when script starts
LoadAllPatterns()
InitializePatternCounter() ; Initialize the counter based on existing patterns
; Load skillbar coordinates
LoadSkillbarCoordinates()
; Load custom names into memory at startup
ReloadCustomNames()

; Load heal priorities and settings
LoadHealPriorities()
LoadHealSettings()

; Load DPS patterns and settings
LoadAllDPSPatterns()
LoadDPSPriorities()
LoadTemplarSettings()
LoadCoordinateSettings()
CoordMode, Pixel, Screen
coordmode, mouse, screen

; Auto-load keypresser settings on startup
Gosub, LoadKeypresserSettings

; Create the combined GUI
Gosub, CreateCombinedGUI
return

CreateCombinedGUI:
; Create main GUI with tabs
    Gui, Add, Tab3, x10 y10 w520 h620 vMainTabs, Setup|Healer|DPS|KeyPresser|Tools|Templar
  ; ===== Setup tab =====
Gui, Tab, Setup
; Window Setup Section
Gui, Add, GroupBox, x20 y40 w470 h90, Game Setup
Gui, Add, Button, x30 y60 w120 h30 gSelectWindow, Select Game Window
Gui, Add, Text, x160 y65 w170 h20 vWindowStatus, No window selected
Gui, Add, Button, x30 y95 w80 h25 gLaunchGame, Launch Game
Gui, Add, Button, x120 y95 w80 h25 gSelectGame, Select Game
Gui, Add, Button, x210 y95 w80 h25 gCharacters, Characters
Gui, Add, Button, x300 y95 w80 h25 gAutoLauncher, Auto Launcher

; Main Controls Section
Gui, Add, GroupBox, x20 y140 w470 h100, Main Controls
Gui, Add, Button, x30 y160 w100 h30 gStartDynamicHealing, Start Healer
Gui, Add, Button, x140 y160 w100 h30 gCancelHealerScript, Stop Healer
Gui, Add, Button, x250 y160 w100 h30 gStartDPSScript, Start DPS
Gui, Add, Button, x360 y160 w100 h30 gStopDPSScript, Stop DPS
Gui, Add, Checkbox, x30 y200 w200 vhealanddps ghealanddps, Enable DPS + Heal Combo
Gui, Add, Checkbox, x250 y200 w200 vdpstargetedhealing gdpstargetedhealing, DPS + Targeted Heal
Gui, Add, Checkbox, x30 y220 w200 vfarming gfarming, Enable Farming Mode

; Memory Monitor Section
Gui, Add, GroupBox, x20 y250 w470 h120, Memory Monitor
Gui, Add, Text, x30 y270 w440 h20, Click buttons 1-8 then left-click to select windows to monitor:
Gui, Add, Button, x30 y290 w25 h25 gMonitorButton, 1
Gui, Add, Button, x60 y290 w25 h25 gMonitorButton, 2
Gui, Add, Button, x90 y290 w25 h25 gMonitorButton, 3
Gui, Add, Button, x120 y290 w25 h25 gMonitorButton, 4
Gui, Add, Button, x150 y290 w25 h25 gMonitorButton, 5
Gui, Add, Button, x180 y290 w25 h25 gMonitorButton, 6
Gui, Add, Button, x210 y290 w25 h25 gMonitorButton, 7
Gui, Add, Button, x240 y290 w25 h25 gMonitorButton, 8
Gui, Add, Button, x30 y320 w100 h25 gclosemonitors, Close Monitors
Gui, Add, Button, x140 y320 w80 h25 gexpmonitor, Exp Monitor
Gui, Add, Button, x230 y320 w90 h25 gRupeemonitor, Rupee Monitor

; Quick Status
Gui, Add, GroupBox, x20 y400 w470 h80, Status
Gui, Add, Text, x30 y420 w450 h50 vMainStatus, Ready - Select game window to begin
; ===== HEALER TAB =====
    Gui, Tab, Healer
    ; Configuration Section
    Gui, Add, GroupBox, x20 y40 w470 h120, Healing Configuration
    Gui, Add, Text, x30 y60 w80 h20, Check Rate (ms):
    Gui, Add, Edit, x120 y60 w60 h20 vHealIntervalInput gValidateHealInterval, %healCheckInterval%
    Gui, Add, Button, x190 y60 w50 h20 gSaveHealInterval, Save
    Gui, Add, Button, x250 y60 w100 h20 gTestPartyDetection, Test Detection
    Gui, Add, Button, x360 y60 w100 h20 gStartDynamicHealing, Auto Healing
    
    ; Manual healing controls
    Gui, Add, Text, x30 y85 w50 h20, Players:
    Gui, Add, Edit, x80 y85 w30 h20 vPlayerCountEdit, 0
    Gui, Add, Text, x120 y85 w30 h20, Pets:
    Gui, Add, Edit, x150 y85 w30 h20 vPetCountEdit, 0
    Gui, Add, Button, x190 y85 w80 h20 gSetManualCoords, Set Coords
    Gui, Add, Button, x280 y85 w80 h20 gStartManualHealing, Manual Heal
    Gui, Add, Button, x370 y85 w80 h20 gStopManualHealing, Stop Manual
    
    Gui, Add, Text, x30 y110 w450 h20 vHealerSkillbarCoords, Skillbar: Not set - use Tools tab
    Gui, Add, Text, x30 y130 w450 h20 vManualHealStatus, Manual: Not configured

    ; Skill Management Section
    Gui, Add, GroupBox, x20 y170 w470 h100, Skill Management
    Gui, Add, Button, x30 y190 w130 h30 gAddHealingSkill, Add Heal Skill
    Gui, Add, Button, x170 y190 w130 h30 gfindhealingskill, Test Skills
    Gui, Add, Button, x310 y190 w130 h30 gclearskills, Clear All
    Gui, Add, Button, x30 y230 w130 h30 gAssignHealKeys, Assign Keys
    Gui, Add, Button, x170 y230 w130 h30 gRenameHealSkills, Rename Skills
    Gui, Add, Button, x310 y230 w130 h30 gShowHealKeysStatus, Show Status
    
    ; Priority Management Section
    Gui, Add, GroupBox, x20 y280 w470 h160, Priority Order
    Gui, Add, ListBox, x30 y300 w350 h100 vHealPriorityList gHealPrioritySelect
    Gui, Add, Button, x390 y300 w80 h25 gMoveHealUp, Move Up
    Gui, Add, Button, x390 y330 w80 h25 gMoveHealDown, Move Down
    Gui, Add, Button, x390 y360 w80 h25 gRemoveFromHealPriority, Remove
    Gui, Add, Button, x390 y390 w80 h25 gAddToHealPriority, Add
    
    ; Status Section
    Gui, Add, GroupBox, x20 y450 w470 h120, Healer Status
    Gui, Add, Edit, x30 y470 w450 h90 vHealerStatusEdit ReadOnly VScroll
    
    ; ===== DPS TAB =====
    Gui, Tab, DPS
    
    ; Skill Management Section
    Gui, Add, GroupBox, x20 y40 w470 h100, DPS Skill Management
    Gui, Add, Button, x30 y60 w130 h30 gAddDPSSkill, Add DPS Skill
    Gui, Add, Button, x170 y60 w130 h30 gTestDPSSkills, Test Skills
    Gui, Add, Button, x310 y60 w130 h30 gClearDPSSkills, Clear All
    Gui, Add, Button, x30 y100 w130 h30 gAssignDPSKeys, Assign Keys
    Gui, Add, Button, x170 y100 w130 h30 gRenameDPSSkills, Rename Skills
    
    ; Priority Management Section
    Gui, Add, GroupBox, x20 y150 w470 h250, DPS Priority Order
    Gui, Add, ListBox, x30 y170 w350 h180 vDPSPriorityList gDPSPrioritySelect
    Gui, Add, Button, x390 y170 w80 h25 gMoveDPSUp, Move Up
    Gui, Add, Button, x390 y200 w80 h25 gMoveDPSDown, Move Down
    Gui, Add, Button, x390 y230 w80 h25 gRemoveFromDPSPriority, Remove
    Gui, Add, Button, x390 y260 w80 h25 gAddToDPSPriority, Add
    
    ; Status Section
    Gui, Add, GroupBox, x20 y410 w470 h130, DPS Status
    Gui, Add, Edit, x30 y430 w450 h100 vDPSStatusEdit ReadOnly VScroll
    
    ; ===== KEYPRESSER TAB =====
    Gui, Tab, KeyPresser
    
    ; Settings Section
    Gui, Add, GroupBox, x20 y40 w470 h60, Settings
    Gui, Add, Checkbox, x30 y60 w200 vSkipInitial1, Skip initial execution
    Gui, Add, Button, x250 y55 w60 h25 gSaveKeypresserSettings, Save
    Gui, Add, Button, x320 y55 w60 h25 gLoadKeypresserSettings, Load
    Gui, Add, Button, x390 y55 w80 h25 gStopAll, Stop All
    
    ; Sequence 1
    Gui, Add, GroupBox, x20 y110 w470 h80, Sequence 1 (Blue)
    Gui, Add, Text, x30 y130 w100, Keys (use | to separate):
    Gui, Add, Edit, x130 y130 w150 h20 vKeyCombinationEdit1, %KeyCombination1%
    Gui, Add, Text, x30 y155 w50, Delay (sec):
    Gui, Add, Edit, x80 y155 w50 h20 vKeyDelayEdit1, %KeyDelay1%
    Gui, Add, Text, x140 y155 w50, Timer (min):
    Gui, Add, Edit, x190 y155 w50 h20 vTimerIntervalEdit1, %TimerInterval1%
    Gui, Add, Button, x290 y130 w50 h30 gStartStop1, Start
    Gui, Add, Button, x350 y130 w50 h30 gStop1, Stop
    Gui, Add, Text, x410 y130 w70 vCountdownText1, Next: --
    Gui, Add, Text, x410 y155 w70 vStatusText1, Ready
    
    ; Sequence 2
    Gui, Add, GroupBox, x20 y200 w470 h80, Sequence 2 (Red)
    Gui, Add, Text, x30 y220 w100, Keys (use | to separate):
    Gui, Add, Edit, x130 y220 w150 h20 vKeyCombinationEdit2, %KeyCombination2%
    Gui, Add, Text, x30 y245 w50, Delay (sec):
    Gui, Add, Edit, x80 y245 w50 h20 vKeyDelayEdit2, %KeyDelay2%
    Gui, Add, Text, x140 y245 w50, Timer (min):
    Gui, Add, Edit, x190 y245 w50 h20 vTimerIntervalEdit2, %TimerInterval2%
    Gui, Add, Button, x290 y220 w50 h30 gStartStop2, Start
    Gui, Add, Button, x350 y220 w50 h30 gStop2, Stop
    Gui, Add, Text, x410 y220 w70 vCountdownText2, Next: --
    Gui, Add, Text, x410 y245 w70 vStatusText2, Ready
    
    ; Sequence 3
    Gui, Add, GroupBox, x20 y290 w470 h80, Sequence 3 (Green)
    Gui, Add, Text, x30 y310 w100, Keys (use | to separate):
    Gui, Add, Edit, x130 y310 w150 h20 vKeyCombinationEdit3, %KeyCombination3%
    Gui, Add, Text, x30 y335 w50, Delay (sec):
    Gui, Add, Edit, x80 y335 w50 h20 vKeyDelayEdit3, %KeyDelay3%
    Gui, Add, Text, x140 y335 w50, Timer (min):
    Gui, Add, Edit, x190 y335 w50 h20 vTimerIntervalEdit3, %TimerInterval3%
    Gui, Add, Button, x290 y310 w50 h30 gStartStop3, Start
    Gui, Add, Button, x350 y310 w50 h30 gStop3, Stop
    Gui, Add, Text, x410 y310 w70 vCountdownText3, Next: --
    Gui, Add, Text, x410 y335 w70 vStatusText3, Ready
    
    ; Help Section
    Gui, Add, GroupBox, x20 y380 w470 h60, Help
    Gui, Add, Text, x30 y400 w450 h30, Example: !1|+2|^c means Alt+1, then Shift+2, then Ctrl+C`nModifiers: ! = Alt, + = Shift, ^ = Ctrl
   
    ; ===== Tools Tab ======
    Gui, Tab, Tools
    
    ; Quick Tools Section
    Gui, Add, GroupBox, x20 y40 w470 h120, Quick Tools
    Gui, Add, Button, x30 y60 w110 h30 gskillboxesnpc, MasterBoxes NPC
    Gui, Add, Button, x150 y60 w110 h30 genchanter, Gear Enchanter
    Gui, Add, Button, x270 y60 w110 h30 gBuffheal2nd, Buff&Heal 2nd
    Gui, Add, Button, x390 y60 w80 h30 galtassist, Alt Assist
    
    ; Coordinate Settings Section
    Gui, Add, GroupBox, x20 y170 w470 h120, Coordinate Settings
    Gui, Add, Button, x30 y190 w140 h30 gSetSkillbarArea, Set Skillbar Area
    Gui, Add, Button, x180 y190 w180 h30 gSetCheckSnapshotCoords, Set CheckWeight/Snapshot Area
    Gui, Add, Text, x30 y230 w450 h20 vToolsSkillbarCoords, Skillbar: Not set
    Gui, Add, Text, x30 y250 w450 h20 vCheckSnapshotCoordsText, CheckWeight/Snapshot: Not set

  ; ===== Templar ======
    Gui, Tab, Templar
    
    ; Setup Section
    Gui, Add, GroupBox, x20 y40 w470 h100, Templar Setup
    Gui, Add, Button, x30 y60 w120 h30 gSelectWindow2, Select Window
    Gui, Add, Text, x160 y60 w80 h20, Targets:
    Gui, Add, Edit, x240 y60 w50 h20 vTemplarTargetCountEdit gValidateTemplarTargetCount, 1
    Gui, Add, UpDown, Range1-20, 1
    Gui, Add, Button, x300 y60 w100 h30 gSetTemplarPoints, Set Points
    Gui, Add, Text, x30 y100 w100 h20, Holyground Key:
    Gui, Add, Edit, x130 y100 w80 h20 vHolygroundHotkeyEdit, %HolygroundHotkey%
    Gui, Add, Button, x220 y100 w60 h20 gSaveHolygroundHotkey, Save
    
    ; Settings Section
    Gui, Add, GroupBox, x20 y150 w470 h100, Randomization Settings
    Gui, Add, Text, x30 y170 w80 h20, X Variation:
    Gui, Add, Edit, x110 y170 w50 h20 vRandomXVariationEdit, 5
    Gui, Add, Text, x170 y170 w30 h20, px
    Gui, Add, Text, x210 y170 w80 h20, Y Variation:
    Gui, Add, Edit, x290 y170 w50 h20 vRandomYVariationEdit, 5
    Gui, Add, Text, x350 y170 w30 h20, px
    Gui, Add, Text, x30 y200 w80 h20, Min Delay:
    Gui, Add, Edit, x110 y200 w50 h20 vMinDelayEdit, 80
    Gui, Add, Text, x170 y200 w30 h20, ms
    Gui, Add, Text, x210 y200 w80 h20, Max Delay:
    Gui, Add, Edit, x290 y200 w50 h20 vMaxDelayEdit, 150
    Gui, Add, Text, x350 y200 w30 h20, ms
    
    ; Control Section
    Gui, Add, GroupBox, x20 y260 w470 h80, Controls
    Gui, Add, Button, x30 y280 w120 h30 gStartTemplarScript, Start Templar
    Gui, Add, Button, x160 y280 w120 h30 gStopTemplarScript, Stop Templar
    
    ; Status Section
    Gui, Add, GroupBox, x20 y350 w470 h190, Templar Status
    Gui, Add, Edit, x30 y370 w450 h160 vTemplarStatusEdit ReadOnly VScroll


    ; ===== GLOBAL CONTROLS =====
    Gui, Tab
    Gui, Add, Button, x240 y640 w60 h25 gCloseApp, Close
    
    ; Show GUI
    Gui, Show, x1394 y0 w540 h680, Buff & Heal - Game Automation Tool
    gui, +AlwaysOnTop
    ; Load and display existing heal skills after GUI is shown
    SetTimer, LoadHealSkillsDelayed, -100
    ; Load and display existing DPS skills after GUI is shown
    SetTimer, LoadDPSSkillsDelayed, -150
return
Farming:
if (Farming = False)
{
    ; Ask user to right-click pylon location
    MsgBox, 4, Set Pylon Location, Right-click on the location where the pylon will spawn.
    IfMsgBox No
        return
    
    ; Wait for right-click to capture coordinates
    KeyWait, RButton, D
    MouseGetPos, tempPylonX, tempPylonY
    KeyWait, RButton
    
    ; Convert to window-relative coordinates
    WinGetPos, winX, winY,,, ahk_id %win1%
    pylonX := tempPylonX - winX
    pylonY := tempPylonY - winY
    
    MsgBox, Pylon location set to: %pylonX%, %pylonY% (relative to window)
    
    Farming := True
    settimer, capchacheck, 500
    SetTimer, essences, 30000
    SetTimer, buffdaddystone, 2000000
    SetTimer, buffpetscroll, 2017000
    settimer, checkweight, 1000
    SetTimer, snapshot, 60000
}
else if (Farming = True)
{
    Farming := False
    settimer, capchacheck, off
    SetTimer, essences, off
    SetTimer, buffdaddystone, off
    SetTimer, buffpetscroll, off
    SetTimer, PylonClicker, off
    }
Return

healanddps:
Gui, Submit, NoHide
if (healanddps) {
    ; Uncheck the other checkbox
    GuiControl,, dpstargetedhealing, 0
    dpstargetedhealing := false
}
Return

dpstargetedhealing:
Gui, Submit, NoHide
if (dpstargetedhealing) {
    ; Uncheck the other checkbox
    GuiControl,, healanddps, 0
    healanddps := false
    
    ; Ask for player and pet counts
    InputBox, playerCount, DPS Targeted Healing, Enter number of players (0-10):, , 300, 130, , , , , 0
    if (ErrorLevel)
        return
    
    InputBox, petCount, DPS Targeted Healing, Enter number of pets (0-10):, , 300, 130, , , , , 0
    if (ErrorLevel)
        return
    
    if (playerCount = 0 && petCount = 0) {
        MsgBox, Must have at least 1 player or pet
        GuiControl,, dpstargetedhealing, 0
        dpstargetedhealing := false
        return
    }
    
    ; Capture coordinates
    DPSTargetedPlayerCoords := []
    DPSTargetedPetCoords := []
    
    Gui, Hide
    
    if (playerCount > 0) {
        MsgBox, Right-click on %playerCount% player health bar locations
        Loop, %playerCount% {
            ToolTip, Right-click Player %A_Index% health bar, 100, 100
            KeyWait, RButton, D
            MouseGetPos, px, py
            DPSTargetedPlayerCoords.Push({x: px, y: py})
            KeyWait, RButton
            Sleep, 200
        }
    }
    
    if (petCount > 0) {
        MsgBox, Right-click on %petCount% pet health bar locations
        Loop, %petCount% {
            ToolTip, Right-click Pet %A_Index% health bar, 100, 100
            KeyWait, RButton, D
            MouseGetPos, px, py
            DPSTargetedPetCoords.Push({x: px, y: py})
            KeyWait, RButton
            Sleep, 200
        }
    }
    
    ToolTip
    Gui, Show
    
    MsgBox, DPS Targeted Healing configured: %playerCount% players, %petCount% pets
}
Return
; Button handler for monitor selection
MonitorButton:
    monitorNum := A_GuiControl
    if (activeMonitors < maxMonitors) {
        GuiControl, Main:, MonitorStatus, Click on window %monitorNum% to monitor...
        KeyWait, LButton, D
        MouseGetPos,,, winId
        WinGetTitle, title, ahk_id %winId%
        
        ; Launch a new AHK process for this window
        Run, "%A_AhkPath%" "%A_ScriptDir%\MemoryMonitor%monitorNum%.ahk" "%winId%"
        
        activeMonitors++
        GuiControl, Main:, MonitorStatus, Monitoring %activeMonitors% window(s)
    } else {
        GuiControl, Main:, MonitorStatus, Maximum of %maxMonitors% windows reached
    }
return
Closemonitors:
; Close all monitor processes
    Loop, 8 {
        Process, Close, MemoryMonitor%A_Index%.ahk
    }
Return
Expmonitor:
Run, %A_ScriptDir%\expperhour.ahk
    return
altassist:
Run, C:\Users\zombi\Desktop\ahk stuff\AA\AltAssistV2.exe
    return
Rupeemonitor:
Run, %A_ScriptDir%\rupeeperhour.ahk
    return
SetSkillbarArea:
    ; Hide the GUI temporarily
    Gui, Hide
    
    ; Instructions for top-left corner
    MsgBox, 4, Set Skillbar Area, Click OK then right-click on the TOP-LEFT corner of your skillbar area.`n`nPress ESC to cancel.
    IfMsgBox No
    {
        Gui, Show
        return
    }
    
    ; Wait for left click to get top-left coordinates
    ToolTip, right-click the TOP-LEFT corner of the skillbar area, 100, 100
    KeyWait, rButton, D
    MouseGetPos, tempX1, tempY1
    KeyWait, rButton
    ToolTip
    
    ; Brief pause
    Sleep, 500
    
    ; Instructions for bottom-right corner
    MsgBox, 4, Set Skillbar Area, Now right-click on the BOTTOM-RIGHT corner of your skillbar area.`n`nPress ESC to cancel.
    IfMsgBox No
    {
        Gui, Show
        return
    }
    
    ; Wait for left click to get bottom-right coordinates
    ToolTip, right-click the BOTTOM-RIGHT corner of the skillbar area, 100, 100
    KeyWait, rButton, D
    MouseGetPos, tempX2, tempY2
    KeyWait, rButton
    ToolTip
    
    ; Validate coordinates (ensure X1 < X2 and Y1 < Y2)
    if (tempX1 >= tempX2 || tempY1 >= tempY2) {
        MsgBox, 16, Error, Invalid coordinates! Make sure you click top-left first, then bottom-right.`n`nTop-left: %tempX1%,%tempY1%`nBottom-right: %tempX2%,%tempY2%
        Gui, Show
        return
    }
    
    ; Convert to window-relative coordinates
    WinGetPos, winX, winY,,, ahk_id %win1%
    SkillBarX1 := tempX1 - winX
    SkillBarY1 := tempY1 - winY
    SkillBarX2 := tempX2 - winX
    SkillBarY2 := tempY2 - winY
    
    ; Save to INI file
    SaveSkillbarCoordinates()
    
    ; Update the display
    UpdateSkillbarDisplay()
    
    ; Show success message
    MsgBox, 64, Success, Skillbar area updated successfully!`n`nNew coordinates:`nTop-left: %SkillBarX1%,%SkillBarY1%`nBottom-right: %SkillBarX2%,%SkillBarY2%`n`nArea size: %width%x%height% pixels
    
    ; Show the GUI again
    Gui, Show
return

; Function to save skillbar coordinates to INI
SaveSkillbarCoordinates() {
    global iniFile, SkillBarX1, SkillBarY1, SkillBarX2, SkillBarY2
    
    FileEncoding, UTF-8
    IniWrite, %SkillBarX1%, %iniFile%, SkillbarArea, X1
    IniWrite, %SkillBarY1%, %iniFile%, SkillbarArea, Y1
    IniWrite, %SkillBarX2%, %iniFile%, SkillbarArea, X2
    IniWrite, %SkillBarY2%, %iniFile%, SkillbarArea, Y2
    FileEncoding
}

; Function to load skillbar coordinates from INI
LoadSkillbarCoordinates() {
    global iniFile, SkillBarX1, SkillBarY1, SkillBarX2, SkillBarY2
    
    FileEncoding, UTF-8
    IniRead, loadedX1, %iniFile%, SkillbarArea, X1, %SkillBarX1%
    IniRead, loadedY1, %iniFile%, SkillbarArea, Y1, %SkillBarY1%
    IniRead, loadedX2, %iniFile%, SkillbarArea, X2, %SkillBarX2%
    IniRead, loadedY2, %iniFile%, SkillbarArea, Y2, %SkillBarY2%
    FileEncoding
    
    ; Only update if valid coordinates were loaded
    if (loadedX1 != "ERROR" && loadedY1 != "ERROR" && loadedX2 != "ERROR" && loadedY2 != "ERROR") {
        SkillBarX1 := loadedX1
        SkillBarY1 := loadedY1
        SkillBarX2 := loadedX2
        SkillBarY2 := loadedY2
    }
}

; Function to update the skillbar display
UpdateSkillbarDisplay() {
    global SkillBarX1, SkillBarY1, SkillBarX2, SkillBarY2
    
    width := SkillBarX2 - SkillBarX1
    height := SkillBarY2 - SkillBarY1
    displayText := "Current Skillbar Area: X1=" . SkillBarX1 . " Y1=" . SkillBarY1 . " X2=" . SkillBarX2 . " Y2=" . SkillBarY2 . " (Size: " . width . "x" . height . ")"
    GuiControl,, HealerSkillbarCoords, %displayText%
    GuiControl,, ToolsSkillbarCoords, %displayText%
}
LoadHealSkillsDelayed:
    RefreshHealSkillsList()
    RefreshHealPriorityList()
    ; Update the heal interval display with loaded value
    GuiControl,, HealIntervalInput, %healCheckInterval%
    ; Update skillbar coordinates display
    UpdateSkillbarDisplay()
return


LoadDPSSkillsDelayed:
    RefreshDPSPriorityList()
return
; ========= Quick Menu's =========
skillboxesnpc:
    Run, %A_ScriptDir%\openmasterboxes.ahk
    return
buffheal2nd:
    Run, C:\Users\zombi\Desktop\New folder (2) - Copy\buff&heal.ahk
    return
enchanter:
    Run, %A_ScriptDir%\gear_enchanter.ahk
    return
; ========= HEALER FUNCTIONS =========
TestPartyDetection:
    DetectPartyMembers()
return

DetectPartyMembers() {
    ; Find the party window bar
    if (!(partyBar := FindText(0, 0, 0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, partywindow))) {
        UpdateHealerStatus("Party window not found")
        return
    }
    
    ; Create search area: 15px left, 175px right, 430px down
    searchX1 := partyBar.1.x - 15
    searchY1 := partyBar.1.y
    searchX2 := partyBar.1.x + 175
    searchY2 := partyBar.1.y + 430
    
    playerPatterns := magus . "|" . Corruptor
    petPatterns := windixie . "|" . gnoll . "|" . etherealpixie
    
    playerCount := 0
    petCount := 0
    
    ; Find player portraits and show health check dots
    if (ok := FindText(0, 0, searchX1, searchY1, searchX2, searchY2, 0, 0, playerPatterns)) {
        playerCount := ok.Length()
        for i, portrait in ok {
            centerY := portrait.y - 1
            healthX := portrait.x + 54
            ; Create red dot at health check position
            dotX := healthX + 46
            dotY := centerY - 3
            Gui, HealthDot%i%:New, +AlwaysOnTop -Caption +ToolWindow, HealthCheck
            Gui, HealthDot%i%:Color, Red
            Gui, HealthDot%i%:Show, x%dotX% y%dotY% w3 h9 NoActivate
            SetTimer, RemoveHealthDot%i%, -3000
        }
    }
    
    ; Find pet portraits and show health check dots
    if (ok := FindText(0, 0, searchX1, searchY1, searchX2, searchY2, 0, 0, petPatterns)) {
        petCount := ok.Length()
        for i, portrait in ok {
            centerY := portrait.y - 1
            healthX := portrait.x + 54
            ; Create blue dot at health check position
            dotIndex := i + 10  ; Offset to avoid conflicts with player dots
            petDotX := healthX - 18
            petDotY := centerY - 1
            Gui, HealthDot%dotIndex%:New, +AlwaysOnTop -Caption +ToolWindow, PetHealthCheck
            Gui, HealthDot%dotIndex%:Color, Blue
            Gui, HealthDot%dotIndex%:Show, x%petDotX% y%petDotY% w3 h9 NoActivate
            SetTimer, RemoveHealthDot%dotIndex%, -3000
        }
    }
    
    UpdateHealerStatus("Detected: " . playerCount . " players, " . petCount . " pets - Visual dots shown for 3 seconds")
}

ValidateHealInterval:
    Gui, Submit, NoHide
    if (HealIntervalInput < 100)
    {
        HealIntervalInput := 100
        GuiControl,, HealIntervalInput, 100
    }
    else if (HealIntervalInput > 10000)
    {
        HealIntervalInput := 10000
        GuiControl,, HealIntervalInput, 10000
    }
return

SaveHealInterval:
    Gui, Submit, NoHide
    Gosub, ValidateHealInterval
    healCheckInterval := HealIntervalInput
    SaveHealSettings()
    UpdateHealerStatus("Heal check interval set to " . healCheckInterval . "ms and saved to INI")
    
    ; Update the timer if healing is active
    SetTimer, CheckHealth, Off
    SetTimer, DynamicHealthCheck, Off
    SetTimer, ManualHealthCheck, Off
    if (PlayerCoords.Length() > 0 || PetCoords.Length() > 0) {
        SetTimer, CheckHealth, %healCheckInterval%
        UpdateHealerStatus("Heal timer updated - now checking every " . healCheckInterval . "ms")
    }
    ; Also update DynamicHealthCheck timer if it's running
    SetTimer, DynamicHealthCheck, %healCheckInterval%
    ; Update manual healing timer if active
    if (isManualHealingActive) {
        SetTimer, ManualHealthCheck, %healCheckInterval%
    }
return

SelectWindow:
    MsgBox, Now right click on the window 
    KeyWait, RButton, D
    MouseGetPos,,, win1
    WinGetTitle, title, ahk_id %win1%
    WinGet, pid, PID, ahk_id %win1%
    MsgBox, You have selected: %title%
    ;WinMove, ahk_id %win1%, , 0, 0
    FindText().BindWindow(win1)
    ; Store the window ID globally for healing activation
    global TargetGameWindow := win1
    global TargetGameTitle := title
    global windowWasClosed := false  ; Reset the flag when new window is selected
    UpdateHealerStatus("Selected window: " . title)
    

return
SelectWindow2:
    MsgBox, Now right click on the window 
    KeyWait, RButton, D
    MouseGetPos,,, win2
    WinGetTitle, title, ahk_id %win2%
    WinGet, pid, PID, ahk_id %win2%
    MsgBox, You have selected: %title%
    WinMove, ahk_id %win2%, , 0, 0
    
    ; Store the window ID globally for healing activation
    global TargetGameWindow := win2
    global TargetGameTitle := title
    global windowWasClosed := false  ; Reset the flag when new window is selected
    UpdateHealerStatus("Selected window: " . title)
return

SelectDPSWindow:
    MsgBox, Now right click on the game window for DPS.
    KeyWait, RButton, D
    MouseGetPos,,, win1
    WinGetTitle, title, ahk_id %win1%
    WinGet, pid, PID, ahk_id %win1%
    MsgBox, You have selected: %title%
    WinMove, ahk_id %win1%, , 0, 0
    
    ; Store the window ID globally for DPS activation
    global TargetGameWindow := win1
    global TargetGameTitle := title
    UpdateDPSStatus("Selected window: " . title)
return

StartDynamicHealing:
    SetTimer, DynamicHealthCheck, %healCheckInterval%
    UpdateHealerStatus("Dynamic healing started - auto-detecting party members")
return

DynamicHealthCheck:
    ; Find the party window bar
    if (!(partyBar := FindText(0, 0, 0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, partywindow))) {
        return
    }
    
    ; Create search area: 15px left, 175px right, 430px down
    searchX1 := partyBar.1.x - 15
    searchY1 := partyBar.1.y
    searchX2 := partyBar.1.x + 175
    searchY2 := partyBar.1.y + 430
    
    playerPatterns := magus . "|" . Corruptor
    petPatterns := windixie . "|" . gnoll . "|" . etherealpixie
    
    ; Check players in party area
    if (ok := FindText(0, 0, searchX1, searchY1, searchX2, searchY2, 0, 0, playerPatterns)) {
        for i, portrait in ok {
            centerY := portrait.y - 1
            healthX := portrait.x + 54
            
            ; Look for full health bar (green)
            healthFull := "|<>##0.90$0/0/24690C,0/1/00AA90,0/2/006655,0/3/3ED514"
            checkX := healthX + 46
            checkY := centerY + 2
            healthFullFound := FindText(0, 0, checkX - 15, checkY - 15, checkX + 15, checkY + 15, 0, 0, healthFull)
            if (!healthFullFound) {
                SendMessageClick(portrait.x + 9, centerY)
                TryCastHealingSkill()
                Sleep, 25
            }
        }
    }
    
    ; Check pets in party area
    if (ok := FindText(0, 0, searchX1, searchY1, searchX2, searchY2, 0, 0, petPatterns)) {
        for i, portrait in ok {
            centerY := portrait.y - 1
            healthX := portrait.x + 54
            
            ; Look for full health bar (green)
            healthFull := "|<>##0.90$0/0/24690C,0/1/00AA90,0/2/006655,0/3/3ED514"
            checkX := healthX - 18
            checkY := centerY + 2
            healthFullFound := FindText(0, 0, checkX - 15, checkY - 15, checkX + 15, checkY + 15, 0, 0, healthFull)
            if (!healthFullFound) {
                SendMessageClick(portrait.x + 9, centerY)
                TryCastHealingSkill()
                Sleep, 25
            }
        }
    }
return

CancelHealerScript:
    SetTimer, CheckHealth, Off
    SetTimer, UpdateBoundingBoxes, Off
    SetTimer, DynamicHealthCheck, Off
    SetTimer, ManualHealthCheck, Off
    ClearBoundingBoxes()
    isManualHealingActive := false
    UpdateHealerStatus("All healer scripts stopped.")
return

clearskills:
    InputBox, patternToClear, Clear Heal Pattern, Enter the name of the heal pattern to clear (leave empty to clear all):, , 300, 130
    if (ErrorLevel)
        return

    if (patternToClear = "") {
        ; Clear only heal patterns
        healPatternsToDelete := []
        for patternName, patternText in patterns {
            if (SubStr(patternName, 1, 4) = "heal") {
                healPatternsToDelete.Push(patternName)
            }
        }
        
        for index, patternName in healPatternsToDelete {
            patterns.Delete(patternName)
            patternKeys.Delete(patternName)
            patternNames.Delete(patternName)
            IniDelete, %iniFile%, Patterns, %patternName%
            IniDelete, %iniFile%, PatternKeys, %patternName%
            IniDelete, %iniFile%, PatternNames, %patternName%
        }
        
        healPriorities := []
        IniDelete, %iniFile%, HealPriorities
        patternCounter := 1
        RefreshHealPriorityList()
        UpdateHealerStatus("All heal patterns have been cleared.")
    } else {
        ; Check both pattern name and custom name
        patternToDelete := ""
        for healPat, healText in patterns {
            if (SubStr(healPat, 1, 4) = "heal") {
                displayName := GetDisplayName(healPat)
                if (healPat = patternToClear || displayName = patternToClear) {
                    patternToDelete := healPat
                    break
                }
            }
        }
        
        if (patternToDelete != "") {
            patterns.Delete(patternToDelete)
            patternKeys.Delete(patternToDelete)
            patternNames.Delete(patternToDelete)
            
            ; Remove from priority list
            for index, priorityPattern in healPriorities {
                if (priorityPattern = patternToDelete) {
                    healPriorities.RemoveAt(index)
                    break
                }
            }
            
            IniDelete, %iniFile%, Patterns, %patternToDelete%
            IniDelete, %iniFile%, PatternKeys, %patternToDelete%
            IniDelete, %iniFile%, PatternNames, %patternToDelete%
            SaveHealPriorities()
            RefreshHealPriorityList()
            UpdateHealerStatus("Heal pattern '" . patternToClear . "' has been cleared.")
        } else {
            UpdateHealerStatus("Heal pattern '" . patternToClear . "' not found.")
        }
    }
return

findhealingskill:
    if (patterns.Count() = 0) {
        UpdateHealerStatus("No healing skills captured. Add some skills first.")
        return
    }
    
    UpdateHealerStatus("Testing healing skills - searching for patterns on screen...")
    
    foundCount := 0
    totalCount := 0
    
    ; Test each heal pattern
    for patternName, patternText in patterns {
        if (SubStr(patternName, 1, 4) = "heal") {
            totalCount++
            displayName := GetDisplayName(patternName)
            
            ; Search in the skill bar area - convert window-relative to screen coordinates
            WinGetPos, winX, winY,,, ahk_id %win1%
            screenX1 := winX + SkillBarX1
            screenY1 := winY + SkillBarY1
            screenX2 := winX + SkillBarX2
            screenY2 := winY + SkillBarY2
            if (ok := FindText(X, Y, screenX1, screenY1, screenX2, screenY2, 0, 0, patternText)) {
                foundCount++
                UpdateHealerStatus("✓ FOUND: " . displayName . " at coordinates: " . X . ", " . Y)
                
                ; Highlight the found skill
                Try {
                    For i, v in ok {
                        if (i <= 2)
                            FindText().MouseTip(ok[i].x, ok[i].y)
                    }
                }
            } else {
                UpdateHealerStatus("✗ Not found: " . displayName)
            }
        }
    }
    
    UpdateHealerStatus("Test complete - Found " . foundCount . " out of " . totalCount . " healing skills on screen.")
return

AddHealingSkill:
    UpdateHealerStatus("Hover your mouse over the healing skill and press 1 to capture it")
    KeyWait, 1, D
    capturedText := FindText().GetTextFromScreen(x1:=0, y1:=0, x2:=0, y2:=0, Threshold="", ScreenShot:=1, outX, outY)
    Clipboard := capturedText
    patternName := "heal" . patternCounter
    
    ; Prompt for custom name and key assignment
    InputBox, customName, Name Healing Skill, Enter a name for this healing skill:, , 300, 130, , , , , %patternName%
    if (ErrorLevel)
        return
    
    if (customName = "")
        customName := patternName
    
    InputBox, assignedKey, Assign Key, Enter a key for this skill (leave empty to click with mouse):, , 300, 130
    if (ErrorLevel)
        return
    
    ; Save pattern with key and custom name
    SavePattern(patternName, capturedText, assignedKey)
    SavePatternName(patternName, customName)
    
    UpdateHealerStatus("Healing skill captured and saved as '" . customName . "' [" . patternName . "]")
    patternCounter++
    
    ; Add to priority list at the end
    healPriorities.Push(patternName)
    SaveHealPriorities()
    RefreshHealSkillsList()
    RefreshHealPriorityList()
Return

CaptureCoordinates() {
    global PlayerCount, PetCount, PlayerCoords, PetCoords, partywindowlogo
    
    ; Find party window logo first
    if (!FindText(logoX, logoY, 0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, partywindowlogo)) {
        MsgBox, 16, Error, Party window logo not found! Make sure the party window is visible.
        return
    }
    
    PlayerCoords := []
    PetCoords := []
    ClearBoundingBoxes()

    MsgBox, 0, Coordinate Capture, Please click on the center of each player character (total: %PlayerCount%).`n`nPress F12 to cancel.

    Loop, %PlayerCount% {
        currentPlayer := A_Index
        ToolTip, Click on the center of Player %currentPlayer%, 100, 100

        KeyWait, LButton, D
        MouseGetPos, PlayerCenterX, PlayerCenterY
        
        ; Calculate relative position to party window logo
        relativeX := PlayerCenterX - logoX
        relativeY := PlayerCenterY - logoY

        PlayerCoords.Push({RelativeX: relativeX, RelativeY: relativeY})
        
        ; Draw rectangle at current position for visual feedback
        PlayerX1 := PlayerCenterX - 2
        PlayerX2 := PlayerCenterX + 3
        PlayerY1 := PlayerCenterY - 12
        PlayerY2 := PlayerCenterY + 13
        DrawHollowRectangle(PlayerX1, PlayerY1, PlayerX2, PlayerY2, "Player" . currentPlayer, "00FF00", "FFFF00")

        KeyWait, LButton
        Sleep, 500
    }

    ToolTip

    if (PetCount > 0) {
        MsgBox, 0, Coordinate Capture, Now please click on the center of each pet (total: %PetCount%).`n`nPress F12 to cancel.

        Loop, %PetCount% {
            currentPet := A_Index
            ToolTip, Click on the center of Pet %currentPet%, 100, 100

            KeyWait, LButton, D
            MouseGetPos, PetCenterX, PetCenterY
            
            ; Calculate relative position to party window logo
            relativeX := PetCenterX - logoX
            relativeY := PetCenterY - logoY

            PetCoords.Push({RelativeX: relativeX, RelativeY: relativeY})
            
            ; Draw rectangle at current position for visual feedback
            PetX1 := PetCenterX - 2
            PetX2 := PetCenterX + 3
            PetY1 := PetCenterY - 12
            PetY2 := PetCenterY + 13
            DrawHollowRectangle(PetX1, PetY1, PetX2, PetY2, "Pet" . currentPet, "0000FF", "FF00FF")

            KeyWait, LButton
            Sleep, 500
        }
    }

    ToolTip

    summaryText := "Captured coordinates for " . PlayerCount . " players and " . PetCount . " pets relative to party window.`n`n"
    summaryText .= "Player coordinates (relative to logo):`n"
    For index, coords in PlayerCoords {
        summaryText .= "Player " . index . ": Offset(" . coords.RelativeX . "," . coords.RelativeY . ")`n"
    }

    if (PetCount > 0) {
        summaryText .= "`nPet coordinates (relative to logo):`n"
        For index, coords in PetCoords {
            summaryText .= "Pet " . index . ": Offset(" . coords.RelativeX . "," . coords.RelativeY . ")`n"
        }
    }

    summaryText .= "`nPress F12 to clear all bounding boxes.`nDo you want to start monitoring these areas?"

    MsgBox, 4, Coordinates Captured, %summaryText%
    IfMsgBox Yes
    {
        StartMonitoring()
    }
}

StartMonitoring() {
    global PlayerCoords, PetCoords, HealthPattern, healCheckInterval
    SetTimer, CheckHealth, %healCheckInterval%
    SetTimer, UpdateBoundingBoxes, 500
    UpdateHealerStatus("Health monitoring started - checking every " . healCheckInterval . "ms")
return
}

UpdateBoundingBoxes:
    global PlayerCoords, PetCoords, partywindowlogo, BoundingBoxes, lastLogoX, lastLogoY
    
    if (!FindText(logoX, logoY, 0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, partywindowlogo))
        return
    
    ; Only update if logo position changed
    if (logoX = lastLogoX && logoY = lastLogoY)
        return
        
    lastLogoX := logoX
    lastLogoY := logoY
    
    ClearBoundingBoxes()
    
    For index, coords in PlayerCoords {
        currentX := logoX + coords.RelativeX
        currentY := logoY + coords.RelativeY
        PlayerX1 := currentX - 2
        PlayerX2 := currentX + 3
        PlayerY1 := currentY - 4
        PlayerY2 := currentY + 5
        DrawHollowRectangle(PlayerX1, PlayerY1, PlayerX2, PlayerY2, "Player" . index, "00FF00", "FFFF00")
    }
    
    For index, coords in PetCoords {
        currentX := logoX + coords.RelativeX
        currentY := logoY + coords.RelativeY
        PetX1 := currentX - 2
        PetX2 := currentX + 3
        PetY1 := currentY - 4
        PetY2 := currentY + 5
        DrawHollowRectangle(PetX1, PetY1, PetX2, PetY2, "Pet" . index, "0000FF", "FF00FF")
    }
return

CheckHealth:
    global partywindowlogo
    
    ; Find current party window logo position
    if (!FindText(logoX, logoY, 0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, partywindowlogo)) {
        UpdateHealerStatus("Party window not found - healing paused")
        return
    }
    
    For index, coords in PlayerCoords {
        ; Calculate current position based on logo position
        currentX := logoX + coords.RelativeX
        currentY := logoY + coords.RelativeY
        
        ; Create health check area around current position
        PlayerX1 := currentX - 2
        PlayerX2 := currentX + 3
        PlayerY1 := currentY - 4
        PlayerY2 := currentY + 5

        healthpresent := "|<>##0.90$0/0/24690C,0/1/00AA90,0/2/006655,0/3/3ED514"
        ok := FindText(0, 0, PlayerX1, PlayerY1, PlayerX2, PlayerY2, 0, 0, healthpresent)

        if (!ok) {
            if (PlayerCount > 1 || PetCount > 0) {
                Loop 5 {
                    SendMessageClick(currentX, currentY)
                    Sleep, 20
                }  
            }
            healResult := TryCastHealingSkill()
            if (healResult) {
                UpdateHealerStatus("→ Healed Player " . index)
            } else {
                UpdateHealerStatus("Targeted Player " . index . " but no healing skill available")
            }
            Sleep, 25
        }
    }

    For index, coords in PetCoords {
        ; Calculate current position based on logo position
        currentX := logoX + coords.RelativeX
        currentY := logoY + coords.RelativeY
        
        ; Create health check area around current position
        PetX1 := currentX - 2
        PetX2 := currentX + 3
        PetY1 := currentY - 4
        PetY2 := currentY + 5

        healthpresent := "|<>##0.90$0/0/24690C,0/1/00AA90,0/2/006655,0/3/3ED514"
        ok := FindText(0, 0, PetX1, PetY1, PetX2, PetY2, 0, 0, healthpresent)

        if (!ok) {
            Loop 5 {
                SendMessageClick(currentX, currentY)
                Sleep, 20
            }
            Sleep, 25
            healResult := TryCastHealingSkill()
            if (healResult) {
                UpdateHealerStatus("→ Healed Pet " . index)
            } else {
                UpdateHealerStatus("Targeted Pet " . index . " but no healing skill available")
            }
            Sleep, 25
        }
    }
return

TryCastHealingSkill() {
    global patterns, patternKeys, healPriorities, partywindowlogo
    global SkillBarX1, SkillBarY1, SkillBarX2, SkillBarY2
    global TargetGameWindow, TargetGameTitle
    
    ; Find current party window logo position for skill bar search
    if (!FindText(logoX, logoY, 0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, partywindowlogo)) {
        UpdateHealerStatus("Party window not found - cannot cast healing skills")
        return false
    }

    ; Go through heal priority order first
    for index, priorityPattern in healPriorities {
        if (!patterns.HasKey(priorityPattern) || SubStr(priorityPattern, 1, 4) != "heal")
            continue
            
        patternText := patterns[priorityPattern]
        ; Convert window-relative coordinates to screen coordinates
        WinGetPos, winX, winY,,, ahk_id %win1%
        screenX1 := winX + SkillBarX1
        screenY1 := winY + SkillBarY1
        screenX2 := winX + SkillBarX2
        screenY2 := winY + SkillBarY2
        healingSkill := FindText(0, 0, screenX1, screenY1, screenX2, screenY2, 0, 0, patternText)

        if (healingSkill) {
            ; Check if there's a key assigned to this pattern
            displayName := GetDisplayName(priorityPattern)
            ; Create detailed heal info showing both ID and custom name
            if (displayName != priorityPattern) {
                healInfo := priorityPattern . " = " . displayName
            } else {
                healInfo := priorityPattern
            }
            
            ; Spam the heal until it's no longer found
            spamCount := 0
            maxSpam := 3  ; Prevent infinite loops
            
            Loop {
                spamCount++
                ;ActivateGameWindow()
                if (patternKeys.HasKey(priorityPattern) && patternKeys[priorityPattern] != "") {
                    ; Use key press instead of clicking with modifier key handling
                    assignedKey := patternKeys[priorityPattern]
                    
                    ; Check for modifier keys and handle them separately
                    hasCtrl := InStr(assignedKey, "^")
                    hasAlt := InStr(assignedKey, "!")
                    hasShift := InStr(assignedKey, "+")
                    
                    ; Extract the base key (remove modifiers)
                    baseKey := assignedKey
                    if (hasCtrl)
                        baseKey := StrReplace(baseKey, "^", "")
                    if (hasAlt)
                        baseKey := StrReplace(baseKey, "!", "")
                    if (hasShift)
                        baseKey := StrReplace(baseKey, "+", "")
                    
                    ; Send modifier keys down
                    if (hasCtrl)
                        ControlSend, , {Ctrl down}, ahk_id %win1%
                    if (hasAlt)
                        ControlSend, , {Alt down}, ahk_id %win1%
                    if (hasShift)
                        ControlSend, , {Shift down}, ahk_id %win1%
                    Sleep, 25
                    ; Send the base key
                    ControlSend, , {%baseKey% down}, ahk_id %win1%
                    Sleep, 25
                    ControlSend, , {%baseKey% up}, ahk_id %win1%
                    Sleep, 25
                    ; Send modifier keys up (in reverse order)
                    if (hasShift)
                        ControlSend, , {Shift up}, ahk_id %win1%
                    if (hasAlt)
                        ControlSend, , {Alt up}, ahk_id %win1%
                    if (hasCtrl)
                        ControlSend, , {Ctrl up}, ahk_id %win1%
                        Sleep, 25
                } else {
                    ; Fall back to SendMessage clicking
                    X := healingSkill.1.x
                    Y := healingSkill.1.y
                    SendMessageClick(X, Y)
                    Sleep, 25  ; Brief pause between clicks
                }
                
                ; Check if heal skill is still available
                Sleep, 125  ; Small delay to let game update
                healingSkill := FindText(0, 0, screenX1, screenY1, screenX2, screenY2, 0, 0, patternText)
                
                ; Exit if heal no longer available or we've spammed too much
                if (!healingSkill || spamCount >= maxSpam) {
                    break
                }
            }
            
            if (patternKeys.HasKey(priorityPattern) && patternKeys[priorityPattern] != "") {
                assignedKey := patternKeys[priorityPattern]
                UpdateHealerStatus("Spammed healing skill " . healInfo . " with key: " . assignedKey . " (" . spamCount . " times)")
            } else {
                UpdateHealerStatus("Spammed healing skill " . healInfo . " by clicking (" . spamCount . " times)")
            }

            return true
        }
    }
    
    UpdateHealerStatus("No healing skills were found on screen.")
return false
}


DrawHollowRectangle(X1, Y1, X2, Y2, Name, BoxColor, IndicatorColor) {
    global BoundingBoxes

    Width := X2 - X1 + 1
    Height := Y2 - Y1 + 1

    IndicatorWidth := Width + 10
    IndicatorHeight := Height + 10
    IndicatorX1 := X1 - 5
    IndicatorY1 := Y1 - 5
    IndicatorX2 := IndicatorX1 + IndicatorWidth - 1
    IndicatorY2 := IndicatorY1 + IndicatorHeight - 1

    IndTopName := "IndTop" . A_Now . A_MSec
    Gui, %IndTopName%:New, +AlwaysOnTop -MaximizeBox -MinimizeBox +LastFound +ToolWindow -Caption, %Name%_IndTop
    Gui, %IndTopName%:Color, %IndicatorColor%
    WinSet, Transparent, 200
    Gui, %IndTopName%:Show, x%IndicatorX1% y%IndicatorY1% w%IndicatorWidth% h1 NoActivate
    BoundingBoxes.Push({hwnd: WinExist(), name: IndTopName})

    IndBottomName := "IndBottom" . A_Now . A_MSec
    Gui, %IndBottomName%:New, +AlwaysOnTop -MaximizeBox -MinimizeBox +LastFound +ToolWindow -Caption, %Name%_IndBottom
    Gui, %IndBottomName%:Color, %IndicatorColor%
    WinSet, Transparent, 200
    Gui, %IndBottomName%:Show, x%IndicatorX1% y%IndicatorY2% w%IndicatorWidth% h1 NoActivate
    BoundingBoxes.Push({hwnd: WinExist(), name: IndBottomName})

    IndLeftName := "IndLeft" . A_Now . A_MSec
    Gui, %IndLeftName%:New, +AlwaysOnTop -MaximizeBox -MinimizeBox +LastFound +ToolWindow -Caption, %Name%_IndLeft
    Gui, %IndLeftName%:Color, %IndicatorColor%
    WinSet, Transparent, 200
    Gui, %IndLeftName%:Show, x%IndicatorX1% y%IndicatorY1% w1 h%IndicatorHeight% NoActivate
    BoundingBoxes.Push({hwnd: WinExist(), name: IndLeftName})

    IndRightName := "IndRight" . A_Now . A_MSec
    Gui, %IndRightName%:New, +AlwaysOnTop -MaximizeBox -MinimizeBox +LastFound +ToolWindow -Caption, %Name%_IndRight
    Gui, %IndRightName%:Color, %IndicatorColor%
    WinSet, Transparent, 200
    Gui, %IndRightName%:Show, x%IndicatorX2% y%IndicatorY1% w1 h%IndicatorHeight% NoActivate
    BoundingBoxes.Push({hwnd: WinExist(), name: IndRightName})
}

ClearBoundingBoxes() {
    global BoundingBoxes

    for index, boxInfo in BoundingBoxes {
        Gui, % boxInfo.name . ":Destroy"
    }
    BoundingBoxes := []
}

RemoveToolTip:
    ToolTip
return

InitializePatternCounter() {
    highestNumber := 0

    for patternName, patternValue in patterns {
        if (SubStr(patternName, 1, 4) = "heal") {
            numberPart := SubStr(patternName, 5)
            if numberPart is integer
            {
                if (numberPart > highestNumber)
                    highestNumber := numberPart
            }
        }
    }

    patternCounter := highestNumber + 1
}

SavePattern(patternName, patternText, keyAssignment) {
    FileEncoding, UTF-8
    IniWrite, %patternText%, %iniFile%, Patterns, %patternName%
    IniWrite, %keyAssignment%, %iniFile%, PatternKeys, %patternName%
    FileEncoding
    patterns[patternName] := patternText
    patternKeys[patternName] := keyAssignment
}

GetPattern(patternName) {
    if (patterns.HasKey(patternName))
        return patterns[patternName]
return ""
}

LoadPattern(patternName) {
    IniRead, loadedPattern, %iniFile%, Patterns, %patternName%, %A_Space%
    if (loadedPattern != "") {
        patterns[patternName] := loadedPattern
        return loadedPattern
    }
return ""
}

LoadAllPatterns() {
    ; Load patterns
    IniRead, patternNames, %iniFile%, Patterns
    if (patternNames != "ERROR") {
        Loop, Parse, patternNames, `n
        {
            if (A_LoopField != "") {
                ; Find first equals sign position
                equalsPos := InStr(A_LoopField, "=")
                if (equalsPos > 0) {
                    patternName := SubStr(A_LoopField, 1, equalsPos - 1)
                    patternText := SubStr(A_LoopField, equalsPos + 1)
                    patterns[patternName] := patternText
                }
            }
        }
    }
    
    ; Load pattern keys
    IniRead, patternKeyNames, %iniFile%, PatternKeys
    if (patternKeyNames != "ERROR") {
        Loop, Parse, patternKeyNames, `n
        {
            if (A_LoopField != "") {
                ; Find first equals sign position
                equalsPos := InStr(A_LoopField, "=")
                if (equalsPos > 0) {
                    patternName := SubStr(A_LoopField, 1, equalsPos - 1)
                    keyAssignment := SubStr(A_LoopField, equalsPos + 1)
                    patternKeys[patternName] := keyAssignment
                }
            }
        }
    }
    
    ; Load pattern custom names
    IniRead, patternNamesList, %iniFile%, PatternNames
    if (patternNamesList != "ERROR") {
        nameCount := 0
        Loop, Parse, patternNamesList, `n
        {
            if (A_LoopField != "") {
                ; Find first equals sign position
                equalsPos := InStr(A_LoopField, "=")
                if (equalsPos > 0) {
                    patternName := SubStr(A_LoopField, 1, equalsPos - 1)
                    customName := SubStr(A_LoopField, equalsPos + 1)
                    patternNames[patternName] := customName
                    nameCount++
                }
            }
        }
        if (nameCount > 0) {
            UpdateHealerStatus("Loaded " . nameCount . " custom heal names from INI")
        }
    }

    patternCount := patterns.Count()
    if (patternCount > 0)
        UpdateHealerStatus("Loaded " . patternCount . " pattern(s) successfully.")
        
    ; Also show custom names count at startup
    nameCount := 0
    for patternName, customName in patternNames {
        if (patterns.HasKey(patternName) && SubStr(patternName, 1, 4) = "heal") {
            nameCount++
        }
    }
    if (nameCount > 0) {
        UpdateHealerStatus("Loaded " . nameCount . " custom heal names at startup")
    }
}

RefreshHealSkillsList() {
    ; This function now just triggers a priority list refresh
    ; since we're using the same approach as DPS tab
    RefreshHealPriorityList()
}

CreateHealKeyInputs() {
    global patterns, patternKeys
    
    healIndex := 1
    for patternName, patternText in patterns {
        if (SubStr(patternName, 1, 4) = "heal" && healIndex <= 3) {
            ; For now, just update status with available heals
            ; We'll handle key assignment through a different method
            healIndex++
        }
    }
}

AssignHealKeys:
    ; Show available heal skills and let user assign keys
    healList := "=== ASSIGN KEYS TO HEALING SKILLS ===`n`n"
    healCount := 0
    
    for patternName, patternText in patterns {
        if (SubStr(patternName, 1, 4) = "heal") {
            healCount++
            displayName := GetDisplayName(patternName)
            currentKey := patternKeys.HasKey(patternName) ? patternKeys[patternName] : "(none)"
            
            healList .= healCount . ". " . displayName . " [" . patternName . "]`n"
            healList .= "     Current Key: " . currentKey . "`n`n"
        }
    }
    
    if (healCount = 0) {
        UpdateHealerStatus("No healing skills to assign keys to. Capture some skills first.")
        return
    }
    
    healList .= "`nEnter the number of the healing skill to assign a key to:"
    
    InputBox, healNumber, Assign Heal Key, %healList%, , 400, 300
    if (ErrorLevel)
        return
    
    ; Find the selected heal
    currentIndex := 1
    selectedHeal := ""
    for patternName, patternText in patterns {
        if (SubStr(patternName, 1, 4) = "heal") {
            if (currentIndex = healNumber) {
                selectedHeal := patternName
                break
            }
            currentIndex++
        }
    }
    
    if (selectedHeal = "") {
        UpdateHealerStatus("Invalid healing skill number selected.")
        return
    }
    
    ; Get key assignment
    selectedDisplayName := GetDisplayName(selectedHeal)
    currentKey := patternKeys.HasKey(selectedHeal) ? patternKeys[selectedHeal] : ""
    keyPrompt := "=== ASSIGN KEY ===`n`nHealing Skill: " . selectedDisplayName . "`nID: " . selectedHeal . "`nCurrent Key: " . currentKey . "`n`nEnter new key (examples: 1, 2, F1, F2, etc.):"
    InputBox, newKey, Assign Key to Healing Skill, %keyPrompt%, , 400, 200, , , , , %currentKey%
    if (ErrorLevel)
        return
    
    ; Save the assignment
    patternKeys[selectedHeal] := newKey
    SavePatternKey(selectedHeal, newKey)
    UpdateHealerStatus("Assigned key '" . newKey . "' to '" . selectedDisplayName . "' [" . selectedHeal . "] and saved to INI")
    RefreshHealPriorityList()
return

RenameHealSkills:
    if (patterns.Count() = 0) {
        UpdateHealerStatus("No healing skills to rename.")
        return
    }
    
    ; Build skill list and selection array in one pass
    healList := "=== RENAME HEALING SKILLS ===`n`n"
    skillArray := []
    
    for patternName, patternText in patterns {
        if (SubStr(patternName, 1, 4) = "heal") {
            skillArray.Push(patternName)
            displayName := GetDisplayName(patternName)
            status := (displayName != patternName) ? "(Custom)" : "(Default)"
            healList .= skillArray.Length() . ". " . displayName . " [" . patternName . "] " . status . "`n"
        }
    }
    
    ; Create scrollable GUI instead of InputBox
    Gui, RenameHealSelect:New, +Resize, Rename Heal Skill
    Gui, RenameHealSelect:Add, Edit, x10 y10 w580 h320 ReadOnly VScroll, %healList%`n`nEnter skill number:
    Gui, RenameHealSelect:Add, Edit, x10 y340 w100 h20 vHealNumberInput
    Gui, RenameHealSelect:Add, Button, x120 y340 w60 h20 gRenameHealSelectOK, OK
    Gui, RenameHealSelect:Add, Button, x190 y340 w60 h20 gRenameHealSelectCancel, Cancel
    Gui, RenameHealSelect:Show, w600 h380
    return
    
    RenameHealSelectOK:
        Gui, RenameHealSelect:Submit
        healNumber := HealNumberInput
        if (healNumber < 1 || healNumber > skillArray.Length()) {
            UpdateHealerStatus("Invalid selection.")
            return
        }
        Gui, RenameHealSelect:Destroy
        
        selectedHeal := skillArray[healNumber]
        currentDisplayName := GetDisplayName(selectedHeal)
        
        InputBox, newName, Rename Heal Skill, Original: %selectedHeal%`nCurrent: %currentDisplayName%`n`nNew name:, , 400, 180, , , , , %currentDisplayName%
        if (ErrorLevel || newName = "") {
            if (!ErrorLevel) UpdateHealerStatus("Name cannot be empty.")
            return
        }
        
        ; Update in-memory object directly
        patternNames[selectedHeal] := newName
        SavePatternName(selectedHeal, newName)
        UpdateHealerStatus("Renamed '" . selectedHeal . "' to '" . newName . "'")
        
        ; Force refresh with timer
        SetTimer, ForceRefreshHeal, -50
        return
    
    RenameHealSelectCancel:
        Gui, RenameHealSelect:Destroy
return

ReloadCustomNames() {
    global patterns, patternNames, iniFile
    
    ; Clear current names
    patternNames := {}
    
    ; Reload pattern custom names
    IniRead, patternNamesList, %iniFile%, PatternNames
    if (patternNamesList != "ERROR") {
        nameCount := 0
        Loop, Parse, patternNamesList, `n
        {
            if (A_LoopField != "") {
                parts := StrSplit(A_LoopField, "=", " `t")
                if (parts.Length() >= 2) {
                    patternName := parts[1]
                    customName := parts[2]
                    patternNames[patternName] := customName
                    nameCount++
                }
            }
        }
    }
}



LoadAllHealKeys:
    global patterns, patternKeys, iniFile
    
    ; Load all key assignments from INI
    keyLoadCount := 0
    
    ; Read the PatternKeys section
    IniRead, patternKeyNames, %iniFile%, PatternKeys
    if (patternKeyNames != "ERROR") {
        Loop, Parse, patternKeyNames, `n
        {
            parts := StrSplit(A_LoopField, "=", " `t")
            if (parts.Length() >= 2) {
                patternName := parts[1]
                keyAssignment := parts[2]
                
                ; Only load if it's a heal pattern
                if (SubStr(patternName, 1, 4) = "heal") {
                    patternKeys[patternName] := keyAssignment
                    keyLoadCount++
                }
            }
        }
    }
    
    UpdateHealerStatus("Loaded " . keyLoadCount . " heal key assignments from INI file")
    RefreshHealSkillsList()
return

ShowHealKeysStatus:
    statusMsg := "=== HEAL SKILLS STATUS ===`r`n`r`nINI: " . iniFile . "`r`n`r`n"
    
    if (patterns.Count() = 0) {
        statusMsg .= "No healing skills captured yet.`r`n"
    } else {
        healCount := 0
        for patternName, patternText in patterns {
            if (SubStr(patternName, 1, 4) = "heal") {
                displayName := GetDisplayName(patternName)
                key := patternKeys.HasKey(patternName) ? patternKeys[patternName] : "Click"
                statusMsg .= ++healCount . ". " . displayName . " [" . patternName . "] - " . key . "`r`n"
            }
        }
        
        statusMsg .= "`r`n=== PRIORITY ORDER ===`r`n"
        for index, priorityPattern in healPriorities {
            if (patterns.HasKey(priorityPattern))
                statusMsg .= index . ". " . GetDisplayName(priorityPattern) . "`r`n"
        }
    }
    
    UpdateHealerStatus(statusMsg)
return

ShowSavedHeals:
    global patterns, patternNames, patternKeys
    
    ; Create comprehensive list of all saved healing skills
    healList := "=== ALL SAVED HEALING SKILLS ===`n`n"
    healCount := 0
    
    for patternName, patternText in patterns {
        if (SubStr(patternName, 1, 4) = "heal") {
            healCount++
            
            ; Get display name
            displayName := GetDisplayName(patternName)
            
            ; Get assigned key
            assignedKey := patternKeys.HasKey(patternName) ? patternKeys[patternName] : "(none)"
            
            ; Format: heal1 = Greater Heal [Key: 1]
            if (displayName != patternName) {
                healList .= patternName . " = " . displayName . "`n"
            } else {
                healList .= patternName . " (no custom name)`n"
            }
            healList .= "    Key: " . assignedKey . "`n`n"
        }
    }
    
    if (healCount = 0) {
        healList .= "No healing skills have been captured yet.`n`n"
        healList .= "Use 'Add Healing Skill' to capture some healing skills first."
    } else {
        healList .= "Total: " . healCount . " healing skills saved`n`n"
        healList .= "• Use 'Rename Skills' to set custom names`n"
        healList .= "• Use 'Assign Heal Keys' to set keyboard shortcuts"
    }
    
    ; Show in a message box for easy viewing
    MsgBox, 0, Saved Healing Skills, %healList%
return

UpdatePatternKey:
    global patternKeys
    
    ; Get the control name that triggered this
    GuiControlGet, controlName, Focus
    
    ; Get pattern name from mapping
    patternName := HealControlMap_%controlName%
    
    ; Get the new key value
    GuiControlGet, newKey,, %controlName%
    
    ; Save the key assignment
    patternKeys[patternName] := newKey
    SavePatternKey(patternName, newKey)
    
    UpdateHealerStatus("Updated key for '" . patternName . "' to: " . newKey)
return

SavePatternKey(patternName, keyAssignment) {
    FileEncoding, UTF-8
    IniWrite, %keyAssignment%, %iniFile%, PatternKeys, %patternName%
    FileEncoding
}

GetDisplayName(patternName) {
    global patternNames
    
    ; Debug what's in patternNames
    if (patternNames.HasKey(patternName)) {
        customName := patternNames[patternName]
        if (customName != "") {
            return customName
        }
    }
    return patternName ; fallback to original name
}

SavePatternName(patternName, customName) {
    global iniFile, patternNames
    
    ; Write to INI file
    FileEncoding, UTF-8
    IniWrite, %customName%, %iniFile%, PatternNames, %patternName%
    FileEncoding
    
    ; Update in-memory storage
    patternNames[patternName] := customName
}

UpdateHealerStatus(message) {
    global HealerStatusText
    
    ; Get current time
    FormatTime, timeStamp,, HH:mm:ss
    
    ; Add timestamp to message
    newMessage := "[" . timeStamp . "] " . message . "`r`n"
    
    ; Append to existing text (keep last 15 lines for better history)
    HealerStatusText .= newMessage
    
    ; Keep only the last 15 lines to prevent overflow
    lines := StrSplit(HealerStatusText, "`r`n")
    if (lines.Length() > 15) {
        HealerStatusText := ""
        Loop % Min(15, lines.Length()) {
            if (lines[lines.Length() - 15 + A_Index] != "") {
                HealerStatusText .= lines[lines.Length() - 15 + A_Index] . "`r`n"
            }
        }
    }
    
    ; Update the GUI control (simple approach that works)
    GuiControl,, HealerStatusEdit, %HealerStatusText%
}



; ; ========= KEYPRESSER FUNCTIONS =========
; SelectKeyWindow:
;     Gui, Hide
    
;     MsgBox, 4, Select Window, Click OK then click on the window you want to target.
;     KeyWait, RButton, D
;     MouseGetPos,,, WinID
;     WinGetTitle, title, ahk_id %WinID%
;     WinGet, pid, PID, ahk_id %WinID%
;     MsgBox, You have selected: %title%
;     WinGetTitle, WinTitle, ahk_id %WinID%
    
;     if (WinTitle != "") {
;         TargetWindow := WinTitle
;         win1 := WinID
;         GuiControl,, TargetWindowEdit, %TargetWindow%
;         UpdateStatus1("Window: " . TargetWindow)
;         UpdateStatus2("Window: " . TargetWindow)
;         UpdateStatus3("Window: " . TargetWindow)
;     } else {
;         UpdateStatus1("No window selected")
;         UpdateStatus2("No window selected")
;         UpdateStatus3("No window selected")
;     }
    
;     Gui, Show
; return

StartStop1:
    Gui, Submit, NoHide
    
    KeyCombination1 := KeyCombinationEdit1
    KeyDelay1 := KeyDelayEdit1
    TimerInterval1 := TimerIntervalEdit1
    
    if (!IsRunning1) {
        if (TargetWindow = "") {
            UpdateStatus1("Error: Select target window")
            return
        }
        if (KeyCombination1 = "") {
            UpdateStatus1("Error: Enter key sequence")
            return
        }
        
        KeySequence1 := StrSplit(KeyCombination1, "|")
        
        SetTimer, CheckExecutions, 50
        IsRunning1 := true
        GuiControl,, StartStop1, Stop1
        UpdateStatus1("Running: " . KeyCombination1)
        if (!SkipInitial1)
            Gosub, SendKeys1

        NextExecutionTime1 := A_TickCount + (TimerInterval1 * 60 * 1000)
    } else {
        IsRunning1 := false
        GuiControl,, StartStop1, Start1
        UpdateStatus1("Stopped")
        GuiControl,, CountdownText1, Next: --
    }
return

StartStop2:
    Gui, Submit, NoHide
    
    KeyCombination2 := KeyCombinationEdit2
    KeyDelay2 := KeyDelayEdit2
    TimerInterval2 := TimerIntervalEdit2
    
    if (!IsRunning2) {
        if (TargetWindow = "") {
            UpdateStatus2("Error: Select target window")
            return
        }
        if (KeyCombination2 = "") {
            UpdateStatus2("Error: Enter key sequence")
            return
        }
        
        KeySequence2 := StrSplit(KeyCombination2, "|")
        
        SetTimer, CheckExecutions, 50
        IsRunning2 := true
        GuiControl,, StartStop2, Stop2
        UpdateStatus2("Running: " . KeyCombination2)
        if (!SkipInitial1)
            Gosub, SendKeys2

        NextExecutionTime2 := A_TickCount + (TimerInterval2 * 60 * 1000)
    } else {
        IsRunning2 := false
        GuiControl,, StartStop2, Start2
        UpdateStatus2("Stopped")
        GuiControl,, CountdownText2, Next: --
    }
return

StartStop3:
    Gui, Submit, NoHide
    
    KeyCombination3 := KeyCombinationEdit3
    KeyDelay3 := KeyDelayEdit3
    TimerInterval3 := TimerIntervalEdit3
    
    if (!IsRunning3) {
        if (TargetWindow = "") {
            UpdateStatus3("Error: Select target window")
            return
        }
        if (KeyCombination3 = "") {
            UpdateStatus3("Error: Enter key sequence")
            return
        }
        
        KeySequence3 := StrSplit(KeyCombination3, "|")
        
        SetTimer, CheckExecutions, 50
        IsRunning3 := true
        GuiControl,, StartStop3, Stop3
        UpdateStatus3("Running: " . KeyCombination3)
        if (!SkipInitial1)
            Gosub, SendKeys3

        NextExecutionTime3 := A_TickCount + (TimerInterval3 * 60 * 1000)
    } else {
        IsRunning3 := false
        GuiControl,, StartStop3, Start3
        UpdateStatus3("Stopped")
        GuiControl,, CountdownText3, Next: --
    }
return

StopAll:
    if (IsRunning1) {
        IsRunning1 := false
        GuiControl,, StartStop1, Start1
        UpdateStatus1("Stopped")
        GuiControl,, CountdownText1, Next: --
    }
    if (IsRunning2) {
        IsRunning2 := false
        GuiControl,, StartStop2, Start2
        UpdateStatus2("Stopped")
        GuiControl,, CountdownText2, Next: --
    }
    if (IsRunning3) {
        IsRunning3 := false
        GuiControl,, StartStop3, Start3
        UpdateStatus3("Stopped")
        GuiControl,, CountdownText3, Next: --
    }
    SetTimer, CheckExecutions, Off
    StopWindowMonitoring()
return

Stop1:
    if (IsRunning1) {
        IsRunning1 := false
        GuiControl,, StartStop1, Start1
        UpdateStatus1("Stopped")
        GuiControl,, CountdownText1, Next: --
    }
return

Stop2:
    if (IsRunning2) {
        IsRunning2 := false
        GuiControl,, StartStop2, Start2
        UpdateStatus2("Stopped")
        GuiControl,, CountdownText2, Next: --
    }
return

Stop3:
    if (IsRunning3) {
        IsRunning3 := false
        GuiControl,, StartStop3, Start3
        UpdateStatus3("Stopped")
        GuiControl,, CountdownText3, Next: --
    }
return

SendKeys1:
    IfWinNotExist, ahk_id %win1%
    {
        UpdateStatus1("Window closed - stopping")
        IsRunning1 := false
        GuiControl,, StartStop1, Start1
        GuiControl,, CountdownText1, Next: --
        return
    }
    
    ; Keypresser has lowest priority - yield to healing and DPS
    if (isSystemBusy) {
        ; Delay execution by 1 second if system is busy
        NextExecutionTime1 := A_TickCount + 1000
        UpdateStatus1("Delayed - DPS/Healing active")
        return
    }
    
    ; Set system busy for buff sequence
    isSystemBusy := true
      ; Activate the target window
    ; if (TargetGameWindow != "") {
    ;     WinActivate, ahk_id %win1%
    ;     Sleep, 30
    ; }
        ;ActivateGameWindow()
    Loop % KeySequence1.Length()
    {
        CurrentKey := KeySequence1[A_Index]
        if (CurrentKey != "") {
            ; Check for modifier keys and handle them separately
            hasCtrl := InStr(CurrentKey, "^")
            hasAlt := InStr(CurrentKey, "!")
            hasShift := InStr(CurrentKey, "+")
            
            ; Extract the base key (remove modifiers)
            baseKey := CurrentKey
            if (hasCtrl)
                baseKey := StrReplace(baseKey, "^", "")
            if (hasAlt)
                baseKey := StrReplace(baseKey, "!", "")
            if (hasShift)
                baseKey := StrReplace(baseKey, "+", "")
            
            ; Send modifier keys down
                    if (hasCtrl)
                        ControlSend, , {Ctrl down}, ahk_id %win1%
                    if (hasAlt)
                        ControlSend, , {Alt down}, ahk_id %win1%
                    if (hasShift)
                        ControlSend, , {Shift down}, ahk_id %win1%
                    
                    ; Send the base key
                    ControlSend, , {%baseKey% down}, ahk_id %win1%
                    Sleep, 50
                    ControlSend, , {%baseKey% up}, ahk_id %win1%
                    
                    ; Send modifier keys up (in reverse order)
                    if (hasShift)
                        ControlSend, , {Shift up}, ahk_id %win1%
                    if (hasAlt)
                        ControlSend, , {Alt up}, ahk_id %win1%
                    if (hasCtrl)
                        ControlSend, , {Ctrl up}, ahk_id %win1%
            
            if (KeyDelay1 > 0 && A_Index < KeySequence1.Length()) {
                DelayMS1 := KeyDelay1 * 1000
                Sleep, %DelayMS1%
            }
        }
    }

    
    ; Release system busy flag
    isSystemBusy := false
    
    NextExecutionTime1 := A_TickCount + (TimerInterval1 * 60 * 1000)
    UpdateStatus1("Buffs executed - yielding to DPS/Heal")
return
SendKeys2:
    IfWinNotExist, ahk_id %win1%
    {
        UpdateStatus2("Window closed - stopping")
        IsRunning2 := false
        GuiControl,, StartStop2, Start2
        GuiControl,, CountdownText2, Next: --
        return
    }
    
    ; Keypresser has lowest priority - yield to healing and DPS
    if (isSystemBusy) {
        ; Delay execution by 1 second if system is busy
        NextExecutionTime2 := A_TickCount + 1000
        UpdateStatus2("Delayed - DPS/Healing active")
        return
    }
    
    ; Set system busy for buff sequence
    isSystemBusy := true
    ;WinActivate, ahk_id %win1%
    Sleep, 50
    ;ActivateGameWindow()
    Loop % KeySequence2.Length()
    {
        CurrentKey := KeySequence2[A_Index]
        if (CurrentKey != "") {
            ; Check for modifier keys and handle them separately
            hasCtrl := InStr(CurrentKey, "^")
            hasAlt := InStr(CurrentKey, "!")
            hasShift := InStr(CurrentKey, "+")
            
            ; Extract the base key (remove modifiers)
            baseKey := CurrentKey
            if (hasCtrl)
                baseKey := StrReplace(baseKey, "^", "")
            if (hasAlt)
                baseKey := StrReplace(baseKey, "!", "")
            if (hasShift)
                baseKey := StrReplace(baseKey, "+", "")
            
            ; Send modifier keys down
                    if (hasCtrl)
                        ControlSend, , {Ctrl down}, ahk_id %win1%
                    if (hasAlt)
                        ControlSend, , {Alt down}, ahk_id %win1%
                    if (hasShift)
                        ControlSend, , {Shift down}, ahk_id %win1%
                    
                    ; Send the base key
                    ControlSend, , {%baseKey% down}, ahk_id %win1%
                    Sleep, 50
                    ControlSend, , {%baseKey% up}, ahk_id %win1%
                    
                    ; Send modifier keys up (in reverse order)
                    if (hasShift)
                        ControlSend, , {Shift up}, ahk_id %win1%
                    if (hasAlt)
                        ControlSend, , {Alt up}, ahk_id %win1%
                    if (hasCtrl)
                        ControlSend, , {Ctrl up}, ahk_id %win1%
            
            if (KeyDelay2 > 0 && A_Index < KeySequence2.Length()) {
                DelayMS2 := KeyDelay2 * 1000
                Sleep, %DelayMS2%
            }
        }
    }
    
    ; Release system busy flag
    isSystemBusy := false
    
    NextExecutionTime2 := A_TickCount + (TimerInterval2 * 60 * 1000)
    UpdateStatus2("Buffs executed - yielding to DPS/Heal")
return

SendKeys3:
    IfWinNotExist, ahk_id %win1%
    {
        UpdateStatus3("Window closed - stopping")
        IsRunning3 := false
        GuiControl,, StartStop3, Start3
        GuiControl,, CountdownText3, Next: --
        return
    }
    
    ; Keypresser has lowest priority - yield to healing and DPS
    if (isSystemBusy) {
        ; Delay execution by 1 second if system is busy
        NextExecutionTime3 := A_TickCount + 1000
        UpdateStatus3("Delayed - DPS/Healing active")
        return
    }
    
    ; Set system busy for buff sequence
    isSystemBusy := true
    ;WinActivate, ahk_id %win1%
    Sleep, 50
    ;ActivateGameWindow()
    
    Loop % KeySequence3.Length()
    {
        CurrentKey := KeySequence3[A_Index]
        if (CurrentKey != "") {
            ; Check for modifier keys and handle them separately
            hasCtrl := InStr(CurrentKey, "^")
            hasAlt := InStr(CurrentKey, "!")
            hasShift := InStr(CurrentKey, "+")
            
            ; Extract the base key (remove modifiers)
            baseKey := CurrentKey
            if (hasCtrl)
                baseKey := StrReplace(baseKey, "^", "")
            if (hasAlt)
                baseKey := StrReplace(baseKey, "!", "")
            if (hasShift)
                baseKey := StrReplace(baseKey, "+", "")
            
            ; Send modifier keys down
                    if (hasCtrl)
                        ControlSend, , {Ctrl down}, ahk_id %win1%
                    if (hasAlt)
                        ControlSend, , {Alt down}, ahk_id %win1%
                    if (hasShift)
                        ControlSend, , {Shift down}, ahk_id %win1%
                    
                    ; Send the base key
                    ControlSend, , {%baseKey% down}, ahk_id %win1%
                    Sleep, 50
                    ControlSend, , {%baseKey% up}, ahk_id %win1%
                    
                    ; Send modifier keys up (in reverse order)
                    if (hasShift)
                        ControlSend, , {Shift up}, ahk_id %win1%
                    if (hasAlt)
                        ControlSend, , {Alt up}, ahk_id %win1%
                    if (hasCtrl)
                        ControlSend, , {Ctrl up}, ahk_id %win1%
            
            if (KeyDelay3 > 0 && A_Index < KeySequence3.Length()) {
                DelayMS3 := KeyDelay3 * 1000
                Sleep, %DelayMS3%
            }
        }
    }
    
    ; Release system busy flag
    isSystemBusy := false
    
    NextExecutionTime3 := A_TickCount + (TimerInterval3 * 60 * 1000)
    UpdateStatus3("Buffs executed - yielding to DPS/Heal")
return


CheckExecutions:
    CurrentTime := A_TickCount
    
    if (IsRunning1 && CurrentTime >= NextExecutionTime1) {
        Gosub, SendKeys1
    }
    
    if (IsRunning2 && CurrentTime >= NextExecutionTime2) {
        Gosub, SendKeys2
    }
    
    if (IsRunning3 && CurrentTime >= NextExecutionTime3) {
        Gosub, SendKeys3
    }
    
    if (IsRunning1) {
        TimeRemaining := NextExecutionTime1 - CurrentTime
        if (TimeRemaining <= 0) {
            MinutesLeft := 0
        } else {
            MinutesLeft := Round(TimeRemaining / 60000, 2)
        }
        GuiControl,, CountdownText1, Next: %MinutesLeft%m
    }
    
    if (IsRunning2) {
        TimeRemaining := NextExecutionTime2 - CurrentTime
        if (TimeRemaining <= 0) {
            MinutesLeft := 0
        } else {
            MinutesLeft := Round(TimeRemaining / 60000, 2)
        }
        GuiControl,, CountdownText2, Next: %MinutesLeft%m
    }
    
    if (IsRunning3) {
        TimeRemaining := NextExecutionTime3 - CurrentTime
        if (TimeRemaining <= 0) {
            MinutesLeft := 0
        } else {
            MinutesLeft := Round(TimeRemaining / 60000, 2)
        }
        GuiControl,, CountdownText3, Next: %MinutesLeft%m
    }
    
    if (!IsRunning1 && !IsRunning2 && !IsRunning3) {
        SetTimer, CheckExecutions, Off
    }
return

SaveKeypresserSettings:
    Gui, Submit, NoHide
    
    KeyCombination1 := KeyCombinationEdit1
    KeyDelay1 := KeyDelayEdit1
    TimerInterval1 := TimerIntervalEdit1
    KeyCombination2 := KeyCombinationEdit2
    KeyDelay2 := KeyDelayEdit2
    TimerInterval2 := TimerIntervalEdit2
    KeyCombination3 := KeyCombinationEdit3
    KeyDelay3 := KeyDelayEdit3
    TimerInterval3 := TimerIntervalEdit3
    
    FileEncoding, UTF-8
    IniWrite, %TargetWindow%, %SettingsFile%, Settings, TargetWindow
    IniWrite, %win1%, %SettingsFile%, Settings, win1
    
    IniWrite, %KeyCombination1%, %SettingsFile%, Sequence1, KeyCombination
    IniWrite, %KeyDelay1%, %SettingsFile%, Sequence1, KeyDelay
    IniWrite, %TimerInterval1%, %SettingsFile%, Sequence1, TimerInterval
    
    IniWrite, %KeyCombination2%, %SettingsFile%, Sequence2, KeyCombination
    IniWrite, %KeyDelay2%, %SettingsFile%, Sequence2, KeyDelay
    IniWrite, %TimerInterval2%, %SettingsFile%, Sequence2, TimerInterval
    
    IniWrite, %KeyCombination3%, %SettingsFile%, Sequence3, KeyCombination
    IniWrite, %KeyDelay3%, %SettingsFile%, Sequence3, KeyDelay
    IniWrite, %TimerInterval3%, %SettingsFile%, Sequence3, TimerInterval
    FileEncoding
    
    UpdateStatus1("Settings saved")
    UpdateStatus2("Settings saved")
    UpdateStatus3("Settings saved")
return

LoadKeypresserSettings:
    IniRead, TargetWindow, %SettingsFile%, Settings, TargetWindow, %A_Space%
    IniRead, win1, %SettingsFile%, Settings, win1, %A_Space%
    
    IniRead, KeyCombination1, %SettingsFile%, Sequence1, KeyCombination, %A_Space%
    IniRead, KeyDelay1, %SettingsFile%, Sequence1, KeyDelay, 0.1
    IniRead, TimerInterval1, %SettingsFile%, Sequence1, TimerInterval, 1
    
    IniRead, KeyCombination2, %SettingsFile%, Sequence2, KeyCombination, %A_Space%
    IniRead, KeyDelay2, %SettingsFile%, Sequence2, KeyDelay, 0.1
    IniRead, TimerInterval2, %SettingsFile%, Sequence2, TimerInterval, 2
    
    IniRead, KeyCombination3, %SettingsFile%, Sequence3, KeyCombination, %A_Space%
    IniRead, KeyDelay3, %SettingsFile%, Sequence3, KeyDelay, 0.1
    IniRead, TimerInterval3, %SettingsFile%, Sequence3, TimerInterval, 3
    
    if (TargetWindow = "ERROR")
        TargetWindow := ""
    if (win1 = "ERROR")
        win1 := ""
    if (KeyCombination1 = "ERROR")
        KeyCombination1 := ""
    if (KeyCombination2 = "ERROR")
        KeyCombination2 := ""
    if (KeyCombination3 = "ERROR")
        KeyCombination3 := ""
    
    GuiControl,, TargetWindowEdit, %TargetWindow%
    GuiControl,, KeyCombinationEdit1, %KeyCombination1%
    GuiControl,, KeyDelayEdit1, %KeyDelay1%
    GuiControl,, TimerIntervalEdit1, %TimerInterval1%
    GuiControl,, KeyCombinationEdit2, %KeyCombination2%
    GuiControl,, KeyDelayEdit2, %KeyDelay2%
    GuiControl,, TimerIntervalEdit2, %TimerInterval2%
    GuiControl,, KeyCombinationEdit3, %KeyCombination3%
    GuiControl,, KeyDelayEdit3, %KeyDelay3%
    GuiControl,, TimerIntervalEdit3, %TimerInterval3%
    UpdateStatus1("Settings loaded")
    UpdateStatus2("Settings loaded")
    UpdateStatus3("Settings loaded")
return

UpdateStatus1(Message) {
    GuiControl,, StatusText1, %Message%
}

UpdateStatus2(Message) {
    GuiControl,, StatusText2, %Message%
}

UpdateStatus3(Message) {
    GuiControl,, StatusText3, %Message%
}

; ========= HEAL PRIORITY FUNCTIONS =========

HealPrioritySelect:
return

MoveHealUp:
    ; Get the currently selected item index from the ListBox
    GuiControlGet, selectedText, , HealPriorityList
    selectedIndex := 0
    
    ; Parse the index from the text (format: "1. SkillName")
    if (selectedText != "") {
        RegExMatch(selectedText, "^(\d+)\.", match)
        selectedIndex := match1
    }
    
    ; Debug info
    UpdateHealerStatus("Debug: Selected text = '" . selectedText . "', Parsed index = " . selectedIndex . ", Total items = " . healPriorities.Length())
    
    if (selectedIndex <= 1 || selectedIndex > healPriorities.Length()) {
        UpdateHealerStatus("Cannot move item up. Select an item first or item is already at top.")
        return
    }
    
    ; Swap with previous item
    temp := healPriorities[selectedIndex]
    healPriorities[selectedIndex] := healPriorities[selectedIndex - 1]
    healPriorities[selectedIndex - 1] := temp
    
    SaveHealPriorities()
    RefreshHealPriorityList()
    
    ; Reselect the moved item
    GuiControl, Choose, HealPriorityList, % selectedIndex - 1
    
    UpdateHealerStatus("Moved heal skill up in priority.")
return

MoveHealDown:
    ; Get the currently selected item index from the ListBox
    GuiControlGet, selectedText, , HealPriorityList
    selectedIndex := 0
    
    ; Parse the index from the text (format: "1. SkillName")
    if (selectedText != "") {
        RegExMatch(selectedText, "^(\d+)\.", match)
        selectedIndex := match1
    }
    
    ; Debug info
    UpdateHealerStatus("Debug: Selected text = '" . selectedText . "', Parsed index = " . selectedIndex . ", Total items = " . healPriorities.Length())
    
    if (selectedIndex <= 0 || selectedIndex >= healPriorities.Length()) {
        UpdateHealerStatus("Cannot move item down. Select an item first or item is already at bottom.")
        return
    }
    
    ; Swap with next item
    temp := healPriorities[selectedIndex]
    healPriorities[selectedIndex] := healPriorities[selectedIndex + 1]
    healPriorities[selectedIndex + 1] := temp
    
    SaveHealPriorities()
    RefreshHealPriorityList()
    
    ; Reselect the moved item
    GuiControl, Choose, HealPriorityList, % selectedIndex + 1
    
    UpdateHealerStatus("Moved heal skill down in priority.")
return

RefreshHealList:
    RefreshHealPriorityList()
    UpdateHealerStatus("Heal priority list refreshed.")
return

RemoveFromHealPriority:
    ; Get the currently selected item index from the ListBox
    GuiControlGet, selectedText, , HealPriorityList
    selectedIndex := 0
    
    ; Parse the index from the text (format: "1. SkillName")
    if (selectedText != "") {
        RegExMatch(selectedText, "^(\d+)\.", match)
        selectedIndex := match1
    }
    
    if (selectedIndex <= 0 || selectedIndex > healPriorities.Length()) {
        UpdateHealerStatus("Select a heal skill to remove from priority.")
        return
    }
    
    removedSkill := healPriorities[selectedIndex]
    displayName := GetDisplayName(removedSkill)
    healPriorities.RemoveAt(selectedIndex)
    
    SaveHealPriorities()
    RefreshHealPriorityList()
    UpdateHealerStatus("Removed '" . displayName . "' from heal priority order (skill still saved).")
return

AddToHealPriority:
    ; Show available heal skills not in priority
    availableHeals := "=== ADD HEAL TO PRIORITY ===`n`n"
    availableCount := 0
    availableSkills := []
    
    for patternName, patternText in patterns {
        if (SubStr(patternName, 1, 4) = "heal") {
            ; Check if already in priority
            inPriority := false
            for index, priorityPattern in healPriorities {
                if (priorityPattern = patternName) {
                    inPriority := true
                    break
                }
            }
            
            if (!inPriority) {
                availableCount++
                availableSkills.Push(patternName)
                displayName := GetDisplayName(patternName)
                availableHeals .= availableCount . ". " . displayName . " [" . patternName . "]`n"
            }
        }
    }
    
    if (availableCount = 0) {
        UpdateHealerStatus("No heal skills available to add (all are already in priority or none saved).")
        return
    }
    
    availableHeals .= "`nEnter the number of the heal to add to priority:"
    
    InputBox, healNumber, Add Heal to Priority, %availableHeals%, , 400, 300
    if (ErrorLevel)
        return
    
    if (healNumber < 1 || healNumber > availableCount) {
        UpdateHealerStatus("Invalid heal number selected.")
        return
    }
    
    selectedSkill := availableSkills[healNumber]
    displayName := GetDisplayName(selectedSkill)
    
    ; Add to end of priority list
    healPriorities.Push(selectedSkill)
    SaveHealPriorities()
    RefreshHealPriorityList()
    UpdateHealerStatus("Added '" . displayName . "' to heal priority order.")
return

RefreshHealPriorityList() {
    ; Clear the listbox
    GuiControl,, HealPriorityList, |
    
    ; Add items in priority order
    itemCount := 0
    for index, priorityPattern in healPriorities {
        if (patterns.HasKey(priorityPattern) && SubStr(priorityPattern, 1, 4) = "heal") {
            itemCount++
            displayName := GetDisplayName(priorityPattern)
            keyInfo := patternKeys.HasKey(priorityPattern) && patternKeys[priorityPattern] != "" ? " (Key: " . patternKeys[priorityPattern] . ")" : " (Click)"
            listItem := index . ". " . displayName . keyInfo
            GuiControl,, HealPriorityList, %listItem%
        }
    }
    
    ; Show count for debugging
    if (itemCount = 0 && healPriorities.Length() > 0) {
        UpdateHealerStatus("Warning: " . healPriorities.Length() . " priorities but 0 valid patterns found")
    }
}

SaveHealPriorities() {
    global iniFile, healPriorities
    
    ; Convert array to comma-separated string
    priorityString := ""
    for index, priorityPattern in healPriorities {
        if (index > 1)
            priorityString .= ","
        priorityString .= priorityPattern
    }
    
    FileEncoding, UTF-8
    IniWrite, %priorityString%, %iniFile%, HealPriorities, Order
    FileEncoding
}

LoadHealPriorities() {
    global iniFile, healPriorities
    
    IniRead, priorityString, %iniFile%, HealPriorities, Order, %A_Space%
    if (priorityString != "" && priorityString != "ERROR") {
        healPriorities := StrSplit(priorityString, ",")
    }
}

SaveHealSettings() {
    global iniFile, healCheckInterval
    
    FileEncoding, UTF-8
    IniWrite, %healCheckInterval%, %iniFile%, HealSettings, CheckInterval
    FileEncoding
}

LoadHealSettings() {
    global iniFile, healCheckInterval
    
    IniRead, loadedInterval, %iniFile%, HealSettings, CheckInterval, 1000
    if (loadedInterval >= 25 && loadedInterval <= 10000) {
        healCheckInterval := loadedInterval
        GuiControl,, HealIntervalInput, %healCheckInterval%
    }
}

; ========= DPS FUNCTIONS =========

AddDPSSkill:
    UpdateDPSStatus("Press 1 when the skill to capture is visable on screen.")
    KeyWait, 1, D
    capturedText := FindText().GetTextFromScreen(x1:=0, y1:=0, x2:=0, y2:=0, Threshold="", ScreenShot:=1, outX, outY)
    Clipboard := capturedText
    patternName := "dps" . dpsCounter
    
    ; Prompt for custom name and key assignment
    InputBox, customName, Name DPS Skill, Enter a name for this DPS skill:, , 300, 130, , , , , %patternName%
    if (ErrorLevel)
        return
    
    if (customName = "")
        customName := patternName
    
    InputBox, assignedKey, Assign Key, Enter a key for this skill (leave empty to click with mouse):, , 300, 130
    if (ErrorLevel)
        return
    
    SaveDPSPattern(patternName, capturedText, assignedKey, customName)
    UpdateDPSStatus("DPS skill captured and saved as '" . customName . "' [" . patternName . "]")
    dpsCounter++
    
    ; Add to priority list at the end
    dpsPriorities.Push(patternName)
    SaveDPSPriorities()
    RefreshDPSPriorityList()
return

TestDPSSkills:
    if (dpsPatterns.Count() = 0) {
        UpdateDPSStatus("No DPS skills captured. Add some skills first.")
        return
    }
    
    UpdateDPSStatus("Testing DPS skills - searching for patterns on screen...")
    
    foundCount := 0
    totalCount := 0
    
    ; Test each DPS pattern
    for patternName, patternText in dpsPatterns {
        totalCount++
        displayName := GetDPSDisplayName(patternName)
        
        ; Search in the skill bar area - convert window-relative to screen coordinates
        WinGetPos, winX, winY,,, ahk_id %win1%
        screenX1 := winX + SkillBarX1
        screenY1 := winY + SkillBarY1
        screenX2 := winX + SkillBarX2
        screenY2 := winY + SkillBarY2
        if (ok := FindText(X, Y, screenX1, screenY1, screenX2, screenY2, 0, 0, patternText)) {
            foundCount++
            UpdateDPSStatus("✓ FOUND: " . displayName . " at coordinates: " . X . ", " . Y)
            
            ; Highlight the found skill
            Try {
                For i, v in ok {
                    if (i <= 2)
                        FindText().MouseTip(ok[i].x, ok[i].y)
                }
            }
        } else {
            UpdateDPSStatus("✗ Not found: " . displayName)
        }
    }
    
    UpdateDPSStatus("Test complete - Found " . foundCount . " out of " . totalCount . " DPS skills on screen.")
return

ClearDPSSkills:
    InputBox, patternToClear, Clear DPS Pattern, Enter the name of the DPS pattern to clear (leave empty to clear all):, , 300, 130
    if (ErrorLevel)
        return

    if (patternToClear = "") {
        dpsPatterns := {}
        dpsPatternKeys := {}
        dpsPatternNames := {}
        dpsPriorities := []
        IniDelete, %iniFile%, DPSPatterns
        IniDelete, %iniFile%, DPSPatternKeys
        IniDelete, %iniFile%, DPSPatternNames
        IniDelete, %iniFile%, DPSPriorities
        dpsCounter := 1
        RefreshDPSPriorityList()
        UpdateDPSStatus("All DPS patterns have been cleared.")
    } else {
        ; Check both pattern name and custom name
        patternToDelete := ""
        for dpsPat, dpsText in dpsPatterns {
            displayName := GetDPSDisplayName(dpsPat)
            if (dpsPat = patternToClear || displayName = patternToClear) {
                patternToDelete := dpsPat
                break
            }
        }
        
        if (patternToDelete != "") {
            dpsPatterns.Delete(patternToDelete)
            dpsPatternKeys.Delete(patternToDelete)
            dpsPatternNames.Delete(patternToDelete)
            
            ; Remove from priority list
            for index, priorityPattern in dpsPriorities {
                if (priorityPattern = patternToDelete) {
                    dpsPriorities.RemoveAt(index)
                    break
                }
            }
            
            IniDelete, %iniFile%, DPSPatterns, %patternToDelete%
            IniDelete, %iniFile%, DPSPatternKeys, %patternToDelete%
            IniDelete, %iniFile%, DPSPatternNames, %patternToDelete%
            SaveDPSPriorities()
            RefreshDPSPriorityList()
            UpdateDPSStatus("DPS pattern '" . patternToClear . "' has been cleared.")
        } else {
            UpdateDPSStatus("DPS pattern '" . patternToClear . "' not found.")
        }
    }
return

AssignDPSKeys:
    ; Show available DPS skills and let user assign keys
    dpsList := "=== ASSIGN KEYS TO DPS SKILLS ===`n`n"
    dpsCount := 0
    
    for patternName, patternText in dpsPatterns {
        dpsCount++
        displayName := GetDPSDisplayName(patternName)
        currentKey := dpsPatternKeys.HasKey(patternName) ? dpsPatternKeys[patternName] : "(none)"
        
        dpsList .= dpsCount . ". " . displayName . " [" . patternName . "]`n"
        dpsList .= "     Current Key: " . currentKey . "`n`n"
    }
    
    if (dpsCount = 0) {
        UpdateDPSStatus("No DPS skills to assign keys to. Capture some skills first.")
        return
    }
    
    dpsList .= "`nEnter the number of the DPS skill to assign a key to:"
    
    InputBox, dpsNumber, Assign DPS Key, %dpsList%, , 400, 300
    if (ErrorLevel)
        return
    
    ; Find the selected DPS skill
    currentIndex := 1
    selectedDPS := ""
    for patternName, patternText in dpsPatterns {
        if (currentIndex = dpsNumber) {
            selectedDPS := patternName
            break
        }
        currentIndex++
    }
    
    if (selectedDPS = "") {
        UpdateDPSStatus("Invalid DPS skill number selected.")
        return
    }
    
    ; Get key assignment
    selectedDisplayName := GetDPSDisplayName(selectedDPS)
    currentKey := dpsPatternKeys.HasKey(selectedDPS) ? dpsPatternKeys[selectedDPS] : ""
    keyPrompt := "=== ASSIGN KEY ===`n`nDPS Skill: " . selectedDisplayName . "`nID: " . selectedDPS . "`nCurrent Key: " . currentKey . "`n`nEnter new key (examples: 1, 2, F1, F2, etc.):"
    InputBox, newKey, Assign Key to DPS Skill, %keyPrompt%, , 400, 200, , , , , %currentKey%
    if (ErrorLevel)
        return
    
    ; Save the assignment
    dpsPatternKeys[selectedDPS] := newKey
    SaveDPSPatternKey(selectedDPS, newKey)
    UpdateDPSStatus("Assigned key '" . newKey . "' to '" . selectedDisplayName . "' [" . selectedDPS . "] and saved to INI")
    RefreshDPSPriorityList()
return

RenameDPSSkills:
    if (dpsPatterns.Count() = 0) {
        UpdateDPSStatus("No DPS skills to rename.")
        return
    }
    
    ; Build skill list and selection array in one pass
    dpsList := "=== RENAME DPS SKILLS ===`n`n"
    skillArray := []
    
    for patternName, patternText in dpsPatterns {
        skillArray.Push(patternName)
        displayName := GetDPSDisplayName(patternName)
        status := (displayName != patternName) ? "(Custom)" : "(Default)"
        dpsList .= skillArray.Length() . ". " . displayName . " [" . patternName . "] " . status . "`n"
    }
    
    ; Create scrollable GUI instead of InputBox
    Gui, RenameDPSSelect:New, +Resize, Rename DPS Skill
    Gui, RenameDPSSelect:Add, Edit, x10 y10 w580 h320 ReadOnly VScroll, %dpsList%`n`nEnter skill number:
    Gui, RenameDPSSelect:Add, Edit, x10 y340 w100 h20 vDPSNumberInput
    Gui, RenameDPSSelect:Add, Button, x120 y340 w60 h20 gRenameDPSSelectOK, OK
    Gui, RenameDPSSelect:Add, Button, x190 y340 w60 h20 gRenameDPSSelectCancel, Cancel
    Gui, RenameDPSSelect:Show, w600 h380
    return
    
    RenameDPSSelectOK:
        Gui, RenameDPSSelect:Submit
        dpsNumber := DPSNumberInput
        if (dpsNumber < 1 || dpsNumber > skillArray.Length()) {
            UpdateDPSStatus("Invalid selection.")
            return
        }
        Gui, RenameDPSSelect:Destroy
        
        selectedDPS := skillArray[dpsNumber]
        currentDisplayName := GetDPSDisplayName(selectedDPS)
        
        InputBox, newName, Rename DPS Skill, Original: %selectedDPS%`nCurrent: %currentDisplayName%`n`nNew name:, , 400, 180, , , , , %currentDisplayName%
        if (ErrorLevel || newName = "") {
            if (!ErrorLevel) UpdateDPSStatus("Name cannot be empty.")
            return
        }
        
        ; Update in-memory object directly
        dpsPatternNames[selectedDPS] := newName
        SaveDPSPatternName(selectedDPS, newName)
        UpdateDPSStatus("Renamed '" . selectedDPS . "' to '" . newName . "'")
        
        ; Force refresh with timer
        SetTimer, ForceRefreshDPS, -50
        return
    
    RenameDPSSelectCancel:
        Gui, RenameDPSSelect:Destroy
return

ShowDPSSkills:
    statusMsg := "=== DPS SKILLS STATUS ===`r`n`r`nINI: " . iniFile . "`r`n`r`n"
    
    if (dpsPatterns.Count() = 0) {
        statusMsg .= "No DPS skills captured yet.`r`n"
    } else {
        dpsCount := 0
        for patternName, patternText in dpsPatterns {
            displayName := GetDPSDisplayName(patternName)
            key := dpsPatternKeys.HasKey(patternName) ? dpsPatternKeys[patternName] : "Click"
            statusMsg .= ++dpsCount . ". " . displayName . " [" . patternName . "] - " . key . "`r`n"
        }
        
        statusMsg .= "`r`n=== PRIORITY ORDER ===`r`n"
        for index, priorityPattern in dpsPriorities {
            if (dpsPatterns.HasKey(priorityPattern))
                statusMsg .= index . ". " . GetDPSDisplayName(priorityPattern) . "`r`n"
        }
    }
    
    UpdateDPSStatus(statusMsg)
return

StartDPSScript:
    if (TargetGameWindow = "") {
        UpdateDPSStatus("Please select a target window first using the Healer tab.")
        return
    }
    
    if (dpsPatterns.Count() = 0) {
        UpdateDPSStatus("No DPS skills captured. Add some skills first.")
        return
    }
    
    isDpsRunning := true
    SetTimer, DPSLoop, 50  ; Check every 300ms for better weaving  
    UpdateDPSStatus("DPS script started. Will weave with healing and buffs using priority order.")
return

StopDPSScript:
    isDpsRunning := false
    SetTimer, DPSLoop, Off
    UpdateDPSStatus("DPS script stopped.")
return

DPSLoop:
    if (!isDpsRunning)
    {
        return
    }
    ; DPS has second priority - yield to healing
    if (isSystemBusy) {
        ;ActivateGameWindow()
        return  ; Skip this cycle if system is busy with healing
    }
    
    ; Set system busy for DPS actions
    ;isSystemBusy := true
      ; Activate the target window
    ; if (TargetGameWindow != "") {
    ;     WinActivate, ahk_id %TargetGameWindow%
    ;     Sleep, 30
    ; }
    TryCastDPSSkills()
    ; Add a check to ensure dpsandheal is properly updated when checkbox changes
    sleep, 75
    ; Release system busy flag
    isSystemBusy := false
return

TryCastDPSSkills() {
    global dpsPatterns, dpsPatternKeys, dpsPriorities
    global SkillBarX1, SkillBarY1, SkillBarX2, SkillBarY2, isDpsRunning
    
    for index, priorityPattern in dpsPriorities {
        if (!dpsPatterns.HasKey(priorityPattern))
            continue
            
        patternText := dpsPatterns[priorityPattern]
        ; Convert window-relative coordinates to screen coordinates
        WinGetPos, winX, winY,,, ahk_id %win1%
        screenX1 := winX + SkillBarX1
        screenY1 := winY + SkillBarY1
        screenX2 := winX + SkillBarX2
        screenY2 := winY + SkillBarY2
        dpsSkill := FindText(0, 0, screenX1, screenY1, screenX2, screenY2, 0, 0, patternText)
        
        if (dpsSkill) {
            displayName := GetDPSDisplayName(priorityPattern)
            hasKey := dpsPatternKeys.HasKey(priorityPattern) && dpsPatternKeys[priorityPattern] != ""
            
            ; Execute skill with spam protection
            spamCount := 0
            Loop 5 {  ; Max 5 attempts
                spamCount++
                
                if (hasKey) {
                    keyToPress := dpsPatternKeys[priorityPattern]
                    
                    ; Check for modifier keys and handle them separately
                    hasCtrl := InStr(keyToPress, "^")
                    hasAlt := InStr(keyToPress, "!")
                    hasShift := InStr(keyToPress, "+")
                    
                    ; Extract the base key (remove modifiers)
                    baseKey := keyToPress
                    if (hasCtrl)
                        baseKey := StrReplace(baseKey, "^", "")
                    if (hasAlt)
                        baseKey := StrReplace(baseKey, "!", "")
                    if (hasShift)
                        baseKey := StrReplace(baseKey, "+", "")
                    
                    ; Send modifier keys down
                    if (hasCtrl)
                        ControlSend, , {Ctrl down}, ahk_id %win1%
                    if (hasAlt)
                        ControlSend, , {Alt down}, ahk_id %win1%
                    if (hasShift)
                        ControlSend, , {Shift down}, ahk_id %win1%
                    
                    ; Send the base key
                    ControlSend, , {%baseKey% down}, ahk_id %win1%
                    Sleep, 50
                    ControlSend, , {%baseKey% up}, ahk_id %win1%
                    
                    ; Send modifier keys up (in reverse order)
                    if (hasShift)
                        ControlSend, , {Shift up}, ahk_id %win1%
                    if (hasAlt)
                        ControlSend, , {Alt up}, ahk_id %win1%
                    if (hasCtrl)
                        ControlSend, , {Ctrl up}, ahk_id %win1%
                } else {
                    X := dpsSkill.1.x
                    Y := dpsSkill.1.y
                    SendMessageClick(X, Y)             
                     }
                
                ; Recheck availability
                Sleep, 125
                if (!FindText(0, 0, screenX1, screenY1, screenX2, screenY2, 0, 0, patternText))
                    break
            }
            
            ; Check health after every skill cast
            if (healanddps) {
                gosub, DynamicHealthCheck
            } else if (dpstargetedhealing) {
                gosub, DPSTargetedHealthCheck
            }            
            ; Status message
            method := hasKey ? "key: " . dpsPatternKeys[priorityPattern] : "clicking"
            prefix := isDpsRunning ? "" : "TEST: "
            UpdateDPSStatus(prefix . "Used " . displayName . " with " . method . " (" . spamCount . "x)")
            return true

            
            sleep, 150
        }
    }
    
    if (!isDpsRunning)
        UpdateDPSStatus("No DPS skills found on screen.")
    return false
}


; DPS Priority Management
DPSPrioritySelect:
return

MoveDPSUp:
    ; Get the currently selected item index from the ListBox
    GuiControlGet, selectedText, , DPSPriorityList
    selectedIndex := 0
    
    ; Parse the index from the text (format: "1. SkillName")
    if (selectedText != "") {
        RegExMatch(selectedText, "^(\d+)\.", match)
        selectedIndex := match1
    }
    
    ; Debug info
    UpdateDPSStatus("Debug: Selected text = '" . selectedText . "', Parsed index = " . selectedIndex . ", Total items = " . dpsPriorities.Length())
    
    if (selectedIndex <= 1 || selectedIndex > dpsPriorities.Length()) {
        UpdateDPSStatus("Cannot move item up. Select an item first or item is already at top.")
        return
    }
    
    ; Swap with previous item
    temp := dpsPriorities[selectedIndex]
    dpsPriorities[selectedIndex] := dpsPriorities[selectedIndex - 1]
    dpsPriorities[selectedIndex - 1] := temp
    
    SaveDPSPriorities()
    RefreshDPSPriorityList()
    
    ; Reselect the moved item
    GuiControl, Choose, DPSPriorityList, % selectedIndex - 1
    
    UpdateDPSStatus("Moved DPS skill up in priority.")
return

MoveDPSDown:
    ; Get the currently selected item index from the ListBox
    GuiControlGet, selectedText, , DPSPriorityList
    selectedIndex := 0
    
    ; Parse the index from the text (format: "1. SkillName")
    if (selectedText != "") {
        RegExMatch(selectedText, "^(\d+)\.", match)
        selectedIndex := match1
    }
    
    ; Debug info
    UpdateDPSStatus("Debug: Selected text = '" . selectedText . "', Parsed index = " . selectedIndex . ", Total items = " . dpsPriorities.Length())
    
    if (selectedIndex <= 0 || selectedIndex >= dpsPriorities.Length()) {
        UpdateDPSStatus("Cannot move item down. Select an item first or item is already at bottom.")
        return
    }
    
    ; Swap with next item
    temp := dpsPriorities[selectedIndex]
    dpsPriorities[selectedIndex] := dpsPriorities[selectedIndex + 1]
    dpsPriorities[selectedIndex + 1] := temp
    
    SaveDPSPriorities()
    RefreshDPSPriorityList()
    
    ; Reselect the moved item
    GuiControl, Choose, DPSPriorityList, % selectedIndex + 1
    
    UpdateDPSStatus("Moved DPS skill down in priority.")
return

RefreshDPSList:
    RefreshDPSPriorityList()
    UpdateDPSStatus("DPS priority list refreshed.")
return

RemoveFromDPSPriority:
    ; Get the currently selected item index from the ListBox
    GuiControlGet, selectedText, , DPSPriorityList
    selectedIndex := 0
    
    ; Parse the index from the text (format: "1. SkillName")
    if (selectedText != "") {
        RegExMatch(selectedText, "^(\d+)\.", match)
        selectedIndex := match1
    }
    
    if (selectedIndex <= 0 || selectedIndex > dpsPriorities.Length()) {
        UpdateDPSStatus("Select a DPS skill to remove from priority.")
        return
    }
    
    removedSkill := dpsPriorities[selectedIndex]
    displayName := GetDPSDisplayName(removedSkill)
    dpsPriorities.RemoveAt(selectedIndex)
    
    SaveDPSPriorities()
    RefreshDPSPriorityList()
    UpdateDPSStatus("Removed '" . displayName . "' from DPS priority order (skill still saved).")
return

AddToDPSPriority:
    ; Show available DPS skills not in priority
    availableDPS := "=== ADD DPS SKILL TO PRIORITY ===`n`n"
    availableCount := 0
    availableSkills := []
    
    for patternName, patternText in dpsPatterns {
        ; Check if already in priority
        inPriority := false
        for index, priorityPattern in dpsPriorities {
            if (priorityPattern = patternName) {
                inPriority := true
                break
            }
        }
        
        if (!inPriority) {
            availableCount++
            availableSkills.Push(patternName)
            displayName := GetDPSDisplayName(patternName)
            availableDPS .= availableCount . ". " . displayName . " [" . patternName . "]`n"
        }
    }
    
    if (availableCount = 0) {
        UpdateDPSStatus("No DPS skills available to add (all are already in priority or none saved).")
        return
    }
    
    availableDPS .= "`nEnter the number of the DPS skill to add to priority:"
    
    InputBox, dpsNumber, Add DPS Skill to Priority, %availableDPS%, , 400, 300
    if (ErrorLevel)
        return
    
    if (dpsNumber < 1 || dpsNumber > availableCount) {
        UpdateDPSStatus("Invalid DPS skill number selected.")
        return
    }
    
    selectedSkill := availableSkills[dpsNumber]
    displayName := GetDPSDisplayName(selectedSkill)
    
    ; Add to end of priority list
    dpsPriorities.Push(selectedSkill)
    SaveDPSPriorities()
    RefreshDPSPriorityList()
    UpdateDPSStatus("Added '" . displayName . "' to DPS priority order.")
return

RefreshDPSPriorityList() {
    ; Clear the listbox completely
    GuiControl,, DPSPriorityList, |
    
    ; Force rebuild the list
    newList := ""
    itemCount := 0
    for index, priorityPattern in dpsPriorities {
        if (dpsPatterns.HasKey(priorityPattern)) {
            itemCount++
            ; Force get fresh display name
            displayName := dpsPatternNames.HasKey(priorityPattern) && dpsPatternNames[priorityPattern] != "" ? dpsPatternNames[priorityPattern] : priorityPattern
            keyInfo := dpsPatternKeys.HasKey(priorityPattern) && dpsPatternKeys[priorityPattern] != "" ? " (Key: " . dpsPatternKeys[priorityPattern] . ")" : " (Click)"
            listItem := index . ". " . displayName . keyInfo
            if (newList != "")
                newList .= "|"
            newList .= listItem
        }
    }
    
    ; Set the entire list at once
    GuiControl,, DPSPriorityList, %newList%
    
    ; Show count for debugging
    if (itemCount = 0 && dpsPriorities.Length() > 0) {
        UpdateDPSStatus("Warning: " . dpsPriorities.Length() . " priorities but 0 valid patterns found")
    }
}

; DPS Helper Functions
SaveDPSPattern(patternName, patternText, keyAssignment, customName) {
    global iniFile, dpsPatterns, dpsPatternKeys, dpsPatternNames
    
    FileEncoding, UTF-8
    IniWrite, %patternText%, %iniFile%, DPSPatterns, %patternName%
    IniWrite, %keyAssignment%, %iniFile%, DPSPatternKeys, %patternName%
    IniWrite, %customName%, %iniFile%, DPSPatternNames, %patternName%
    FileEncoding
    
    dpsPatterns[patternName] := patternText
    dpsPatternKeys[patternName] := keyAssignment
    dpsPatternNames[patternName] := customName
}

SaveDPSPatternKey(patternName, keyAssignment) {
    global iniFile, dpsPatternKeys
    
    FileEncoding, UTF-8
    IniWrite, %keyAssignment%, %iniFile%, DPSPatternKeys, %patternName%
    FileEncoding
    dpsPatternKeys[patternName] := keyAssignment
}

SaveDPSPatternName(patternName, customName) {
    global iniFile, dpsPatternNames
    
    FileEncoding, UTF-8
    IniWrite, %customName%, %iniFile%, DPSPatternNames, %patternName%
    FileEncoding
    dpsPatternNames[patternName] := customName
}

SaveDPSPriorities() {
    global iniFile, dpsPriorities
    
    ; Convert array to comma-separated string
    priorityString := ""
    for index, priorityPattern in dpsPriorities {
        if (index > 1)
            priorityString .= ","
        priorityString .= priorityPattern
    }
    
    FileEncoding, UTF-8
    IniWrite, %priorityString%, %iniFile%, DPSPriorities, Order
    FileEncoding
}

LoadDPSPriorities() {
    global iniFile, dpsPriorities
    
    IniRead, priorityString, %iniFile%, DPSPriorities, Order, %A_Space%
    if (priorityString != "" && priorityString != "ERROR") {
        dpsPriorities := StrSplit(priorityString, ",")
    }
}

GetDPSDisplayName(patternName) {
    global dpsPatternNames
    
    if (dpsPatternNames.HasKey(patternName) && dpsPatternNames[patternName] != "")
        return dpsPatternNames[patternName]
    return patternName
}

LoadAllDPSPatterns() {
    global iniFile, dpsPatterns, dpsPatternKeys, dpsPatternNames
    
    ; Load DPS patterns
    IniRead, dpsPatternsList, %iniFile%, DPSPatterns
    if (dpsPatternsList != "ERROR") {
        Loop, Parse, dpsPatternsList, `n
        {
            if (A_LoopField != "") {
                ; Find first equals sign position
                equalsPos := InStr(A_LoopField, "=")
                if (equalsPos > 0) {
                    patternName := SubStr(A_LoopField, 1, equalsPos - 1)
                    patternText := SubStr(A_LoopField, equalsPos + 1)
                    dpsPatterns[patternName] := patternText
                }
            }
        }
    }
    
    ; Load DPS pattern keys
    IniRead, dpsPatternKeysList, %iniFile%, DPSPatternKeys
    if (dpsPatternKeysList != "ERROR") {
        Loop, Parse, dpsPatternKeysList, `n
        {
            if (A_LoopField != "") {
                ; Find first equals sign position
                equalsPos := InStr(A_LoopField, "=")
                if (equalsPos > 0) {
                    patternName := SubStr(A_LoopField, 1, equalsPos - 1)
                    keyAssignment := SubStr(A_LoopField, equalsPos + 1)
                    dpsPatternKeys[patternName] := keyAssignment
                }
            }
        }
    }
    
    ; Load DPS pattern names
    IniRead, dpsPatternNamesList, %iniFile%, DPSPatternNames
    if (dpsPatternNamesList != "ERROR") {
        Loop, Parse, dpsPatternNamesList, `n
        {
            if (A_LoopField != "") {
                ; Find first equals sign position
                equalsPos := InStr(A_LoopField, "=")
                if (equalsPos > 0) {
                    patternName := SubStr(A_LoopField, 1, equalsPos - 1)
                    customName := SubStr(A_LoopField, equalsPos + 1)
                    dpsPatternNames[patternName] := customName
                }
            }
        }
    }
    
    ; Initialize DPS counter
    InitializeDPSCounter()
    
    dpsCount := dpsPatterns.Count()
    if (dpsCount > 0) {
        UpdateDPSStatus("Loaded " . dpsCount . " DPS pattern(s) successfully.")
    }
}

InitializeDPSCounter() {
    global dpsPatterns, dpsCounter
    
    highestNumber := 0
    for patternName, patternValue in dpsPatterns {
        if (SubStr(patternName, 1, 3) = "dps") {
            numberPart := SubStr(patternName, 4)
            if numberPart is integer
            {
                if (numberPart > highestNumber)
                    highestNumber := numberPart
            }
        }
    }
    
    dpsCounter := highestNumber + 1
}

ReloadDPSCustomNames() {
    global iniFile, dpsPatternNames
    
    ; Don't clear - just reload what's in the INI
    FileEncoding, UTF-8
    IniRead, dpsPatternNamesList, %iniFile%, DPSPatternNames
    FileEncoding
    if (dpsPatternNamesList != "ERROR") {
        Loop, Parse, dpsPatternNamesList, `n
        {
            if (A_LoopField != "") {
                ; Find first equals sign position
                equalsPos := InStr(A_LoopField, "=")
                if (equalsPos > 0) {
                    patternName := SubStr(A_LoopField, 1, equalsPos - 1)
                    customName := SubStr(A_LoopField, equalsPos + 1)
                    dpsPatternNames[patternName] := customName
                }
            }
        }
    }
}

UpdateDPSStatus(message) {
    global
    
    ; Get current time
    FormatTime, TimeString, , yyyy-MM-dd HH:mm:ss
    statusMessage := "[" . TimeString . "] " . message
    
    ; Get current content and add new message
    GuiControlGet, currentContent, , DPSStatusEdit
    if (currentContent != "") {
        newContent := currentContent . "`r`n" . statusMessage
    } else {
        newContent := statusMessage
    }
    
    ; Update the edit control
    GuiControl,, DPSStatusEdit, %newContent%
    
    ; Scroll to bottom
    SendMessage, 0x0115, 7, 0, , ahk_id %DPSStatusEdit%  ; WM_VSCROLL, SB_BOTTOM
}

; ========= SHARED FUNCTIONS =========
CloseApp:
    SetTimer, CheckExecutions, Off
    SetTimer, CheckHealth, Off
    SetTimer, DPSLoop, Off
    ClearBoundingBoxes()
    ExitApp
return

GuiClose:
    SetTimer, CheckExecutions, Off
    SetTimer, CheckHealth, Off
    SetTimer, DPSLoop, Off
    ClearBoundingBoxes()
    ExitApp
return
CheckWindowExists:
    ; Only check if at least one sequence is running
    if (!IsRunning1 && !IsRunning2 && !IsRunning3)
        return
    
    ; Check if the target window still exists
    IfWinNotExist, ahk_id %win1%
    {
        ; Window no longer exists, pause all running sequences
        windowWasClosed := true
        
        if (IsRunning1) {
            IsRunning1 := false
            GuiControl,, StartStop1, Start1
            GuiControl,, CountdownText1, Next: --
            UpdateStatus1("Window closed - paused")
        }
        if (IsRunning2) {
            IsRunning2 := false
            GuiControl,, StartStop2, Start2
            GuiControl,, CountdownText2, Next: --
            UpdateStatus2("Window closed - paused")
        }
        if (IsRunning3) {
            IsRunning3 := false
            GuiControl,, StartStop3, Start3
            GuiControl,, CountdownText3, Next: --
            UpdateStatus3("Window closed - paused")
        }
        
        ; Stop the main execution timer
        SetTimer, CheckExecutions, Off
        
        ; Show notification
        TrayTip, Window Monitor, Target window was closed. All sequences paused., 5, 2
    }
return

; Add this function to start the window monitoring timer
StartWindowMonitoring() {
    SetTimer, CheckWindowExists, 2000  ; Check every 2 seconds
}

; Add this function to stop the window monitoring timer
StopWindowMonitoring() {
    SetTimer, CheckWindowExists, Off
}
; Hotkeys for script control

f12::
    if (IsRunning1 || IsRunning2 || IsRunning3) {
        if (IsRunning1) {
            IsRunning1 := false
            GuiControl,, StartStop1, Start1
            GuiControl,, CountdownText1, Next: --
            UpdateStatus1("Stopped by hotkey")
        }
        if (IsRunning2) {
            IsRunning2 := false
            GuiControl,, StartStop2, Start2
            GuiControl,, CountdownText2, Next: --
            UpdateStatus2("Stopped by hotkey")
        }
        if (IsRunning3) {
            IsRunning3 := false
            GuiControl,, StartStop3, Start3
            GuiControl,, CountdownText3, Next: --
            UpdateStatus3("Stopped by hotkey")
        }
        SetTimer, CheckExecutions, Off
    } else {
        ClearBoundingBoxes()
        SetTimer, CheckHealth, Off
        Reload
    }
return

; ========= TEMPLAR FUNCTIONS =========
ValidateTemplarTargetCount:
    Gui, Submit, NoHide
    if (TemplarTargetCountEdit < 1)
    {
        TemplarTargetCountEdit := 1
        GuiControl,, TemplarTargetCountEdit, 1
    }
    else if (TemplarTargetCountEdit > 20)
    {
        TemplarTargetCountEdit := 20
        GuiControl,, TemplarTargetCountEdit, 20
    }
    TemplarTargetCount := TemplarTargetCountEdit
return

SetTemplarPoints:
    Gui, Submit, NoHide
    TemplarTargetCount := TemplarTargetCountEdit
    
    if (win2 = "") {
        UpdateTemplarStatus("Please select Templar window first.")
        return
    }
    
    ; Clear existing coordinates
    TemplarTargetCoords := []
    
    ; Hide GUI temporarily
    Gui, Hide
    
    MsgBox, 4, Set Templar Points, Click OK then Right-click on %TemplarTargetCount% target locations.`n`nPress ESC to cancel.
    IfMsgBox No
    {
        Gui, Show
        return
    }
    
    ; Capture coordinates for each target
    Loop, %TemplarTargetCount% {
        currentTarget := A_Index
        ToolTip, Left-click on Target %currentTarget% of %TemplarTargetCount%, 100, 100
        
        ; Wait for left click
        KeyWait, rButton, D
        MouseGetPos, TargetX, TargetY
        
        ; Store coordinates
        TemplarTargetCoords.Push({X: TargetX, Y: TargetY})
        
        KeyWait, rButton
        Sleep, 200
    }
    
    ToolTip
    
    ; Show summary
    summaryText := "Captured " . TemplarTargetCount . " target points:`n`n"
    For index, coords in TemplarTargetCoords {
        summaryText .= "Target " . index . ": (" . coords.X . ", " . coords.Y . ")`n"
    }
    
    MsgBox, 64, Points Captured, %summaryText%
    
    ; Show GUI again
    Gui, Show
    
    UpdateTemplarStatus("Captured " . TemplarTargetCount . " target coordinates successfully.")
return

SaveHolygroundHotkey:
    SaveTemplarSettings()
    UpdateTemplarStatus("Templar settings saved to INI")
return

StartTemplarScript:
    if (win2 = "") {
        UpdateTemplarStatus("Please select Templar window first.")
        return
    }
    
    if (TemplarTargetCoords.Length() = 0) {
        UpdateTemplarStatus("Please set target points first.")
        return
    }
    
    if (HolygroundHotkey = "") {
        UpdateTemplarStatus("Please set Holyground hotkey first.")
        return
    }
    
    ; Start the Templar script
    SetTimer, TemplarLoop, 100
    UpdateTemplarStatus("Templar script started - clicking targets and casting Holyground")
return

StopTemplarScript:
    SetTimer, TemplarLoop, Off
    UpdateTemplarStatus("Templar script stopped.")
return



SendHolygroundHotkey() {
    global HolygroundHotkey, win2
    
    if (HolygroundHotkey = "" || win2 = "")
        return
    
    ; Check for modifier keys and handle them separately
    hasCtrl := InStr(HolygroundHotkey, "^")
    hasAlt := InStr(HolygroundHotkey, "!")
    hasShift := InStr(HolygroundHotkey, "+")
    
    ; Extract the base key (remove modifiers)
    baseKey := HolygroundHotkey
    if (hasCtrl)
        baseKey := StrReplace(baseKey, "^", "")
    if (hasAlt)
        baseKey := StrReplace(baseKey, "!", "")
    if (hasShift)
        baseKey := StrReplace(baseKey, "+", "")
    
    ; Send modifier keys down
                    if (hasCtrl)
                        ControlSend, , {Ctrl down}, ahk_id %win1%
                    if (hasAlt)
                        ControlSend, , {Alt down}, ahk_id %win1%
                    if (hasShift)
                        ControlSend, , {Shift down}, ahk_id %win1%
                    
                    ; Send the base key
                    ControlSend, , {%baseKey% down}, ahk_id %win1%
                    Sleep, 50
                    ControlSend, , {%baseKey% up}, ahk_id %win1%
                    
                    ; Send modifier keys up (in reverse order)
                    if (hasShift)
                        ControlSend, , {Shift up}, ahk_id %win1%
                    if (hasAlt)
                        ControlSend, , {Alt up}, ahk_id %win1%
                    if (hasCtrl)
                        ControlSend, , {Ctrl up}, ahk_id %win1%
}

UpdateTemplarStatus(message) {
    global
    
    ; Get current time
    FormatTime, timeStamp,, HH:mm:ss
    
    ; Add timestamp to message
    newMessage := "[" . timeStamp . "] " . message . "`r`n"
    
    ; Get current content and add new message
    GuiControlGet, currentContent, , TemplarStatusEdit
    if (currentContent != "") {
        newContent := currentContent . newMessage
    } else {
        newContent := newMessage
    }
    
    ; Keep only the last 15 lines to prevent overflow
    lines := StrSplit(newContent, "`r`n")
    if (lines.Length() > 15) {
        newContent := ""
        Loop % Min(15, lines.Length()) {
            if (lines[lines.Length() - 15 + A_Index] != "") {
                newContent .= lines[lines.Length() - 15 + A_Index] . "`r`n"
            }
        }
    }
    
    ; Update the GUI control
    GuiControl,, TemplarStatusEdit, %newContent%
}

SaveTemplarSettings() {
    global iniFile, HolygroundHotkey, RandomXVariation, RandomYVariation, MinDelay, MaxDelay
    
    Gui, Submit, NoHide
    RandomXVariation := RandomXVariationEdit
    RandomYVariation := RandomYVariationEdit
    MinDelay := MinDelayEdit
    MaxDelay := MaxDelayEdit
    
    ; Validate that min is not greater than max
    if (MinDelay > MaxDelay) {
        temp := MinDelay
        MinDelay := MaxDelay
        MaxDelay := temp
        GuiControl,, MinDelayEdit, %MinDelay%
        GuiControl,, MaxDelayEdit, %MaxDelay%
        UpdateTemplarStatus("Swapped min/max delay values (min was greater than max)")
    }
    
    FileEncoding, UTF-8
    IniWrite, %HolygroundHotkey%, %iniFile%, TemplarSettings, HolygroundHotkey
    IniWrite, %RandomXVariation%, %iniFile%, TemplarSettings, RandomXVariation
    IniWrite, %RandomYVariation%, %iniFile%, TemplarSettings, RandomYVariation
    IniWrite, %MinDelay%, %iniFile%, TemplarSettings, MinDelay
    IniWrite, %MaxDelay%, %iniFile%, TemplarSettings, MaxDelay
    FileEncoding
}


LoadTemplarSettings() {
    global iniFile, HolygroundHotkey, RandomXVariation, RandomYVariation, MinDelay, MaxDelay
    
    IniRead, loadedHotkey, %iniFile%, TemplarSettings, HolygroundHotkey, %A_Space%
    if (loadedHotkey != "ERROR" && loadedHotkey != "") {
        HolygroundHotkey := loadedHotkey
        GuiControl,, HolygroundHotkeyEdit, %HolygroundHotkey%
    }
    
    IniRead, loadedXVar, %iniFile%, TemplarSettings, RandomXVariation, 5
    if (loadedXVar != "ERROR") {
        RandomXVariation := loadedXVar
        GuiControl,, RandomXVariationEdit, %RandomXVariation%
    }
    
    IniRead, loadedYVar, %iniFile%, TemplarSettings, RandomYVariation, 5
    if (loadedYVar != "ERROR") {
        RandomYVariation := loadedYVar
        GuiControl,, RandomYVariationEdit, %RandomYVariation%
    }
    
    IniRead, loadedMinDelay, %iniFile%, TemplarSettings, MinDelay, 80
    if (loadedMinDelay != "ERROR") {
        MinDelay := loadedMinDelay
        GuiControl,, MinDelayEdit, %MinDelay%
    }
    
    IniRead, loadedMaxDelay, %iniFile%, TemplarSettings, MaxDelay, 150
    if (loadedMaxDelay != "ERROR") {
        MaxDelay := loadedMaxDelay
        GuiControl,, MaxDelayEdit, %MaxDelay%
    }
}


TemplarLoop:
    ; Check if window still exists
    IfWinNotExist, ahk_id %win2%
    {
        UpdateTemplarStatus("Templar window closed - stopping script")
        SetTimer, TemplarLoop, Off
        return
    }
    
    ; Get current settings from GUI
    Gui, Submit, NoHide
    currentXVar := RandomXVariationEdit
    currentYVar := RandomYVariationEdit
    currentMinDelay := MinDelayEdit
    currentMaxDelay := MaxDelayEdit
    
    ; Validate delay values
    if (currentMinDelay > currentMaxDelay) {
        temp := currentMinDelay
        currentMinDelay := currentMaxDelay
        currentMaxDelay := temp
    }
    
    ; Activate the window first
    WinActivate, ahk_id %win2%
    Random, activateDelay, 20, 50
    Sleep, %activateDelay%
    
    ; Click on each target and cast Holyground
    For index, coords in TemplarTargetCoords {
        ; Extract base coordinates
        baseX := coords.X
        baseY := coords.Y
        
        ; Add random variation
        Random, xOffset, -%currentXVar%, %currentXVar%
        Random, yOffset, -%currentYVar%, %currentYVar%
        
        targetX := baseX + xOffset
        targetY := baseY + yOffset
        ; Random delay between click and spell cast
        Random, clickDelay, 30, 80
        ; Cast Holyground using the hotkey
        SendHolygroundHotkey()
        ; Move mouse to randomized target location and click
        MouseMove, %targetX%, %targetY%, 0
        Sleep, %clickDelay%
        Click
        
        
        
        
        
        ; Use the custom random delay range
        Random, targetDelay, %currentMinDelay%, %currentMaxDelay%
        Sleep, %targetDelay%
    }
return

capchacheck:
    {


        
        confirm:="|<highlighted>DCEAFC-323232$33.D00o0200400ESxpjw2IYd8UUUZ92444d8EGUZ91vo4d8U"
        confirm.="|<>DFE4E8-323232$32.S01c0800E023rihz0Z9+G0EEGYW444d8UZ1+G7jEGYW"
        confirm.="|<>D3D8DE-323232$41.DU01800k006001000A0020wyxRzs214Wm8k0294YEE04288UU084EF100E8UW1wwUF148"

        capchaguardactivatedmessage:="|<>FD4039-323232$97.000E000000000000020800Ak000U00E001040080000E00801Rtmts414wds7XbEKWF14220W1F40+2+9E80U100F0c204150cI0E8UUcYI10W0W4o2080EEIE+0U10F8+944284+954E8c8aBsNm1o1souVc7HXF4U000000000000000E000000000000000U"
        capchaguardactivatedmessage.="|<>E22E2F-323232$70.0001000000040104006M000E040E00U0001wywxww20WSIw+944E882854FcIEF1UXcUoFmVE14m22WNE6+544G88+954McYEF8UkcYIFuwAt4u0wSREw20000000000080000000000U"
        capchaguardactivatedmessage.="|<>E63C37-0.90$69.000000E0000200020200000U000E0E000001wTbXnwT0E100G4EUEU420802E20240U0100G2E0E0A20c0WEG020EUE5U0G0E0E0420g02EW4200U8504G000E2400000E0000000000200000000000E00000000U"

        capcha:="|<>*62$43.szzzzjzs7zxzrztzzyzvzxy224460zxQiyvwTsiKTQsDkL/DiELnfZbr3dtZqvvVa22365m3zzTzzzzzzjzzzzzzrzzzzk"
        capchaguardtargetted:="|<>FFFFFF-323232$71.C00002000w00W002040024022004080084040QKQQK70E14M14mF4mF0U29E094W14217YEU3m9428w218X18YG84G842F94HAYF8Yk48WFkOKAQF6U7UwE00U00000000001000000000002000000001"
        capchaconfirm:="|<>DFE3E9-323232$33.D00o0200400ESxpjw2IYd8UUUZ92444d8EGUZ91vo4d8U"
        capchaquestionwindowopen:="|<>FFFFFF-323232$37.C00000cU0000M8sgACA0WN98a018Y4H07YG3tUYG910cWN4YWHUoWACA"
        if (FindText(X, Y, 0, 0, 1919, 1030, 0, 0, capchaguardactivatedmessage, , 0))
        {
            sleep, 50
            ;MsgBox, found message
            Loop,
            {
                ;MsgBox, looping
                (FindText(AX, AY, 0, 0, 1919, 1030, 0, 0, confirm))
                {
                    ;WinActivate, ahk_id %win1%                   
                    settimer, DPSLoop, off
                    SetTimer, essences, off
                    SetTimer, buffdaddystone, off
                    SetTimer, buffpetscroll, off
                    settimer, checkweight, off
                    SetTimer, snapshot, off
                    sleep, 100
                    SendMessageClick(AX, AY)
                    
                    if (!ok:=FindText(X, Y, 0, 0, 1919, 1030, 0, 0, capchaguardactivatedmessage, , 0))
                    {
                        break
                    }
                }

            }
            
            Gosub, PylonClicker
            return
        }
        ;MsgBox, returned
        return
    }

PylonClicker:
    ; Click the pylon location once per second
    sleep, 750
    Loop, {
    
    
    ; Check for any question patterns
    ht:="|<>FBFF47-323232$20.TU0zw0Tb0T1k7lw1gT031k0kAwDXD3tk0zw0By03U"
    ht.="|<>FFFF00-323232$20.TU0zw0Tb0T1k7lw1gT031k0kAwDXD3tk0zw0By03U"
    ht.="|<>FFFF00-323232$25.600z700zzUMQzkAADM60CATs76DwD30kD1UMD0kA70M07yA03zU"
    ht.="|<>FFFF00-323232$20.TU0zw0Tb0Tkk7kQ1g7037U0nkwBsD3Q00zw0Dz03U"
    ht.="|<>FBFF47-0.90$26.TU03jw00vb30Skkk7UQA3s7Ttq7byNXkACNs33zQ0kzzw00Pz006U"
    ht.="|<>FFFF00-323232$26.TU03jw00vb30Skkk7UQA3s7Ttq7byNXkACNs33zQ0kzzw00Pz006U"
    ht.="|<>FFFF00-323232$26.TU0Tjw0Dzb33bkkkkkQA0Q7Ts77by7XkA3ls31sQ0kQDw0Dzz03zU"
    ht.="|<>FFFF00-323232$26.3U0TUs0DwS33b7Uk1nsA1xqTsTNby1yMA0Dz33XzkktkM0Dw601yU"
    ht.="|<>FBFF47-323232$26.3U0TUs0DwS33b7Uk1nsA1xqTsTNby1yMA0Dz33XzkktkM0Dw601yU"
    ht.="|<>FFFF00-323232$70.llk1U001zX03Db060007zA0AyQ0M000MQ00vvbvtwT1UnQTjizjjtw67AviqviMvbETwlwTTXtXyQ1zX7lxwzaDtU60AC7rnyMk60M0lwTTCtXiM1U37ksszrjtU60AvXXVzST60M0r7U"
    ht.="|<>FFFF00-323232$26.kC0My706BnU1UQtwynwzjgSCtX7XyMkkzaAAA1X33iMkkzbgA7lvU"
    ht.="|<>FFFF00-323232$25.Dk00Dw00DD0073bnzVnvzUNprkAskM6MMC7AA7ba7RzX3yTVUyU"
    ht.="|<>FFFF00-323232$65.TlU01U0k001zn00301U003ba0060300077AwyATDbszjUPnyNzTTtzjsz7QniMtnrDtwDtbwlnb63nwTnDtX3ADVbsk6M37CMTbAtrAvaCQkzyNnyNzDTtVjslnslwSTX3U"
    ht.="|<>FBFF47-323232$63.Dk060000003z00k000000ww0600000073Xxwz7wMMysQzjjwzn3Dy1bQlnbCMNrkAk6CQtn3Da1a0lVa6MNzsQk6CQtn73zbbQlnbCRtrTszbjwznzDty3swz7wDsy000000k00000000060000000000k0004"
    ht.="|<>FFFF00-323232$63.Dk060000003z00k000000ww0600000073Xxwz7wMMysQzjjwzn3Dy1bQlnbCMNrkAk6CQtn3Da1a0lVa6MNzsQk6CQtn73zbbQlnbCRtrTszbjwznzDty3swz7wDsy000000k00000000060000000000k0004"
    ht.="|<>FBFF47-323232$38.TlU000DyM0003bU0000stbnszjUNxzDxz6RRnrDtb7wskSNVzADVaMM33wta7QkzyNVzABz6MDX3U"
    ht.="|<>FFFF00-323232$38.TlU000DyM0003bU0000stbnszjUNxzDxz6RRnrDtb7wskSNVzADVaMM33wta7QkzyNVzABz6MDX3U"
    ht.="|<>FFFF00-323232$19.wC7yDXw7kS3MD3i7Vr3llVszswTwSQ7DC3bb1nk01y03z01w"
    ht.="|<>FFFF00-323232$20.xzXzTwz673lUkwMQD7z3lzswMSD61XlUswTyD7z3k00z00zk0DU"
    ht.="|<>FBFF47-323232$20.xzXzTwz67XlUswMCD61XlUMwMCD63XlVswTwD7y3k00z00zk0DU"
    ht.="|<>FFFF00-323232$21.xzXrjySlVsqA76lUsqA36lUMqA76lUsqAD6lzkqDw6k00rU0Sw03o"
    ht.="|<>FFFF00-323232$20.wTnzDyz7bXlkswQ0D603lU0wQ0D73XltswDyD1z3k00z00zk0DU"
    
    ; Check if any question pattern is found
    if (FindText(QX, QY, 0, 0, 1919, 1030, 0, 0, ht)) {
        
        ; Stop clicking and solve captcha
       
        SolveCaptcha()
        ; Restart clicking after solving
        return
    } else {
        ; Convert window-relative coordinates to screen coordinates
        WinGetPos, winX, winY,,, ahk_id %win1%
        screenPylonX := winX + pylonX
        screenPylonY := winY + pylonY
        SendMessageClick(screenPylonX, screenPylonY)
    }
    sleep, 1000
    }
Return


Return
    ;        Pylonsearch()
    ;     {
    ;         pylon:="|<B2>##0.86$0/0/E5886B,-1/1/E4755D,-2/2/E7A691,-2/4/EB9680,3/4/FC956F,3/2/FAB086,0/4/FD9971,1/7/F79368,2/4/FCA277,0/3/FF9D7D,1/5/FC926A,3/5/FC8E68"
    ; pylon.="|<B3>##0.90$0/0/E89B85,-1/1/E18069,0/3/FDC1AB,2/3/F99E76,2/2/F4AA8B,2/0/FADDCD"
    ; pylon.="|<B4>##0.90$0/0/D38A72,-2/0/A78B6E,-2/2/C39E82,4/2/FAB794,3/0/F3B095,-2/1/B07A63,1/4/FBAB89,2/5/FF9069"
    ; pylon.="|<B5>##0.90$0/0/CBA09C,-2/2/C38F77,-2/5/E4B5A1,5/4/FDB99B,4/2/FFDCD1,2/4/ED8A68,2/8/E57A5C,-1/7/FCC5AE,0/4/F4947A,1/2/FABFAF,-1/1/DDC0B1,-2/3/CE8877,3/3/F5C2B0"
    ; pylon.="|<B6>##0.90$0/0/DD8E7A,0/2/F7C3B9,5/1/FED9BD,4/4/FCA074,3/6/FC815D,0/6/F6E1D8,-1/3/DDB89E,3/1/EE8C69,4/2/F79772"
    ; pylon.="|<>##0.90$0/0/698460,-2/2/4F8669,-1/3/5F6445,0/5/70835E,1/5/869B76,4/4/9D7F48,4/3/9F7E4B,4/1/A2A774,0/2/6E6D49,1/4/7E794B,2/8/65A88C"
    ; pylon.="|<>##0.90$0/0/627F5E,2/0/95B082,4/0/919669,4/2/98824D,4/3/9B7C49,4/5/977141,4/6/8B7343,3/7/7C884E,3/6/877F48,3/5/8C7B47,2/5/838355,2/3/857649,0/3/675D3C,0/4/6A6F4E"
    ; pylon.="|<>##0.90$0/0/767C56,1/1/7F744C,3/2/A27E4A,3/4/97653A,1/5/7F8E59,0/4/7B805C,2/3/927F4A,0/2/7A7144,-2/2/566143,-2/4/4E805A,-1/5/596F4B,-4/3/1D5E48,-3/1/3C7354,0/3/7E794F,-1/2/6A603F"
    ;         Loop,
    ;         {
    ;             if (FindText(X, Y, 0, 0, 1919, 1030, 0, 0, pylon))
    ;             {
    ;                 MouseMove, %X%, %Y%
    ;                 Send {Alt down}
    ;                 sleep, 50
    ;                 FindText().Click(X, Y, "L")
    ;                 sleep, 50
    ;                 Send {Alt up}
    ;                 sleep 800
    ;                 FindText().Click(X, Y, "L")
    ;                 sleep 2000                SolveCaptcha()
    ;                 return
    ;             }
    ;         }
    ;         return
    ;     }
    ; Add this function to your script
SolveCaptcha() {
        ;sgBox, solve

        capchaguardtargetted:="|<>FFFFFF-323232$71.C00002000w00W002040024022004080084040QKQQK70E14M14mF4mF0U29E094W14217YEU3m9428w218X18YG84G842F94HAYF8Yk48WFkOKAQF6U7UwE00U00000000001000000000002000000001"
        capchaconfirm:="|<>DFE3E9-323232$33.D00o0200400ESxpjw2IYd8UUUZ92444d8EGUZ91vo4d8U"
        capchaquestionwindowopen:="|<>FFFFFF-323232$37.C00000cU0000M8sgACA0WN98a018Y4H07YG3tUYG910cWN4YWHUoWACA"
        ;questions
        threeminusone:="|<>FBFF47-323232$20.TU0zw0Tb0T1k7lw1gT031k0kAwDXD3tk0zw0By03U"
        threeminusone.="|<>FFFF00-323232$20.TU0zw0Tb0T1k7lw1gT031k0kAwDXD3tk0zw0By03U"

        oneplustwo:="|<>FFFF00-323232$25.600z700zzUMQzkAADM60CATs76DwD30kD1UMD0kA70M07yA03zU"
        twominusone:="|<>FFFF00-323232$20.TU0zw0Tb0Tkk7kQ1g7037U0nkwBsD3Q00zw0Dz03U"
        fourplustwo:="|<>FBFF47-0.90$26.TU03jw00vb30Skkk7UQA3s7Ttq7byNXkACNs33zQ0kzzw00Pz006U"
        fourplustwo.="|<>FFFF00-323232$26.TU03jw00vb30Skkk7UQA3s7Ttq7byNXkACNs33zQ0kzzw00Pz006U"

        twoplustwo:="|<>FFFF00-323232$26.TU0Tjw0Dzb33bkkkkkQA0Q7Ts77by7XkA3ls31sQ0kQDw0Dzz03zU"
        fourplusthree:="|<>FFFF00-323232$26.3U0TUs0DwS33b7Uk1nsA1xqTsTNby1yMA0Dz33XzkktkM0Dw601yU"
        fourplusthree.="|<>FBFF47-323232$26.3U0TUs0DwS33b7Uk1nsA1xqTsTNby1yMA0Dz33XzkktkM0Dw601yU"
        presswaterpixie:="|<>FFFF00-323232$70.llk1U001zX03Db060007zA0AyQ0M000MQ00vvbvtwT1UnQTjizjjtw67AviqviMvbETwlwTTXtXyQ1zX7lxwzaDtU60AC7rnyMk60M0lwTTCtXiM1U37ksszrjtU60AvXXVzST60M0r7U"
        pressyeti:="|<>FFFF00-323232$26.kC0My706BnU1UQtwynwzjgSCtX7XyMkkzaAAA1X33iMkkzbgA7lvU"
        pressorc:="|<>FFFF00-323232$25.Dk00Dw00DD0073bnzVnvzUNprkAskM6MMC7AA7ba7RzX3yTVUyU"
        pressskeleton:="|<>FFFF00-323232$65.TlU01U0k001zn00301U003ba0060300077AwyATDbszjUPnyNzTTtzjsz7QniMtnrDtwDtbwlnb63nwTnDtX3ADVbsk6M37CMTbAtrAvaCQkzyNnyNzDTtVjslnslwSTX3U"
        pressoctopus:="|<>FBFF47-323232$63.Dk060000003z00k000000ww0600000073Xxwz7wMMysQzjjwzn3Dy1bQlnbCMNrkAk6CQtn3Da1a0lVa6MNzsQk6CQtn73zbbQlnbCRtrTszbjwznzDty3swz7wDsy000000k00000000060000000000k0004"
        pressoctopus.="|<>FFFF00-323232$63.Dk060000003z00k000000ww0600000073Xxwz7wMMysQzjjwzn3Dy1bQlnbCMNrkAk6CQtn3Da1a0lVa6MNzsQk6CQtn73zbbQlnbCRtrTszbjwznzDty3swz7wDsy000000k00000000060000000000k0004"

        presssiren:="|<>FBFF47-323232$38.TlU000DyM0003bU0000stbnszjUNxzDxz6RRnrDtb7wskSNVzADVaMM33wta7QkzyNVzABz6MDX3U"
        presssiren.="|<>FFFF00-323232$38.TlU000DyM0003bU0000stbnszjUNxzDxz6RRnrDtb7wskSNVzADVaMM33wta7QkzyNVzABz6MDX3U"

        pressA:="|<>FFFF00-323232$19.wC7yDXw7kS3MD3i7Vr3llVszswTwSQ7DC3bb1nk01y03z01w"
        pressB:="|<>FFFF00-323232$20.xzXzTwz673lUkwMQD7z3lzswMSD61XlUswTyD7z3k00z00zk0DU"
        pressD:="|<>FBFF47-323232$20.xzXzTwz67XlUswMCD61XlUMwMCD63XlVswTwD7y3k00z00zk0DU"
        pressD.="|<>FFFF00-323232$21.xzXrjySlVsqA76lUsqA36lUMqA76lUsqAD6lzkqDw6k00rU0Sw03o"
        pressC:="|<>FFFF00-323232$20.wTnzDyz7bXlkswQ0D603lU0wQ0D73XltswDyD1z3k00z00zk0DU"
        ;answers
        A:="|<>FFFFFF-323232$11.3UDUT0q3i7QQMztzr1y3w7U"
        A.="|<>FFFFFF-323232$11.3UDUT0q3i7QQMztzr1y3w7U"
        B:="|<>FFFFFF-323232$10.znzgCkP3jyzz1w3kTzzyU"
        B.="|<>FFFFFF-323232$10.znzgCkP3jyzz1w3kTzzyU"
        C:="|<>FFFFFF-323232$10.DtzzDsTUA0k3UC7wxznyU"
        C.="|<>FFFFFF-323232$10.DtzzDsTUA0k3UC7wxznyU"
        Dee:="|<>FFFFFF-323232$10.znzgDkT1w3kD1w7kzzjwU"
        Dee.="|<>FFFFFF-323232$10.znzgDkT1w3kD1w7kzzjwU"
        Dee.="|<>FFFFFF-0.90$10.znzgDkT1w3kD1w7kzzjwU"
        one:="|<>FFFFFF-323232$5.6TzxX6AMlXU"
        one.="|<>FFFFFF-323232$4.4zwF4F6"
        two:="|<>FFFFFF-323232$8.TjzbkkQ77XlsQDzzU"
        two.="|<>FFFFFF-323232$8.TjzbkkQ77XlsQDzzU"
        three:="|<>FFFFFF-323232$8.TjzbFlwT1kDXtzxyU"
        three.="|<>FFFFFF-323232$8.TjzbFlwT1kDXtzxyU"
        four:="|<>FFFFFF-323232$8.3UsS7XtqNiPzzkM6U"
        four.="|<>FFFFFF-323232$8.3UsS7XtqNiPzzkM6U"
        six:="|<>FFFFFF-323232$8.DbzrsDvztwD3xrwyU"
        seven:="|<>FFFFFF-323232$8.zzw73VkQ73UsC30kU"
        seven.="|<>FFFFFF-323232$8.zzw73VkQ73UsC30kU"
        waterpixie:="|<>FFFFFF-323232$88.sQC0A0001zX01U3Xss0k0007zA060CDXU30000MQ0000QyQzT7ly1UnQRXtrxrxwzbs67AvaTrRrRn3iQUTwlwNrBrQTADtk1zX7lbwyDbwkza060AC6TnsyTn30M0M0lwNUDXtrACtU1U37lbQQ77ywza060AvaTlkQDvlwM0M0r7MyU"
        waterpixie.="|<>FFFFFF-323232$88.sQC0A0001zX01U3Xss0k0007zA060CDXU30000MQ0000QyQzT7ly1UnQRXtrxrxwzbs67AvaTrRrRn3iQUTwlwNrBrQTADtk1zX7lbwyDbwkza060AC6TnsyTn30M0M0lwNUDXtrACtU1U37lbQQ77ywza060AvaTlkQDvlwM0M0r7MyU"
        octopus:="|<>FFFFFF-323232$65.Ds030000000zs060000003ls0A00000071lwyDlz66Di1bxwznzAAzs3CtVnbCMNrk6M33bCQkntkAk666MNVbzUtUACQtn73zXniMQtnbSRrz7wwznzDwzbw7lsz7wDsy000000A0000000000M0000000000k0004"
        octopus.="|<>FFFFFF-323232$65.Ds030000000zs060000003ls0A00000071lwyDlz66Di1bxwznzAAzs3CtVnbCMNrk6M33bCQkntkAk666MNVbzUtUACQtn73zXniMQtnbSRrz7wwznzDwzbw7lsz7wDsy000000A0000000000M0000000000k0004"
        orc:="|<>FFFFFF-323232$27.Ds003zU00wS0071nwys6Tjy0nZrk6QA70n1UsCMA7Xn1rTwMDtz30yU"
        orc.="|<>FFFFFF-323232$27.Ds003zU00wS0071nwys6Tjy0nZrk6QA70n1UsCMA7Xn1rTwMDtz30yU"
        siren:="|<>FFFFFF-323232$39.TlU0007zA0000xs000077AzDXyy1bvyTvyAtRnrDtb3yQMDAkTn3sNa30MTbAkRn3zta3yMPyAkDX3U"
        siren.="|<>FFFFFF-323232$39.TlU0007zA0000xs000077AzDXyy1bvyTvyAtRnrDtb3yQMDAkTn3sNa30MTbAkRn3zta3yMPyAkDX3U"
        siren.="|<>FBFF47-323232$38.TlU000DyM0003bU0000stbnszjUNxzDxz6RRnrDtb7wskSNVzADVaMM33wta7QkzyNVzABz6MDX3U"
        skeleton:="|<>FFFFFF-323232$66.TlU01U0k000ztU01U0k000xtU01U0k000stbblXtwTXyy1jDtbxwznzTlyCtbQktnrDtyDtbwktnX1tyDtbwkkn3sNyA1a0ktn3wtbCtbQktn3ztbDtbwwzn3TlXblXswTX3U"
        skeleton.="|<>FFFFFF-323232$66.TlU01U0k000ztU01U0k000xtU01U0k000stbblXtwTXyy1jDtbxwznzTlyCtbQktnrDtyDtbwktnX1tyDtbwkkn3sNyA1a0ktn3wtbCtbQktn3ztbDtbwwzn3TlXblXswTX3U"
        yeti:="|<>FFFFFF-323232$27.kC0MT3U33Qs0M3bDbnDnyyMwRn37XyMMMTn3330MMMRn333ySMMDXnU"
        yeti.="|<>FFFFFF-323232$27.kC0MT3U33Qs0M3bDbnDnyyMwRn37XyMMMTn3330MMMRn333ySMMDXnU"
        ;MsgBox, solve
        ; First check if a CAPTCHA is present
        loop, 2
        {
            ;MsgBox, in loop
            ; Now check which question is displayed
            if (FindText(QX, QY, 0, 0, 1919, 1030, 0, 0, threeminusone)) {
                ; Answer is 2
                if (FindText(AX, AY, 0, 0, 1919, 1030, 0, 0, two)) {
                    sleep 100
                    SendMessageClick(AX, AY)
                    SetTimer, essences, on
                    SetTimer, buffdaddystone, on
                    SetTimer, buffpetscroll, on
                    settimer, checkweight, on
                    SetTimer, snapshot, on
                    settimer, DPSLoop, on
                    return
                }
            }
            if (FindText(QX, QY, 0, 0, 1919, 1030, 0, 0, oneplustwo)) {
                ; Answer is 3
                if (FindText(AX, AY, 0, 0, 1919, 1030, 0, 0, three)) {
                    sleep 100
                    SendMessageClick(AX, AY)
                    SetTimer, essences, on
                    SetTimer, buffdaddystone, on
                    SetTimer, buffpetscroll, on
                    settimer, checkweight, on
                    SetTimer, snapshot, on
                    settimer, DPSLoop, on
                    return
                }
            }
            if (FindText(QX, QY, 0, 0, 1919, 1030, 0, 0, twominusone)) {
                ; Answer is 1
                if (FindText(AX, AY, 0, 0, 1919, 1030, 0, 0, one)) {
                    sleep 100
                    SendMessageClick(AX, AY)
                    SetTimer, essences, on
                    SetTimer, buffdaddystone, on
                    SetTimer, buffpetscroll, on
                    settimer, checkweight, on
                    SetTimer, snapshot, on
                    settimer, DPSLoop, on
                    return
                }
            }
            if (FindText(QX, QY, 0, 0, 1919, 1030, 0, 0, twoplustwo)) {
                ; Answer is 4
                if (FindText(AX, AY, 0, 0, 1919, 1030, 0, 0, four)) {
                    sleep 100
                    SendMessageClick(AX, AY)
                    SetTimer, essences, on
                    SetTimer, buffdaddystone, on
                    SetTimer, buffpetscroll, on
                    settimer, checkweight, on
                    SetTimer, snapshot, on
                    settimer, DPSLoop, on
                    return
                }
            }
            if (FindText(QX, QY, 0, 0, 1919, 1030, 0, 0, fourplustwo)) {
                ; Answer is 4
                if (FindText(AX, AY, 0, 0, 1919, 1030, 0, 0, six)) {
                    sleep 100
                    SendMessageClick(AX, AY)
                    SetTimer, essences, on
                    SetTimer, buffdaddystone, on
                    SetTimer, buffpetscroll, on
                    settimer, checkweight, on
                    SetTimer, snapshot, on
                    settimer, DPSLoop, on
                    return
                }
            }
            if (FindText(QX, QY, 0, 0, 1919, 1030, 0, 0, fourplusthree)) {
                ; Answer is 4
                if (FindText(AX, AY, 0, 0, 1919, 1030, 0, 0, seven)) {
                    sleep 100
                    SendMessageClick(AX, AY)
                    SetTimer, essences, on
                    SetTimer, buffdaddystone, on
                    SetTimer, buffpetscroll, on
                    settimer, checkweight, on
                    SetTimer, snapshot, on
                    settimer, DPSLoop, on
                    return
                }
            }
            if (FindText(QX, QY, 0, 0, 1919, 1030, 0, 0, presswaterpixie)) {
                ; Find and click waterpixie
                if (FindText(AX, AY, 0, 0, 1919, 1030, 0, 0, waterpixie)) {
                    sleep 100
                    SendMessageClick(AX, AY)
                    SetTimer, essences, on
                    SetTimer, buffdaddystone, on
                    SetTimer, buffpetscroll, on
                    settimer, checkweight, on
                    SetTimer, snapshot, on
                    settimer, DPSLoop, on
                    return
                }
            }
            if (FindText(QX, QY, 0, 0, 1919, 1030, 0, 0, presssiren)) {
                ; Find and click waterpixie
                if (FindText(AX, AY, 0, 0, 1919, 1030, 0, 0, siren)) {
                    sleep 100
                    SendMessageClick(AX, AY)
                    SetTimer, essences, on
                    SetTimer, buffdaddystone, on
                    SetTimer, buffpetscroll, on
                    settimer, checkweight, on
                    SetTimer, snapshot, on
                    settimer, DPSLoop, on
                    return
                }
            }
            if (FindText(QX, QY, 0, 0, 1919, 1030, 0, 0, pressyeti)) {
                ; Find and click yeti
                if (FindText(AX, AY, 0, 0, 1919, 1030, 0, 0, yeti)) {
                    sleep 100
                    SendMessageClick(AX, AY)
                    SetTimer, essences, on
                    SetTimer, buffdaddystone, on
                    SetTimer, buffpetscroll, on
                    settimer, checkweight, on
                    SetTimer, snapshot, on
                    settimer, DPSLoop, on
                    return
                }
            }
            if (FindText(QX, QY, 0, 0, 1919, 1030, 0, 0, pressorc)) {
                ; Find and click orc
                if (FindText(AX, AY, 0, 0, 1919, 1030, 0, 0, orc)) {
                    sleep 100
                    SendMessageClick(AX, AY)
                    SetTimer, essences, on
                    SetTimer, buffdaddystone, on
                    SetTimer, buffpetscroll, on
                    settimer, checkweight, on
                    SetTimer, snapshot, on
                    settimer, DPSLoop, on
                    return
                }
            }
            if (FindText(QX, QY, 0, 0, 1919, 1030, 0, 0, pressskeleton)) {
                ; Find and click skeleton
                if (FindText(AX, AY, 0, 0, 1919, 1030, 0, 0, skeleton)) {
                    sleep 100
                    SendMessageClick(AX, AY)
                    SetTimer, essences, on
                    SetTimer, buffdaddystone, on
                    SetTimer, buffpetscroll, on
                    settimer, checkweight, on
                    SetTimer, snapshot, on
                    settimer, DPSLoop, on
                    return
                }
            }
            if (FindText(QX, QY, 0, 0, 1919, 1030, 0, 0, pressoctopus)) {
                ; Find and click skeleton
                if (FindText(AX, AY, 0, 0, 1919, 1030, 0, 0, octopus)) {
                    sleep 100
                    SendMessageClick(AX, AY)
                    SetTimer, essences, on
                    SetTimer, buffdaddystone, on
                    SetTimer, buffpetscroll, on
                    settimer, checkweight, on
                    SetTimer, snapshot, on
                    settimer, DPSLoop, on
                    return
                }
            }
            if (FindText(QX, QY, 0, 0, 1919, 1030, 0, 0, pressA)) {
                ; Find and click A
                if (FindText(AX, AY, 0, 0, 1919, 1030, 0, 0, A)) {
                    sleep 100
                    SendMessageClick(AX, AY)
                    SetTimer, essences, on
                    SetTimer, buffdaddystone, on
                    SetTimer, buffpetscroll, on
                    settimer, checkweight, on
                    SetTimer, snapshot, on
                    settimer, DPSLoop, on
                    return
                }
            }
            if (FindText(QX, QY, 0, 0, 1919, 1030, 0, 0, pressB)) {
                ; Find and click B
                if (FindText(AX, AY, 0, 0, 1919, 1030, 0, 0, B)) {
                    sleep 100
                    SendMessageClick(AX, AY)
                    SetTimer, essences, on
                    SetTimer, buffdaddystone, on
                    SetTimer, buffpetscroll, on
                    settimer, checkweight, on
                    SetTimer, snapshot, on
                    settimer, DPSLoop, on
                    return
                }
            }
            if (FindText(QX, QY, 0, 0, 1919, 1030, 0, 0, pressC)) {
                ; Find and click C
                if (FindText(AX, AY, 0, 0, 1919, 1030, 0, 0, C)) {
                    sleep 100
                    SendMessageClick(AX, AY)
                    SetTimer, essences, on
                    SetTimer, buffdaddystone, on
                    SetTimer, buffpetscroll, on
                    settimer, checkweight, on
                    SetTimer, snapshot, on
                    settimer, DPSLoop, on
                    return
                }
            }
            if (FindText(QX, QY, 0, 0, 1919, 1030, 0, 0, pressD)) {
                ; Find and click D

                if (FindText(AX, AY, 0, 0, 1919, 1030, 0, 0, Dee)) {
                    sleep 100
                    SendMessageClick(AX, AY)
                    SetTimer, essences, on
                    SetTimer, buffdaddystone, on
                    SetTimer, buffpetscroll, on
                    settimer, checkweight, on
                    SetTimer, snapshot, on
                    settimer, DPSLoop, on
                    return
                }
            }
            ;msgbox, searching for tower
            Gosub, PylonClicker
        }

        ;msgbox, escaped
        return
    }
return
essences:
    sleep 250
    ControlSend ,, {6}, ahk_id %win1%
    sleep 250
    ControlSend ,, {6}, ahk_id %win1%
    sleep, 250 sleep, 250

    ControlSend ,, {7}, ahk_id %win1%
    sleep, 250
    ControlSend ,, {6}, ahk_id %win2%
    sleep, 250
    ControlSend ,, {7}, ahk_id %win2%
    sleep, 250
    ControlSend ,, {8}, ahk_id %win2%
Return
buffdaddystone:
;WinActivate, ahk_id %win1%  
    buffdaddy:="|<>#273@0.83$26.080008000A00400PU000C0U3zkh7zy/VyTX0Tzs07zy03No00Kx007zkA3zs10Tq037u00Fi40UC0084S441GE2"
    buffdaddy.="|<>*126$29.zy07zzUQ3zyAtkzl0Vtz07sNw0zykt7zzJaTzzy/zUyQ3w00k7k00U70000S0000y0005s003rk00bjU007zU023z0047Q008ww00tVs01s"

    if (buffdaddyok:=FindText(buffdaddyX, buffdaddyY, 0, 0, 1919, 1030, 0, 0, buffdaddy))
    {
        SendMessageClick(buffdaddyX, buffdaddyY)
    }
    sleep, 150
    refreshscroll:="|<>*140$23.zzVhzsM3z707s00CA00U001M0S51so8ATt8kDVns806DM0A0k0M3U2"

    if (brefreshscrollok:=FindText(refreshscrollX, refreshscrollY, 0, 0, 1919, 1030, 0, 0, refreshscroll))
    {
        SendMessageClick(refreshscrollX, refreshscrollY)
    }
    sleep, 150
    windpotionlvl5:="|<>*149$20.yzvpk3zvzzzTzyU1zw0Ty03z00zk07w00s"
    if (windpotionlvl5ok:=FindText(windpotionlvl5X, windpotionlvl5Y, 0, 0, 1919, 1030, 0, 0, windpotionlvl5))
    {
        SendMessageClick(windpotionlvl5X, windpotionlvl5Y)
    }
return
buffpetscroll:
;WinActivate, ahk_id %win1%  
    refreshscroll:="|<>*140$23.zzVhzsM3z707s00CA00U001M0S51so8ATt8kDVns806DM0A0k0M3U2"
    if (brefreshscroll2ok:=FindText(refreshscroll2X, refreshscroll2Y, 0, 0, 1919, 1030, 0, 0, refreshscroll))
    {
        SendMessageClick(refreshscroll2X, refreshscroll2Y)
    }
    sleep, 150
return
sellitems:

    sellscroll:="|<>#47@0.83$7.2DcYG8YD1FUE8h7E"
    sellscroll.="|<>*133$27.zzzzzzzzzzzzs7zzsDzzkzzzkq0zkE07ss01w800oM01z0M0AQDk00290I0F018280E0D0010w0003M000N00M34062N008/M070Q070107L007uw"

    if (sellscrollok:=FindText(sellscrollX, sellscrollY, 0, 0, 1919, 1030, 0, 0, sellscroll))
    {
        ;WinActivate, ahk_id %win1%  
        SendMessageClick(sellscrollX, sellscrollY)
        sleep, 1000
        Loop,
        {
            sellbutton:="|<>#75@0.83$16.V01800biAG0Hu1824E4Fvc"
            sellbutton.="|<>#74@0.83$16.l01A06bjAnUnv1A74k4Fzc"
            if (sellbuttonok:=FindText(sellbuttonX, sellbuttonY, 0, 0, 1919, 1030, 0, 0, sellbutton))
            {
                SendMessageClick(sellbuttonX, sellbuttonY)
                Sleep, 1000
                break
            }
        } until sellbuttonok!
    }
    Else
    {
        Goto, sellitems
    }
Return
snapshot:
    imgFile := A_ScriptDir "\weightcheck.bmp"  
    WinGetPos, winX, winY,,, ahk_id %win1%
    x1 := winX + checkweightX1
    y1 := winY + checkweightY1
    x2 := winX + checkweightX2
    y2 := winY + checkweightY2
    FindText().Screenshot(x1, y1, x2, y2, 0)
    Sleep, 500
    FindText().SavePic(imgFile, x1, y1, x2, y2, 1)  
    SetTimer, CheckRegionSnapshot, 3000
Return  
;==============================================================================
CheckRegionSnapshot:  
    ;  Search entire screen  
    ImageSearch, sx, sy, 0, 0, A_ScreenWidth, A_ScreenHeight, *50 %A_ScriptDir%\weightcheck.bmp    
    if (ErrorLevel= 0) {  
        ToolTip, looter inactive, 1480, 488
        sleep 1000
        ControlSend,, +7, ahk_id %win1%        
        sleep 1000
    }
    Else{
        ToolTip, looter active, 1480, 500
        SetTimer, CheckRegionSnapshot, Off

    }
Return  
checkweight:
        74weight:="|<>BDBDBD@0.83$23.y2688AGUEMZ11FA22Vf490NET1GU42Z088o"
        74weight.="|<>BDBDBD@0.83$23.yC688WGUF0Z12lA26Ff48UNEF1GUW2Z0s8o"

        WinGetPos, winX, winY,,, ahk_id %win1%
        screenX1 := winX + checkweightX1
        screenY1 := winY + checkweightY1
        screenX2 := winX + checkweightX2
        screenY2 := winY + checkweightY2
        
        if (74weightok:=FindText(74weightX, 74weightY, screenX1, screenY1, screenX2, screenY2, 0, 0, 74weight))
        {
            Gosub, sellitems
        }
    Return
f3:: reload


SendMessageClick(x, y, winId := "") {
    if (winId = "")
        winId := win1
    
    ; Get window position and client area
    WinGetPos, winX, winY,,, ahk_id %winId%
    
    ; Calculate relative coordinates (simple screen to window conversion)
    relativeX := x - winX
    relativeY := y - winY
    
    ; Adjust for title bar and borders (typical Windows offset)
    relativeX := relativeX - 8
    relativeY := relativeY - 31
    
    ; Create lParam for coordinates
    lParam := (relativeY << 16) | (relativeX & 0xFFFF)
    
    ; Send mouse down and up messages
    SendMessage, 0x201, 1, %lParam%,, ahk_id %winId%  ; WM_LBUTTONDOWN
    Sleep, 50
    SendMessage, 0x202, 0, %lParam%,, ahk_id %winId%  ; WM_LBUTTONUP
    Sleep, 50
    SendMessage, 0x201, 1, %lParam%,, ahk_id %winId%  ; WM_LBUTTONDOWN
    Sleep, 50
    SendMessage, 0x202, 0, %lParam%,, ahk_id %winId%  ; WM_LBUTTONUP
}

normcontrolclick(x, y, sleepTime := 100) {
    ControlClick, x%x% y%y%, ahk_id %win1%,, Left, 1, D
    sleep %sleepTime%
    ControlClick, x%x% y%y%, ahk_id %win1%,, Left, 1, U
}

; ========= COORDINATE SETTINGS FUNCTIONS =========
SetCheckSnapshotCoords:
    Gui, Hide
    
    MsgBox, 4, Set Area, Click OK then drag to select the area for both checkweight and snapshot.`n`nClick top-left corner, then drag to bottom-right corner.
    IfMsgBox No
    {
        Gui, Show
        return
    }
    
    ToolTip, Click and drag to select area, 100, 100
    
    KeyWait, LButton, D
    MouseGetPos, startX, startY
    KeyWait, LButton
    MouseGetPos, endX, endY
    
    ToolTip
    
    WinGetPos, winX, winY,,, ahk_id %win1%
    checkweightX1 := startX - winX
    checkweightY1 := startY - winY
    checkweightX2 := endX - winX
    checkweightY2 := endY - winY
    
    if (checkweightX1 > checkweightX2) {
        temp := checkweightX1
        checkweightX1 := checkweightX2
        checkweightX2 := temp
    }
    if (checkweightY1 > checkweightY2) {
        temp := checkweightY1
        checkweightY1 := checkweightY2
        checkweightY2 := temp
    }
    
    SaveCoordinateSettings()
    UpdateCoordinateDisplay()
    
    MsgBox, 64, Success, Area set to:`n%checkweightX1%,%checkweightY1% to %checkweightX2%,%checkweightY2%
    
    Gui, Show
return

SaveCoordinateSettings() {
    global iniFile, checkweightX1, checkweightY1, checkweightX2, checkweightY2
    
    FileEncoding, UTF-8
    IniWrite, %checkweightX1%, %iniFile%, CoordinateSettings, CheckweightX1
    IniWrite, %checkweightY1%, %iniFile%, CoordinateSettings, CheckweightY1
    IniWrite, %checkweightX2%, %iniFile%, CoordinateSettings, CheckweightX2
    IniWrite, %checkweightY2%, %iniFile%, CoordinateSettings, CheckweightY2
    FileEncoding
}

LoadCoordinateSettings() {
    global iniFile, checkweightX1, checkweightY1, checkweightX2, checkweightY2
    
    IniRead, loadedCWX1, %iniFile%, CoordinateSettings, CheckweightX1, %checkweightX1%
    IniRead, loadedCWY1, %iniFile%, CoordinateSettings, CheckweightY1, %checkweightY1%
    IniRead, loadedCWX2, %iniFile%, CoordinateSettings, CheckweightX2, %checkweightX2%
    IniRead, loadedCWY2, %iniFile%, CoordinateSettings, CheckweightY2, %checkweightY2%
    
    if (loadedCWX1 != "ERROR") checkweightX1 := loadedCWX1
    if (loadedCWY1 != "ERROR") checkweightY1 := loadedCWY1
    if (loadedCWX2 != "ERROR") checkweightX2 := loadedCWX2
    if (loadedCWY2 != "ERROR") checkweightY2 := loadedCWY2
    
    SetTimer, UpdateCoordinateDisplayDelayed, -500
}

UpdateCoordinateDisplayDelayed:
    UpdateCoordinateDisplay()
return

UpdateCoordinateDisplay() {
    global checkweightX1, checkweightY1, checkweightX2, checkweightY2
    
    coordText := "Area: " . checkweightX1 . "," . checkweightY1 . " to " . checkweightX2 . "," . checkweightY2
    
    GuiControl,, CheckSnapshotCoordsText, %coordText%
}

ForceRefreshDPS:
    RefreshDPSPriorityList()
return

ForceRefreshHeal:
    RefreshHealPriorityList()
return

; Timer functions to remove health dots
RemoveHealthDot1:
    Gui, HealthDot1:Destroy
return
RemoveHealthDot2:
    Gui, HealthDot2:Destroy
return
RemoveHealthDot3:
    Gui, HealthDot3:Destroy
return
RemoveHealthDot4:
    Gui, HealthDot4:Destroy
return
RemoveHealthDot5:
    Gui, HealthDot5:Destroy
return
RemoveHealthDot6:
    Gui, HealthDot6:Destroy
return
RemoveHealthDot7:
    Gui, HealthDot7:Destroy
return
RemoveHealthDot8:
    Gui, HealthDot8:Destroy
return
RemoveHealthDot11:
    Gui, HealthDot11:Destroy
return
RemoveHealthDot12:
    Gui, HealthDot12:Destroy
return
RemoveHealthDot13:
    Gui, HealthDot13:Destroy
return
RemoveHealthDot14:
    Gui, HealthDot14:Destroy
return
RemoveHealthDot15:
    Gui, HealthDot15:Destroy
return
RemoveHealthDot16:
    Gui, HealthDot16:Destroy
return

; ========= MANUAL HEALING FUNCTIONS =========
SetManualCoords:
    Gui, Submit, NoHide
    PlayerCount := PlayerCountEdit
    PetCount := PetCountEdit
    
    if (PlayerCount = 0 && PetCount = 0) {
        UpdateHealerStatus("Set at least 1 player or pet count first.")
        return
    }
    
    ManualPlayerCoords := []
    ManualPetCoords := []
    
    Gui, Hide
    
    if (PlayerCount > 0) {
        MsgBox, Click OK then left-click on %PlayerCount% player health bar locations.
        Loop, %PlayerCount% {
            ToolTip, Click on Player %A_Index% health bar, 100, 100
            KeyWait, LButton, D
            MouseGetPos, px, py
            ManualPlayerCoords.Push({x: px, y: py})
            KeyWait, LButton
            Sleep, 200
        }
    }
    
    if (PetCount > 0) {
        MsgBox, Now left-click on %PetCount% pet health bar locations.
        Loop, %PetCount% {
            ToolTip, Click on Pet %A_Index% health bar, 100, 100
            KeyWait, LButton, D
            MouseGetPos, px, py
            ManualPetCoords.Push({x: px, y: py})
            KeyWait, LButton
            Sleep, 200
        }
    }
    
    ToolTip
    Gui, Show
    
    statusText := "Manual coords set: " . PlayerCount . " players, " . PetCount . " pets"
    GuiControl,, ManualHealStatus, %statusText%
    UpdateHealerStatus(statusText)
return

StartManualHealing:
    if (ManualPlayerCoords.Length() = 0 && ManualPetCoords.Length() = 0) {
        UpdateHealerStatus("Set manual coordinates first.")
        return
    }
    
    isManualHealingActive := true
    SetTimer, ManualHealthCheck, %healCheckInterval%
    UpdateHealerStatus("Manual healing started - checking " . ManualPlayerCoords.Length() . " players, " . ManualPetCoords.Length() . " pets")
return

StopManualHealing:
    isManualHealingActive := false
    SetTimer, ManualHealthCheck, Off
    UpdateHealerStatus("Manual healing stopped.")
return

ManualHealthCheck:
    if (!isManualHealingActive)
        return
    
    ; Check manual player coordinates
    for index, coords in ManualPlayerCoords {
        checkX := coords.x
        checkY := coords.y
        
        ; Look for full health (green)
        healthFull := "|<>##0.90$0/0/24690C,0/1/00AA90,0/2/006655,0/3/3ED514"
        healthFull.="|<>##0.90$0/0/51CA2F,0/1/48C723,0/2/42D019,0/3/25A800,0/4/259F00"

        healthFound := FindText(0, 0, checkX-10, checkY-10, checkX+10, checkY+10, 0, 0, healthFull)
        
        if (!healthFound) {
            SendMessageClick(checkX, checkY)
            TryCastHealingSkill()
            UpdateHealerStatus("→ Healed Manual Player " . index)
            Sleep, 25
        }
    }
    
    ; Check manual pet coordinates
    for index, coords in ManualPetCoords {
        checkX := coords.x
        checkY := coords.y
        
        ; Look for full health (green)
        healthFull := "|<>##0.90$0/0/24690C,0/1/00AA90,0/2/006655,0/3/3ED514"
        healthFull.="|<>##0.90$0/0/51CA2F,0/1/48C723,0/2/42D019,0/3/25A800,0/4/259F00"
        healthFound := FindText(0, 0, checkX-10, checkY-10, checkX+10, checkY+10, 0, 0, healthFull)
        
        if (!healthFound) {
            SendMessageClick(checkX, checkY)
            TryCastHealingSkill()
            UpdateHealerStatus("→ Healed Manual Pet " . index)
            Sleep, 25
        }
    }
return
DPSTargetedHealthCheck:
    ; Check DPS targeted player coordinates
    for index, coords in DPSTargetedPlayerCoords {
        checkX := coords.x
        checkY := coords.y
        
        ; Look for full health (green)
        healthFull := "|<>##0.90$0/0/24690C,0/1/00AA90,0/2/006655,0/3/3ED514"
        healthFound := FindText(0, 0, checkX-10, checkY-10, checkX+10, checkY+10, 0, 0, healthFull)
        
        if (!healthFound) {
            SendMessageClick(checkX, checkY)
            TryCastHealingSkill()
            Sleep, 25
        }
    }
    
    ; Check DPS targeted pet coordinates
    for index, coords in DPSTargetedPetCoords {
        checkX := coords.x
        checkY := coords.y
        
        ; Look for full health (green)
        healthFull := "|<>##0.90$0/0/24690C,0/1/00AA90,0/2/006655,0/3/3ED514"
        healthFound := FindText(0, 0, checkX-10, checkY-10, checkX+10, checkY+10, 0, 0, healthFull)
        
        if (!healthFound) {
            SendMessageClick(checkX, checkY)
            TryCastHealingSkill()
            Sleep, 25
        }
    }
return

LaunchGame:
  IniRead, outpath, %iniFile%, gamepath, path
  Run, %outpath%
Return

SelectGame:
  FileSelectFile, selectedGame, 3,, Select a game, Executables (*.exe)
  if (selectedGame != "") {
    MsgBox, You selected: %selectedGame%
    IniWrite, %selectedGame%, %iniFile%, gamepath, path
  }
Return
Characters:
  Gui, char:New
  Gui, char:Color, 444444
  Loop, 8 {
    IniRead, buttonName, %iniFile%, Character%A_Index%, username, Character %A_Index%
    y := (A_Index-1)*40 + 10
    Gui, char:Add, Button, x10 y%y% w100 h30 gChar%A_Index%, %buttonName%
    Gui, char:Add, Button, x120 y%y% w50 h30 gReset%A_Index%, Edit
  }
  Gui, char:Show, w180 h340, Characters
return

Reset1:
Reset2:
Reset3:
Reset4:
Reset5:
Reset6:
Reset7:
Reset8:
  CurrentChar := SubStr(A_ThisLabel, 6)
  Gui, login:New
  Gui, login:+AlwaysOnTop
  Gui, login:Add, Text,, Username:
  Gui, login:Add, Edit, vNewUser w150
  Gui, login:Add, Text,, Password:
  Gui, login:Add, Edit, vNewPass Password w150
  Gui, login:Add, Button, gSaveLogin w60, Save
  Gui, login:Show,, Edit Character
return

SaveLogin:
  Gui, login:Submit
  IniWrite, %NewUser%, %iniFile%, Character%CurrentChar%, username
  IniWrite, %NewPass%, %iniFile%, Character%CurrentChar%, password
  Gui, login:Destroy
  Gui, char:Destroy
  Gosub, Characters
return

Char1:
Char2:
Char3:
Char4:
Char5:
Char6:
Char7:
Char8:
  CurrentChar := SubStr(A_ThisLabel, 5)
  IniRead, username, %iniFile%, Character%CurrentChar%, username
  IniRead, password, %iniFile%, Character%CurrentChar%, password
  
  if (username = "ERROR" || password = "ERROR") {
    Gui, login:New
    Gui, login:+AlwaysOnTop
    Gui, login:Add, Text,, Username:
    Gui, login:Add, Edit, vNewUser w150
    Gui, login:Add, Text,, Password:
    Gui, login:Add, Edit, vNewPass Password w150
    Gui, login:Add, Button, gSaveLogin w60, Save
    Gui, login:Show,, Setup Character
  } else {
    KeyWait, LButton, D
    if (!InStr(username, "!")) {
      SendInput !
    }
    Sleep, 100
    SendInput %username%
    Sleep, 100
    SendInput {Tab}
    Sleep, 100
    SendInput %password%
    KeyWait, LButton
  }
return

launcherstartbutton:="|<>F68800-0.68$111.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzsC00S3s0w00zzzzzzzwqDzxjizUTzvzzzzzzzE50081k0E01Tzzzzzzo0801E60000/zzzzzzw0300c2o0601Tzzzzzzc200006U8003zzzzzzx5V00oEI0000zzzzzzzcHz0SU+UU40zzyDzzzx0Xs3UV411U7zzUzzzzo1D0R50Xkg0zzs7zzzyE2s3c8Y01U7zz0DzzzsUL0M74U0Q0zyU0zzzzl0M300Y03U7zU07zzzkW/0O00UWQ0zk00lzzwlFO2FwI03Ubw0003zzdU+EEE2UFA4z0000Dzs12G2W2405Ubk00033z80KE46FU8Y4w00007zwkAm04uA02Ua000007zkyD00300U400000007zU7w600001k00000003zzzzz0DU3zk0000000Dzzzzs0c0Dk00000000Dzzzy0000M0000000001zzk00000000004"
launcherstartbutton.="|<>FF7C00-0.68$111.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzvzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzQzz3s0w00zzzzzzzzzzzzzizlTzvzzzzzzzk700w1o0G01Tzzzzzzw0M05E6U0E0/zzzzzzz0300c2o0601TzzzzzzsSgUF0KU8U07zzzzzzz7dg8oEI4001zzmzzzzcTzUSW+UkA1zzs7zzzx1bs3kVI15UDzz0Tzzzo1D0R50Xkg1zzU0zzzyE6s3c8Y01UDzU07zzztUL0N74U3Q1zw00zzzzl1O3E0YM3Ujy007zzztW/EO02UWQ4yU000TzynFO2FwI4/Ubk0001zzda/EEE2UFA4w00007zt32u2W2415Ub00000Hzc0LE40FU8Y4U00000zwkBu0Y2A0WUU000000DlyT000000400000000DU7w600001k00000000zzzzw0000C000000001zzzz00001000004"
iD:="|<>*93$13.61rSPjZrmvxRyiyLTPj8ES" ;input field is 100 pixels to the right
loginbutton:="|<nohighlight>*65$111.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzw0000000000000000zz00000000000000003zs0000000000000000Tz00000000000000003zw0000000000000001zzp000000000000003jzyE000000000000009zzy000000000000001zzzk00000000000040Dzzwzzzzz7Uk03zzzzzzzzzzzzzwsUM3DzzzzzzzzzzzzzbC78tzzzzzzzzzzzzzwtkt7DzzzzzzzzzzzzzbC7+tzzzzzzzzzzzzzwsk1LDzzzzzzzzzzzzzU0k+tzzzzzzzzzzzzzzzzvzzzzzzzzzzzzzzzzzkTzzzzzzzzzzzzzzzzy7zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzw"
loginbutton.="|<highlight>**50$109.2080000000000001042zzzzzzzzzzzzzzzzx2k0000000000000003FE0000000000000000cc0000000000000000IJ0000000000000000e+300000000000000A54100000s00C0000000W100000Q005000000UEk00000+002U000000s8U000057zzzk00004E4000002X3Vc80000082000001HRipq0000041000000d+JOf0000020W00000IZ2hIU0000F0F00000+Ohqek00008U8k00005xqvJM0000A0080000237Zeg0000400000001zzyzS000000000000000GE00000000000000008s00000000000000007s000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001"

confirm:="|<>**50$109.0000000000000000001zzzzzzzzzzzzzzzzs1U00000000000000060U00000000000000010E0000000000000000U80000000000000000E000000000000000000000000T007s0000000000000Rs06I0000000000000Mg02u0000000000000PzzzTzzk0000000000Bb7FWeaM00000000006XRirLRo00000000003FvrOfiu00000000001cZ+hJJJ00000000000qyxKeeeU0000000000BxqfJJJE0000000000737Jeeec00000000001zzvxxrQ0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001"
confirm:="|<>**50$109.0000000000000000001zzzzzzzzzzzzzzzzs1U00000000000000060U00000000000000010E0000000000000000U80000000000000000E000000000000000000000000T007s0000000000000Rs06I0000000000000Mg02u0000000000000PzzzTzzk0000000000Bb7FWeaM00000000006XRirLRo00000000003FvrOfiu00000000001cZ+hJJJ00000000000qyxKeeeU0000000000BxqfJJJE0000000000737Jeeec00000000001zzvxxrQ0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001"

AutoLauncher:
  Gui, launcher:New
  Gui, launcher:Color, 444444
  Gui, launcher:Add, Text, x10 y10, Select Characters to Login:
  Loop, 8 {
    IniRead, charName, %iniFile%, Character%A_Index%, username, Character %A_Index%
    y := A_Index*25 + 30
    Gui, launcher:Add, Checkbox, x10 y%y% vChar%A_Index%, %charName%
  }
  Gui, launcher:Add, Button, x10 y260 w100 h30 gLaunchSelected, Launch
  Gui, launcher:Show, w200 h300, Auto Launcher
return

LaunchSelected:
  Gui, launcher:Submit
  selectedChars := []
  Loop, 8 {
    if (Char%A_Index%) {
      selectedChars.Push(A_Index)
    }
  }
  if (selectedChars.Length() = 0) {
    MsgBox, Please select at least one character
    return
  }
  
  for index, charNum in selectedChars {
    IniRead, username, %iniFile%, Character%charNum%, username
    IniRead, password, %iniFile%, Character%charNum%, password
    
    IniRead, gamePath, %iniFile%, gamepath, path
    Run, %gamePath%
    
    ; Wait for launcher and click start button until it disappears
    startTime := A_TickCount
    Loop {
      if (FindText(X, Y, 0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, launcherstartbutton)) {
        Loop {
          MouseClick, Left, %X%, %Y%
          Sleep, 500
          if (!FindText(0, 0, 0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, launcherstartbutton))
            break
        }
        break
      }
      if (A_TickCount - startTime > 30000) {
        MsgBox, Launcher start button not found after 30 seconds
        return
      }
      Sleep, 1000
    }
    
    ; Wait for client to launch and become active
    SplitPath, gamePath, , , , exeName
    WinWait, % "ahk_exe " exeName, , 60000
    WinActivate, % "ahk_exe " exeName
    WinWaitActive, % "ahk_exe " exeName, , 5000
    
    ; Skip intro
    Loop, 7 {
      Send, {Escape}
      Sleep, 100
    }
    
    ; Find ID field and login
    Loop {
      if (result := FindText(0, 0, 0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, iD)) {
        inputX := result.1.x + 100
        inputY := result.1.y
        WinActivate, % "ahk_exe " exeName
        Sleep, 50
        SendMessageClick(inputX, inputY)
        Sleep, 100
        Send, %username%
        Send, {Enter}
        break
      }
      Sleep, 100
    }
    
    ; Wait for confirm button and keep pressing enter
    confirmCount := 0
    Loop {
      if (FindText(0, 0, 0, 0, A_ScreenWidth, A_ScreenHeight, 0, 0, confirm)) {
        WinActivate, % "ahk_exe " exeName
        Send, {Enter}
        confirmCount := 0
      } else {
        confirmCount++
        if (confirmCount >= 8)
          break
      }
      Sleep, 100
    }
    
    if (index < selectedChars.Length())
      Sleep, 2000
  }
return

