oscillographicShift = 0
heartbeatMask = "MOD/imgs/heartbeatGradient.png"		

function draw2(dt)
	UiTranslate(400,400)
	UiDrawOxygenOscillograph(dt,200,20,5,30,300)
	UiTranslate(0,30)
	UiDrawHeartbeatOscillograph(dt,200,20,5,30,100)
	UiTranslate(0,30)
	UiDrawHeartbeatFlatline(dt,200,20,30)
	UiTranslate(0,30)
	UiDrawOxygenFlatline(dt,200,20,30)
end

function UiDrawOxygenOscillograph(dt,width,height,speed,oscillographSpeed,scannerWidth)
	oscillographicShift = (oscillographicShift + dt*oscillographSpeed) % (width+30)
	UiPush()		
		UiWindow(width,height,true)
		UiPush()
			UiScale(speed,1)
			UiImageBox("MOD/imgs/oxygen.PNG",width,height+1,0,0)
		UiPop()
		UiPush()
			UiTranslate(oscillographicShift,0)
			UiImageBox(heartbeatMask,scannerWidth,height+1,0,0)
		UiPop()
		UiPush()
			UiTranslate(oscillographicShift-(width+30),0)
			UiImageBox(heartbeatMask,scannerWidth,height+1,0,0)
		UiPop()
	UiPop()
end

function UiDrawHeartbeatOscillograph(dt,width,height,speed,oscillographSpeed,scannerWidth)
	oscillographicShift = (oscillographicShift + dt*oscillographSpeed) % (width+30)
	UiPush()		
		UiWindow(width,125,true)
		UiPush()
			UiScale(speed,1)
			UiImageBox("MOD/imgs/heartbeat.PNG",width,height+1,0,0)
		UiPop()
		UiPush()
			UiTranslate(oscillographicShift,0)
			UiImageBox(heartbeatMask,scannerWidth,height+1,0,0)
		UiPop()
		UiPush()
			UiTranslate(oscillographicShift-(width+30),0)
			UiImageBox(heartbeatMask,scannerWidth,height+1,0,0)
		UiPop()
	UiPop()
end

function UiDrawHeartbeatFlatline(dt,width, height,oscillographSpeed)
	drawFlatline(dt,width,height,1,0,0,oscillographSpeed)
end

function UiDrawOxygenFlatline(dt,width,height,oscillographSpeed)
	drawFlatline(dt,width,height,0,0,1,oscillographSpeed)
end

function drawFlatline(dt,width,height,r,g,b,oscillographSpeed,background)		
	oscillographicShift = (oscillographicShift + dt*oscillographSpeed) % (width+30)
	UiPush()		
		UiWindow(width,height,true)
		drawRect(0,0,885,height+1,0,0,0,1)			
		UiPush()		
			drawRect(0,height/2,885,4,r,g,b,1)			
		UiPop()
		UiPush()
			UiTranslate(oscillographicShift,0)
			UiImageBox(heartbeatMask,335,height+1,0,0)
		UiPop()
		UiPush()
			UiTranslate(oscillographicShift-(width+30),0)
			UiImageBox(heartbeatMask,335,height+1,0,0)
		UiPop()
	UiPop()
end

--- HELPER FUNCTIONS ---

function drawRect(x,y,w,h,r,g,b,a)
	UiPush()
		UiColor(r,g,b,a)
		UiTranslate(x,y)
		UiRect(w,h)
	UiPop()
end