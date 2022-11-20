#include "Oscillograph.lua"
#include "UIBodyState.lua"

HEALTH_UI_BACKGROUND_WIDTH = 300
HEALTH_UI_BACKGROUND_HEIGHT= 110
HEALTH_UI_DETAIL_BACKGROUND_WIDTH = 150
HEALTH_UI_DETAIL_BACKGROUND_HEIGHT= 230
HEALTH_UI_INFO_BACKGROUND_HEIGHT= 24

showHealthMenu = false
showHealthDetails = false

bodyState = HEALTHY_BODY_STATE


function indexOf(tabl, el)	
	for k,v in pairs(tab) do
		if v.text == el then
			return k
		end
	end
	return 0
end

function deleteElement(tab, el) 
	local i = indexOf(tab, el)
	if i > 0 then
		table.remove(tab, i)
	end
end

-- SetHealthy() - Sets the whole status of the body to healty, which causes the healthy text to appear on the ui and the oscillograph look normal
-- SetInjured() - Sets the whole status of the body to injured, which causes the injured text to appear on the ui and the oscillograph will be running faster 
-- SetDead() - Sets the whole status of the body to dead, which causes the dead text to appear on the ui and the oscillograph will flatline
-- None of the above methods will change colors on body parts!
-- AddHealthEffect(effectText, color) - This will add a general effect with the given text and color to the detail view (pressing X). Possible colors are RED, YELLOW, GREEN.
-- RemoveHealthEffect(effectText) - This will remove the given general effect by its text if the effect was added earlier
--
-- SetHeadHealth(color) - This sets the color of the head to the given color. Possible colors are RED, YELLOW, GREEN
-- AddHeadHealthEffect(effectText, color) - his will add an effect to the head with the given text and color to the detail view (pressing X). Possible colors are RED, YELLOW, GREEN.
-- RemoveHeadHealthEffect(effectText) - This will remove the given effect from the head by its text if the effect was added earlier
--
-- SetTorsoHealth(color) - This sets the color of the torso to the given color. Possible colors are RED, YELLOW, GREEN
-- AddTorsoHealthEffect(effectText, color) - his will add an effect to the torso with the given text and color to the detail view (pressing X). Possible colors are RED, YELLOW, GREEN.
-- RemoveTorsoHealthEffect(effectText) - This will remove the given effect from the torso by its text if the effect was added earlier
--
-- SetLeftArmHealth(color) - This sets the color of the left arm to the given color. Possible colors are RED, YELLOW, GREEN
-- AddLeftArmHealthEffect(effectText, color) - his will add an effect to the left arm with the given text and color to the detail view (pressing X). Possible colors are RED, YELLOW, GREEN.
-- RemoveLeftArmHealthEffect(effectText) - This will remove the given effect from the left arm by its text if the effect was added earlier
--
-- SetRightArmHealth(color) - This sets the color of the right arm to the given color. Possible colors are RED, YELLOW, GREEN
-- AddRightArmHealthEffect(effectText, color) - his will add an effect to the right arm with the given text and color to the detail view (pressing X). Possible colors are RED, YELLOW, GREEN.
-- RemoveRightArmHealthEffect(effectText) - This will remove the given effect from the right arm by its text if the effect was added earlier
--
-- SetLeftLegHealth(color) - This sets the color of the left leg to the given color. Possible colors are RED, YELLOW, GREEN
-- AddLeftLegHealthEffect(effectText, color) - his will add an effect to the left leg with the given text and color to the detail view (pressing X). Possible colors are RED, YELLOW, GREEN.
-- RemoveLeftLegHealthEffect(effectText) - This will remove the given effect from the left leg by its text if the effect was added earlier
--
-- SetRightLegHealth(color) - This sets the color of the right leg to the given color. Possible colors are RED, YELLOW, GREEN
-- AddRightLegHealthEffect(effectText, color) - his will add an effect to the right leg with the given text and color to the detail view (pressing X). Possible colors are RED, YELLOW, GREEN.
-- RemovRightLegHealthEffect(effectText) - This will remove the given effect from the right leg by its text if the effect was added earlier

function SetHealthy()
	bodyState.overall = HEALTHY
end
function SetInjured()
	bodyState.overall = INJURED
end
function SetDead()
	bodyState.overall = DEAD
end
function AddHealthEffect(effect, color)
	table.insert(bodyState.effects, Effect(effect, color))
end
function RemoveHealthEffect(effect)
	deleteElement(bodyState.effects, effect)
end
function SetHeadHealth(color)
	bodyState.head.color = color	
end
function AddHeadHealthEffect(effect, color)
	table.insert(bodyState.head.effects, Effect(effect, color))
end
function RemoveHeadHealthEffect(effect)
	deleteElement(bodyState.head.effects, effect)
end
function SetTorsoHealth(color)
	bodyState.body.color = color	
end
function AddTorsoHealthEffect(effect, color)
	table.insert(bodyState.body.effects, Effect(effect, color))
end
function RemoveTorsoHealthEffect(effect)
	deleteElement(bodyState.body.effects, effect)
end
function SetLeftArmHealth(color)
	bodyState.leftArm.color = color	
end
function AddLeftArmHealthEffect(effect, color)
	table.insert(bodyState.leftArm.effects, Effect(effect, color))
end
function RemoveLeftArmHealthEffect(effect)
	deleteElement(bodyState.leftArm.effects, effect)
end
function SetRightArmHealth(color)
	bodyState.rightArm.color = color	
end
function AddRightArmHealthEffect(effect, color)
	table.insert(bodyState.rightArm.effects, Effect(effect, color))
end
function RemoveRightArmHealthEffect(effect)
	deleteElement(bodyState.rightArm.effects, effect)
