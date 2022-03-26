#Include export.ahk
coordmode, Mouse, Screen, pixel
A := new biga() ; requires https://www.npmjs.com/package/biga.ahk
F7:: Pause
F6::
InputBox, loop, loop,how many repititions? Default is (99999999999999999999999), ,200,180, , , Locale, , 99999999999999999999999

loop, %loop%
{
    Loop, 27
    {
        loop
        {
            
            ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\object2.png
            sleep 50
        }
            until errorlevel = 0
            varxpos := foundX + 3
            varypos := foundY + 4
            mousemove(varxpos-2,varxpos+3,varypos-3,varypos+2)
            Random, r, 80,115
            sleep, %r%
            click, up
            sleep, 2000
    }
coordArr := [[1145,530]
        , [1145,495]
        , [1145,565]
        , [1145,603]
        , [1145,639]
        , [1145,674]
        , [1145,709]

        , [1190,495]
        , [1190,530]
        , [1190,566]
        , [1190,602]
        , [1190,636]
        , [1190,674]
        , [1190,710]

        , [1230,495]
        , [1230,530]
        , [1230,566]
        , [1230,602]
        , [1230,636]
        , [1230,674]
        , [1230,710]

        , [1270,495]
        , [1270,530]
        , [1270,566]
        , [1270,602]
        , [1270,636]
        , [1270,674]
        , [1270,710]]

; randomize the order
coordArr := A.shuffle(coordArr)
for key, value in coordArr {
    varxpos := % value[1]
    varypos := % value[2]
    ;print("clicking: x" value[1] " y" value[2])
     mousemove(varxpos-8,varxpos+8,varypos-8,varypos+8)
     Random, r, 23,55
     sleep, %r%
     send {ShiftDown}{click}
     Random, r, 23,87
     sleep, %r%
     
}
send {ShiftUp}

;FUNCTIONS
mousemove(minX,maxX,minY,maxY,sleepMin:=42,sleepMax:=133) {
   Random, rndX, %minX%, %maxX%
   Random, rndY, %minY%, %maxY%
   Random, SleepAmount, %sleepMin%, %sleepMax%      
   ToolTip, % rndX "`t" rndY, 305500,100
   Click, %rndX%, %rndY%
   Sleep, %SleepAmount%
}
}
