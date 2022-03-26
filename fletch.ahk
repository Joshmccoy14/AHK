coordmode, Mouse, Screen, 
f7::Reload
*esc:: exitapp
F6::


carvearrowshaft: ;make sure knife is in top left inventory slot and arrow shafts are directly to the right of knife in inv
Loop 161
{
    bank:
    clickrandom(603, 628, 418, 449) ;click banker-----------------------------------------------------
    Random, r, 72,221
    Sleep %r% 
    ;click willow log in bank-----------------------------------------------------
    Loop
    {
        ImageSearch, foundX, foundY, 620, 93, 707, 153,*20 C:\Users\josh\Desktop\New folder\willowlog.png
        Random, r, 50,112
        sleep %r%
    }
        until errorlevel = 0 
        { ;If the first image was found:
         varxpos := foundX + 5
         varypos := foundY + 10
            ClickRandom(varxpos,varxpos+5,varypos,varypos+5)
        } 
        if errorlevel = 1
        MsgBox, (image not found)
    Random, r, 50,112
    sleep %r%
    ClickRandom(758, 773, 35, 50) ;click bank window close
    Random, r, 235,322
    sleep %r%
    ;click knife-----------------------------------------------------
    Loop
    {
        ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\knife.png
        Random, r, 50,112
        sleep %r%
    }
        until errorlevel = 0 
        { ;If the first image was found:
         varxpos := foundX + 5
         varypos := foundY + 10
            ClickRandom(varxpos,varxpos+5,varypos,varypos+5)
        }
    ;click willow log-----------------------------------------------------
    Loop
    {
        ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\willowloginv.png
        Random, r, 50,112
        sleep %r%
    }
        until errorlevel = 0 
        { ;If the first image was found:
         varxpos := foundX + 5
         varypos := foundY + 10
            ClickRandom(varxpos,varxpos+5,varypos,varypos+5)
        }
    Random, r, 50,112
    sleep %r%
    ;click fletch shaft-----------------------------------------------------
    Loop
    {
        ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\fletchshaft.png
        Random, r, 50,112
        sleep %r%
    }
        until errorlevel = 0 
        { ;If the first image was found:
         varxpos := foundX + 5
         varypos := foundY + 10
            ClickRandom(varxpos,varxpos+5,varypos,varypos+5)
        } 
    Random, r, 326, 428
    sleep %r%
    invcheck: ;inv check/levelup-----------------------------------------------------
    Loop, 57
    {
        ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\fletchlevelup.png
        sleep 1000
    }
        if errorlevel = 0
        {
                        ;click knife-----------------------------------------------------
            Loop
            {
                ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\knife.png
                Random, r, 50,112
                sleep %r%
            }
                until errorlevel = 0 
                { ;If the first image was found:
                    varxpos := foundX + 5
                    varypos := foundY + 10
                    ClickRandom(varxpos,varxpos+5,varypos,varypos+5)
                }
                ;click willow log-----------------------------------------------------
                ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\willowloginv.png
                Random, r, 50,112
                sleep %r%
                if errorlevel = 0 
                { ;If the first image was found:
                    varxpos := foundX + 5
                    varypos := foundY + 10
                    ClickRandom(varxpos,varxpos+5,varypos,varypos+5)
                }
                if errorlevel = 1
                {
                    Goto, skip
                }
                Random, r, 50,112
                sleep %r%
                ;click fletch shaft-----------------------------------------------------
                Loop
                {
                    ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\fletchshaft.png
                    Random, r, 50,112
                    sleep %r%
                }
                    until errorlevel = 0 
                    { ;If the first image was found:
                        varxpos := foundX + 5
                        varypos := foundY + 10
                        ClickRandom(varxpos,varxpos+5,varypos,varypos+5)
                    } 
                Random, r, 326, 428
                sleep %r%
    }
skip:
Random, r, 326, 428
sleep %r%

       

    ClickRandom(minX,maxX,minY,maxY,sleepMin:=250,sleepMax:=500) 
    {
        Random, rndX, %minX%, %maxX%
        Random, rndY, %minY%, %maxY%
        Random, SleepAmount, %sleepMin%, %sleepMax%      
        ToolTip, % rndX "`t" rndY, 3050000,100
        Click, %rndX%, %rndY%
        Sleep, %SleepAmount%
    }

}
