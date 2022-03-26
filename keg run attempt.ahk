coordmode, Mouse, Screen
f7::Reload
F6::

loop
{
    
        {
            ;Phase 1
            loop 
                {
                PixelSearch, Px, Py, 1, 1, 1376, 759, 0x1336E2, 3, Fast
                sleep 500
                }
                until errorlevel = 0

                MouseMove, Px, Py, 1
                Random, r, 150,250
                Sleep %r% 
                MouseClick, right
                Random, r, 150,250
                Sleep %r% 
                MouseMove, Px, Py+40, 
                Random, r, 150,250
                Sleep %r% 
                MouseClick, left
                Random, r, 150,250
                Sleep %r% 
        }
            Random, r, 1000,2000
            Sleep %r% 
        {
            ;phase 2
      
            ImageSearch, foundX, foundY, 1, 1, 1376, 759, *20 C:\Users\josh\Desktop\New folder\keg.png
            sleep 500
                if errorlevel = 0
                {
                    MouseClick, right, 451, 206+10, 1
                    Random, r, 150,250
                    Sleep %r% 
                    Random, r, 150,250
                    Sleep %r% 
                    mousemove, 451,301
                    Random, r, 150,250
                    Sleep %r% 
                    click
                    Random, r, 150,250
                    Sleep %r% 
                    Random, RandX, 1178,1185
                    Random, RandY, 115,120
                    MouseClick,left, RandX, RandY , 1, 4
                    Random, r, 15000,18000
                    Sleep %r% 
                }
                if errorlevel = 1
                Loop
                {
                loop 
                {
                    PixelSearch, Px, Py, 1, 1, 1376, 759, 0x1336E2, 3, Fast
                    sleep 500
                }
                until errorlevel = 0
                    MouseMove, Px, Py, 1
                    Random, r, 150,250
                    Sleep %r% 
                    MouseClick, right
                    Random, r, 150,250
                    Sleep %r% 
                    MouseMove, Px, Py+40, 
                    Random, r, 150,250
                    Sleep %r% 
                    MouseClick, left
                    Random, r, 150,250
                    Sleep %r% 
                }
                until errorlevel not = 1
            
        }
    
    loop
    {       
        PixelSearch, Px, Py, 1, 1, 1376, 759, 0x1336E2, 3, Fast
        sleep 500
    }
        until errorlevel = 0
            MouseMove, Px, Py, 1
            MouseClick, right
            Random, r, 150,250
            Sleep %r% 
            MouseMove, Px, Py+40, 
            Random, r, 150,250
            Sleep %r% 
            MouseClick, left
            Random, r, 150,250
            Sleep %r% 
    
    Loop
    {
        ImageSearch, foundX, foundY, 633, 115, 741, 359, *20 C:\Users\josh\Desktop\New folder\keg1.png
        sleep 500
    }
       until errorlevel = 0
            varxpos := foundX + 5
            varypos := foundY + 10
            { ;If the first image was found:
                MouseClick, left, foundX, foundY+10,
                Random, r, 150,250
            Sleep %r% 
            }
    
    Random, r, 1000,1500
    Sleep %r% 
    Random, RandX, 1314,1320
    Random, RandY, 86,124
    MouseClick,left, RandX, RandY , 1, 4
    Random, r, 15000,16000
    Sleep %r% 

    
 
       

    ClickRandom(minX,maxX,minY,maxY,sleepMin:=42,sleepMax:=133) {
    Random, rndX, %minX%, %maxX%
    Random, rndY, %minY%, %maxY%
    Random, SleepAmount, %sleepMin%, %sleepMax%      
    ToolTip, % rndX "`t" rndY, 3050000,100
    Click, %rndX%, %rndY%
    Sleep, %SleepAmount%
    }       
       
}
 
