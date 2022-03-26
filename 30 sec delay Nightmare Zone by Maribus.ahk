coordmode, Mouse, Screen
sleep 30000
Loop
{
    {
    ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\png's\stop.png
    If ! ErrorLevel
    Pause 
}

    ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\png's\prayeroff.png
    If ! ErrorLevel 
        { ;If the first image was found:
         varxpos := foundX + 5
         varypos := foundY + 10
            ClickRandom(varxpos,varxpos+5,varypos,varypos+5)
            Random, r, 72,221
            Sleep %r% 
            Mouseclick, left
        } 
        Random, r, 20000,50000
        Sleep %r%

ClickRandom(minX,maxX,minY,maxY,sleepMin:=42,sleepMax:=133) {
   Random, rndX, %minX%, %maxX%
   Random, rndY, %minY%, %maxY%
   Random, SleepAmount, %sleepMin%, %sleepMax%      
   ToolTip, % rndX "`t" rndY, 3050000,100
   Click, %rndX%, %rndY%
   Sleep, %SleepAmount%
}


ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\png's\overloadcheck.png
if ErrorLevel = 1
{
ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\png's\overload1.png
If ! ErrorLevel 
    { ;If the first image was found:
        varxpos := foundX + 5
        varypos := foundY + 10
        ClickRandom(varxpos,varxpos+15,varypos,varypos+15)
    } 
    Else 
    { ;If the first image was not found:
        ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\png's\overload2.png
        If ! ErrorLevel 
        { ;If the second image was found:
            varxpos := foundX + 5
            varypos := foundY + 10
            ClickRandom(varxpos,varxpos+15,varypos,varypos+15)
             
        }
    Else 
        { ;If the first image was not found:
           ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\png's\overload3.png
           If ! ErrorLevel 
           { ;If the second image was found:
               varxpos := foundX + 5
               varypos := foundY + 10
               ClickRandom(varxpos,varxpos+15,varypos,varypos+15) 
            }
        Else 
            { ;If the first image was not found:
              ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\png's\overload4.png
              If ! ErrorLevel 
               { ;If the second image was found:
                  varxpos := foundX + 5
                  varypos := foundY + 10
                  ClickRandom(varxpos,varxpos+15,varypos,varypos+15)
                }
            }
        }
    }            
}
{
ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\png's\absorb1.png
If ! ErrorLevel 
    { ;If the first image was found:
        varxpos := foundX + 5
        varypos := foundY + 10
        ClickRandom(varxpos,varxpos+15,varypos,varypos+15)
    } 
    Else 
    { ;If the first image was not found:
        ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\png's\absorb2.png
        If ! ErrorLevel 
        { ;If the second image was found:
            varxpos := foundX + 5
            varypos := foundY + 10
            ClickRandom(varxpos,varxpos+15,varypos,varypos+15)
             
        }
    Else 
        { ;If the first image was not found:
           ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\png's\absorb3.png
           If ! ErrorLevel 
           { ;If the second image was found:
               varxpos := foundX + 5
               varypos := foundY + 10
               ClickRandom(varxpos,varxpos+15,varypos,varypos+15) 
            }
        Else 
            { ;If the first image was not found:
              ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\png's\absorb4.png
              If ! ErrorLevel 
               { ;If the second image was found:
                  varxpos := foundX + 5
                  varypos := foundY + 10
                  ClickRandom(varxpos,varxpos+15,varypos,varypos+15)
                }
            }
        }
    }            
}

}

