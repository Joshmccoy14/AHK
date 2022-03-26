SetDefaultMouseSpeed 0

coordmode, Mouse, Screen, pixel
F6:: exitapp
F7:: reload
F8::
Loop
{

ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\prayer1.png
sleep 500
If ! ErrorLevel 
    { ;If the first image was found:
        varxpos := foundX + 5
        varypos := foundY + 10
        mousemove(varxpos,varxpos+15,varypos,varypos+15)
        Random, r, 72,221
        sleep, %r%
        mouseclick, left, , , 1
    } 
    Else 
    { ;If the first image was not found:
        ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\prayer2.png
        sleep 500
        If ! ErrorLevel 
        { ;If the second image was found:
            varxpos := foundX + 5
            varypos := foundY + 10
            mousemove(varxpos,varxpos+15,varypos,varypos+15)
            Random, r, 72,221
            Sleep %r%
            mouseclick, left, , ,1
             
        }
    Else 
        { ;If the first image was not found:
           ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\prayer3.png
           sleep 500
           If ! ErrorLevel 
           { ;If the second image was found:
               varxpos := foundX + 5
               varypos := foundY + 10
               mousemove(varxpos,varxpos+15,varypos,varypos+15)
               Random, r, 72,221
               Sleep %r%
               mouseclick, left, , ,1
            }
        Else 
            { ;If the first image was not found:
              ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\prayer4.png
              sleep 500
              If ! ErrorLevel 
               { ;If the second image was found:
                  varxpos := foundX + 5
                  varypos := foundY + 10
                  mousemove(varxpos,varxpos+15,varypos,varypos+15)
                  Random, r, 72,221
                  Sleep %r%
                  mouseclick, left, , ,1
                }
            }
        }
    } 
        Random, r, 60000, 65000
        sleep, %r%       
}
mousemove(minX,maxX,minY,maxY,sleepMin:=43,sleepMax:=133) {
   Random, rndX, %minX%, %maxX%
   Random, rndY, %minY%, %maxY%
   Random, SleepAmount, %sleepMin%, %sleepMax%      
   ToolTip, % rndX "`t" rndY, 2050000,100
   Click, %rndX%, %rndY%
   Sleep, %SleepAmount%
}