end
function SetRightLegHealth(color)
	bodyState.rightLeg.color = color	
end
function AddRightLegHealthEffect(effect, color)
	table.insert(bodyState.rightLeg.effects, Effect(effect, color))
end
function RemoveRightLegHealthEffect(effect)
	deleteElement(bodyState.rightLeg.effects, effect)
end
function SetLeftLegHealth(color)
	bodyState.leftLeg.color = color	
end
function AddLeftLegHealthEffect(effect, color)
	table.insert(bodyState.leftLeg.effects, Effect(effect, color))
end
function RemoveLeftLegHealthEffect(effect)
	deleteElement(bodyState.leftLeg.effects, effect)
end

function WriteDetailStatus(name, effects,y)
	if #effects > 0 then
		for i,effect in ipairs(effects) do				
			writeText(name .. effect.text,18,10,y, false,effect.color)
			y=y+20
		end
	else
		writeText(name .. "healthy",18,10,y, false, GREEN)
		y=y+20
	end
	return y
end

function DrawUiHealthOverlay(dt)
	if not showHealthMenu then return end
	if bodyState == nil then return end		

	UiTranslate(400,400)	
	
	local healthText = "All Good"
	if bodyState.overall == INJURED then healthText = "Injured" end
	if bodyState.overall == DEAD then healthText = "Dead" end
	
	UiPush()
		drawBackground()
		writeText(healthText,30,110,34,true)
		UiPush()
			UiTranslate(110,40)
			if bodyState.overall == DEAD then
				UiDrawHeartbeatFlatline(dt,HEALTH_UI_BACKGROUND_WIDTH-110-20, 20,30)
				UiTranslate(0,30)
				UiDrawOxygenFlatline(dt,HEALTH_UI_BACKGROUND_WIDTH-110-20, 20,30)
			elseif bodyState.overall == INJURED then
				UiDrawHeartbeatOscillograph(dt,HEALTH_UI_BACKGROUND_WIDTH-110-20,20,10,30,200)
				UiTranslate(0,30)
				UiDrawOxygenOscillograph(dt,HEALTH_UI_BACKGROUND_WIDTH-110-20,20,10,30,200)
			else 
				UiDrawHeartbeatOscillograph(dt,HEALTH_UI_BACKGROUND_WIDTH-110-20,20,5,30,200)
				UiTranslate(0,30)
				UiDrawOxygenOscillograph(dt,HEALTH_UI_BACKGROUND_WIDTH-110-20,20,5,30,200)
			end			
		UiPop()
		writeText("Blood",18,110,60)
		drawRect(110,67,HEALTH_UI_BACKGROUND_WIDTH-110-20,1,1,1,1,1)
		writeText("Oxygen",18,110,85)
		UiTranslate(0,HEALTH_UI_BACKGROUND_HEIGHT+3)
		drawInfoBackground()
		writeText("Press X for more info",18,110,18)			
	UiPop()
	if showHealthDetails then
		UiPush()
			UiTranslate(HEALTH_UI_BACKGROUND_WIDTH+5,-(HEALTH_UI_DETAIL_BACKGROUND_HEIGHT-HEALTH_UI_BACKGROUND_HEIGHT-HEALTH_UI_INFO_BACKGROUND_HEIGHT-3))
			drawDetailBackground()
					
			local y = 20
			y = WriteDetailStatus("Head ", bodyState.head.effects, y)
			y = WriteDetailStatus("Body ", bodyState.body.effects, y)
			y = WriteDetailStatus("Left arm ", bodyState.leftArm.effects, y)
			y = WriteDetailStatus("Right arm ", bodyState.rightArm.effects, y)
			y = WriteDetailStatus("Left leg ", bodyState.leftLeg.effects, y)
			y = WriteDetailStatus("Right leg ", bodyState.rightLeg.effects, y)
			
			for i,effect in ipairs(bodyState.effects) do
				writeText(effect.text,18,10,y, false,effect.color)
				y=y+20
			end
			
			local startHeight = 160
			for i, effect in ipairs(bodyState.effects) do
				writeText(effect.text,18,10,startHeight,false,effect.color)
				startHeight = startHeight + 20
			end
		UiPop()
	end
	UiTranslate(14,-10)
	UiDrawBodyState(bodyState)
end

function drawBackground()
	drawRect(0,0,HEALTH_UI_BACKGROUND_WIDTH,HEALTH_UI_BACKGROUND_HEIGHT,0,0,0,1)
end

function drawInfoBackground()
	drawRect(0,0,HEALTH_UI_BACKGROUND_WIDTH,HEALTH_UI_INFO_BACKGROUND_HEIGHT,0,0,0,1)
end

function drawDetailBackground()
	drawRect(0,0,HEALTH_UI_DETAIL_BACKGROUND_WIDTH,HEALTH_UI_DETAIL_BACKGROUND_HEIGHT,0,0,0,1)
end

function writeText(text, size, x,y ,bold, color)
	UiPush()
		if color ~= nil then
			UiColor(color.r,color.g,color.b)
		end
		UiTranslate(x,y)
		if bold then
			UiFont("bold.ttf", size)
		else
			UiFont("regular.ttf", size)
		end
		UiText(text)
	UiPop()
end

function ToggleUiHealthOverlay()	
	showHealthMenu = not showHealthMenu
	showHealthDetails = showHealthMenu and showHealthDetails
end

function ToggleUiHealthDetailsOverlay()
	if showHealthMenu then
		showHealthDetails = not showHealthDetails
	end
end

function ShowUiHealthOverlay()
	showHealthMenu = true	
end

function HideUiHealthOverlay()
	showHealthMenu = false
	showHealthDetails = false
end