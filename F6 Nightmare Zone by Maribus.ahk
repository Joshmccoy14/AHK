SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
coordmode, Mouse, Screen, pixel

*esc:: exitapp
F7::reload
F6::
InputBox, DelayStart, Set Start Delay, set a start delay time in milliseconds. default is 0., , 200, 180, , , Locale, , 0
sleep, 100
InputBox, Speed, Mouse Speed, set mouse movement speed. default is 0. 0 for instant, , 200, 180, , , Locale, , 0
SetDefaultMouseSpeed, %Speed%
sleep 100
InputBox, mini, Set click delay, set minimum click delay. default is 70. does not effect prayer click speed, , 200, 180, , , Locale, , 70
sleep, 100
InputBox, maxi, Set click delay, set maximum click delay default is 220. does not effect prayer click speed, , 200, 180, , , Locale, , 220
sleep, 100
Sleep, %DelayStart%

Loop, 
{
    {
    ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\png's\stop.png
    If ! ErrorLevel
    {
    MsgBox, stop trigger found
    Pause
    } 
    
}

    ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\png's\prayeroff.png
    If ! ErrorLevel 
        { ;If the first image was found:
         varxpos := foundX + 5
         varypos := foundY + 10
            mousemove(varxpos,varxpos+10,varypos,varypos+10)
            Random, r, 72,221
            Sleep %r% 
            Mouseclick, left
        } 
        Random, r, 20000,50000
        Sleep %r%


Random, r, 72, 151
Sleep %r%


ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\png's\overloadcheck.png
if ErrorLevel = 1
{
ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\png's\overload1.png
If ! ErrorLevel 
    { ;If the first image was found:
        varxpos := foundX + 5
        varypos := foundY + 10
        mousemove(varxpos,varxpos+15,varypos,varypos+15)
        Random, r, %mini%, %maxi%
        sleep, %r%
        mouseclick, left
    } 
    Else 
    { ;If the first image was not found:
        ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\png's\overload2.png
        If ! ErrorLevel 
        { ;If the second image was found:
            varxpos := foundX + 5
            varypos := foundY + 10
            mousemove(varxpos,varxpos+15,varypos,varypos+15)
            Random, r, %mini%, %maxi%
            sleep, %r%
            mouseclick, left
             
        }
    Else 
        { ;If the first image was not found:
           ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\png's\overload3.png
           If ! ErrorLevel 
           { ;If the second image was found:
               varxpos := foundX + 5
               varypos := foundY + 10
               mousemove(varxpos,varxpos+15,varypos,varypos+15)
               Random, r, %mini%, %maxi%
               sleep, %r% 
               mouseclick, left
            }
        Else 
            { ;If the first image was not found:
              ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\png's\overload4.png
              If ! ErrorLevel 
               { ;If the second image was found:
                  varxpos := foundX + 5
                  varypos := foundY + 10
                  mousemove(varxpos,varxpos+15,varypos,varypos+15)
                  Random, r, %mini%, %maxi%
                  sleep, %r%
                  mouseclick, left
                }
            }
        }
    }            
}
Random, r, 72, 151
Sleep %r%
{
ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\png's\absorb1.png
If ! ErrorLevel 
    { ;If the first image was found:
        varxpos := foundX + 5
        varypos := foundY + 10
        mousemove(varxpos,varxpos+15,varypos,varypos+15)
        Random, r, %mini%, %maxi%
        sleep, %r%
        mouseclick, left
    } 
    Else 
    { ;If the first image was not found:
        ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\png's\absorb2.png
        If ! ErrorLevel 
        { ;If the second image was found:
            varxpos := foundX + 5
            varypos := foundY + 10
            mousemove(varxpos,varxpos+15,varypos,varypos+15)
            Random, r, %mini%, %maxi%
            sleep, %r%
            mouseclick, left
             
        }
    Else 
        { ;If the first image was not found:
           ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\png's\absorb3.png
           If ! ErrorLevel 
           { ;If the second image was found:
               varxpos := foundX + 5
               varypos := foundY + 10
               mousemove(varxpos,varxpos+15,varypos,varypos+15)
               Random, r, %mini%, %maxi%
               sleep, %r% 
               mouseclick, left
            }
        Else 
            { ;If the first image was not found:
              ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\png's\absorb4.png
              If ! ErrorLevel 
               { ;If the second image was found:
                  varxpos := foundX + 5
                  varypos := foundY + 10
                  mousemove(varxpos,varxpos+15,varypos,varypos+15)
                  Random, r, %mini%, %maxi%
                  sleep, %r%
                  mouseclick, left
                }
            }
        }
    }            
}
Random, r, %mini%, %maxi%
Sleep %r%

}

mousemove(minX,maxX,minY,maxY,sleepMin:=42,sleepMax:=133) {
   Random, rndX, %minX%, %maxX%
   Random, rndY, %minY%, %maxY%
   Random, SleepAmount, %sleepMin%, %sleepMax%      
   ToolTip, % rndX "`t" rndY, 3050000,100
   Click, %rndX%, %rndY%
   Sleep, %SleepAmount%
}
