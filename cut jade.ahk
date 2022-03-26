#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
coordmode, Mouse, Screen, pixel
F7:: reload
F6::
InputBox, loop, loop,how many repititions? Default is (99999999999999999999999), ,200,180, , , Locale, , 99999999999999999999999

loop, %loop%
{
    ;click bank
        start:
    loop
    {
        ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\object2.png
        sleep, 55 
    }
        until errorlevel = 0
            varxpos := foundX + 3
            varypos := foundY + 4
            mousemove(varxpos-2,varxpos+3,varypos-3,varypos+2)
            Random, r, 80,115
            sleep, %r%
            click, up
            Random, r, 450,850
            sleep, %r%
    
    ;click cut crystals in inventory
        ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\cutjade.png
        If errorlevel = 0 
        {
            varxpos := foundX + 10
            varypos := foundY + 10
            mousemove(varxpos-7,varxpos+7,varypos-7,varypos+7)
            Random, r, 80,115
            sleep, %r%
            click, up
            Random, r, 450,850
            sleep, %r%
        }
        ;click crystal dust in inventory
        ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\jadedust.png
        If errorlevel = 0 
        {
            varxpos := foundX + 10
            varypos := foundY + 10
            mousemove(varxpos-7,varxpos+7,varypos-7,varypos+7)
            Random, r, 80,115
            sleep, %r%
            click, up
            Random, r, 450,850
            sleep, %r%
        }
    loop
    {
        ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\bankuncutjade.png
            Random, r, 250,350
            sleep, %r%
    }
    until errorlevel = 0 
            varxpos := foundX 
            varypos := foundY 
            mousemove(varxpos,varxpos+7,varypos,varypos+5)
            Random, r, 80,115
            sleep, %r%
            click, up


    ;close bank window
    loop
        {
            ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\closebank.png
            sleep 55
        }
            until errorlevel = 0 
                varxpos := foundX + 9
                varypos := foundY + 9
                mousemove(varxpos-6,varxpos+6,varypos-6,varypos+6)
                Random, r, 80,115
                sleep, %r%
                click, up
                Random, r, 50,117
                sleep, %r%

    ;click chisel in inventory
    loop
        {
            ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\chisel.png
            sleep 55
        }
            until errorlevel = 0 
                varxpos := foundX + 10
                varypos := foundY + 12
                mousemove(varxpos-9,varxpos+11,varypos-10,varypos+13)
                Random, r, 80,115
                sleep, %r%
                click, up
  

    ;click uncut ruby
        
            ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\uncutjade.png
            sleep 55
            if errorlevel = 0 
                varxpos := foundX + 13
                varypos := foundY + 10
                mousemove(varxpos-11,varxpos+12,varypos-9,varypos+10)
                Random, r, 80,115
                sleep, %r%
                click, up
            if errorlevel = 1
            goto start

    ;click cut ruby button
    loop
        {
            ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\confirmcutjade.png
            sleep 55
        }
            until errorlevel = 0 
                varxpos := foundX + 38
                varypos := foundY + 28
                mousemove(varxpos-32,varxpos+32,varypos-14,varypos+20)
                Random, r, 80,115
                sleep, %r%
                click, up

    ;check for level up----------------------------------------------------------------------------------------------------------------------
    loop, 32
        {
            ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\craftlevelup.png
            sleep 1000
            if errorlevel = 0 
            {
                    ;click chisel in inventory
                    loop
                        {
                            ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\chisel.png
                            sleep 55
                        }
                            until errorlevel = 0 
                                varxpos := foundX + 10
                                varypos := foundY + 12
                                mousemove(varxpos-9,varxpos+11,varypos-10,varypos+13)
                                Random, r, 80,115
                                sleep, %r%
                                click, up
                                Random, r, 50,117
                                sleep, %r%    

                    ;click uncut ruby
                            ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\uncutjade.png
                            sleep 55
                            if errorlevel = 0 
                                varxpos := foundX + 13
                                varypos := foundY + 10
                                mousemove(varxpos-11,varxpos+12,varypos-9,varypos+10)
                                Random, r, 80,115
                                sleep, %r%
                                click, up

                            if errorlevel = 1
                            goto skipp

                    ;click cut ruby button
                    loop
                        {
                            ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\confirmcutjade.png
                            sleep 55
                        }
                            until errorlevel = 0 
                                varxpos := foundX + 38
                                varypos := foundY + 28
                                mousemove(varxpos-32,varxpos+32,varypos-14,varypos+20)
                                Random, r, 80,115
                                sleep, %r%
                                click, up
                                Random, r, 50,117
                                sleep, %r%
            }
                
        }      ;end level up check---------------------------------------------------------------------------------------------------------- 
    Random, r, 55, 6000
    sleep, %r%
    skipp:
    Random, r, 50,117
    sleep, %r%
}

;FUNCTIONS
mousemove(minX,maxX,minY,maxY,sleepMin:=42,sleepMax:=133) {
   Random, rndX, %minX%, %maxX%
   Random, rndY, %minY%, %maxY%
   Random, SleepAmount, %sleepMin%, %sleepMax%      
   ToolTip, % rndX "`t" rndY, 305500,100
   Click, %rndX%, %rndY%
   Sleep, %SleepAmount%
}
