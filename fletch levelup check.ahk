*esc:: exitapp
F4::
loop
{
	Loop
    	{
        ImageSearch, foundX, foundY, 1, 1, 1365, 759,*20 C:\Users\josh\Desktop\New folder\levelup.png
	sleep 500
	}
        until errorlevel = 0
        clickrandom(603, 628, 418, 449)

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