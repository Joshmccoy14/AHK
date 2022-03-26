
coordmode, Mouse, Screen, pixel
F7:: reload
F6::

loop
{
    ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\bones.png
    If errorlevel = 0 
        varxpos := foundX + 5
        varypos := foundY + 10
        mousemove(varxpos,varxpos+10,varypos,varypos+5)
        Random, r, 80,115
        sleep, %r%
        click, up
        sleep, 50
        
        

        Random, r, 250,375
        Sleep %r% 

        Loop
        {
        ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\phials.png
        sleep 100
        }
        until errorlevel = 0 
        varxpos := foundX 
        varypos := foundY 
        mousemove(varxpos,varxpos+2,varypos,varypos+2)
        Random, r, 40,93
        Sleep %r% 
        click, up  
        Random, r, 5500,6000
        Sleep %r% 
        

    RandClick(263, 682, 5)

Random, r, 250,375
Sleep %r% 


        Loop
        {
        ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\object.png
        sleep 100
        }
        until errorlevel = 0
        varxpos := foundX 
        varypos := foundY 
        mousemove(varxpos,varxpos+10,varypos,varypos+10)
        MouseClick, right
        Random, r, 500,700
        Sleep %r% 
        Loop
        {
        ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\visitlast.png
        sleep 100
        }
        until errorlevel = 0 
        {
            varxpos := foundX + 15
            varypos := foundY + 4
            mousemove(varxpos,varxpos+1,varypos,varypos+1)
            Random, r, 45,93
            Sleep %r% 
            click, up 
            Random, r, 7000,8000
            Sleep %r% 
        }
      
    ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\bones2.png
    If errorlevel = 0 
        varxpos := foundX + 5
        varypos := foundY + 10
        mousemove(varxpos,varxpos+10,varypos,varypos+5)
        Random, r, 80,115
        sleep, %r%
        MouseClick, right
        Random, r, 500,650
        sleep, %r%
        Loop
        {
        ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\use.png
        sleep 100
        }
        until errorlevel = 0
        varxpos := foundX + 5
        varypos := foundY + 10
        mousemove(varxpos,varxpos+15,varypos,varypos+3)
        Random, r, 80,115
        sleep, %r%        
        click, up
        

        Random, r, 250,375
        Sleep %r%       
        Loop, 
        {
        ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\object.png
        sleep 500
        }
        until errorlevel = 0
        varxpos := foundX 
        varypos := foundY 
        mousemove(varxpos,varxpos+10,varypos,varypos+10)
        click, up 
        Random, r, 250,350
        Sleep %r%     
;altar bones and check for pray level up. if level up is found then bones will be altared again.---------------------------- 
;if level up is found and no bones in inventory then leaves altar for more bones.-------------------------------------------
        loop, 57  
        {
        ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\prayerlvlup.png
        sleep 1150
        if errorlevel = 0
            {
                ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\bones2.png
                If errorlevel = 0 
                varxpos := foundX + 5
                varypos := foundY + 10
                mousemove(varxpos,varxpos+10,varypos,varypos+5)
                Random, r, 80,115
                sleep, %r%
                MouseClick, right
                Random, r, 500,650
                sleep, %r%
                if errorlevel = 1
                {
                    Goto, skip
                }
                Loop
                {
                    ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\use.png
                    sleep 100
                }
                    until errorlevel = 0
                    varxpos := foundX + 5
                    varypos := foundY + 10
                    mousemove(varxpos,varxpos+15,varypos,varypos+3)
                    Random, r, 80,115
                    sleep, %r%        
                    click, up
                    

                    Random, r, 250,375
                    Sleep %r%       
                Loop, 
                {
                    ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\object.png
                    sleep 500
                }
                    until errorlevel = 0
                    varxpos := foundX 
                    varypos := foundY 
                    mousemove(varxpos,varxpos+10,varypos,varypos+10)
                    click, up 
                    Random, r, 250,350
                    Sleep %r%     
            }
        }
        skip:        
        Random, r, 1000,2000
        Sleep %r%    
;end of altaring bones-------------------------------------------------------------------------------------------------
        loop  
        {
        ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\object2.png
        sleep 500
        }
        until errorlevel = 0
        varxpos := foundX 
        varypos := foundY 
        mousemove(varxpos,varxpos+5,varypos,varypos+5)
        click, up
        Random, r, 5000,8000
        Sleep %r%     

}                      




;FUNCTIONS

mousemove(minX,maxX,minY,maxY,sleepMin:=42,sleepMax:=133) {
   Random, rndX, %minX%, %maxX%
   Random, rndY, %minY%, %maxY%
   Random, SleepAmount, %sleepMin%, %sleepMax%      
   ToolTip, % rndX "`t" rndY, 3050000,100
   Click, %rndX%, %rndY%
   Sleep, %SleepAmount%
}
RandClick(X, Y, rand)
{ ; obeys current mouse CoordMode !!
	Random, RandX, -rand, rand
	Random, RandY, -rand, rand
	MouseClick, Left, X+RandX, Y+RandY
}
;object2.png color - FF091F9D
;object.png color - FFFF001D
;phials.png color - 26FF00