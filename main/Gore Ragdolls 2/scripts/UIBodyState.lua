RED = {r=1,g=0,b=0,a=1}
GREEN = {r=0,g=1,b=0,a=1}
YELLOW = {r=1,g=1,b=0,a=1}

HEAD_SIZE = 30
BODY_WIDTH = 38
BODY_HEIGHT= 60
ARM_WIDTH = 18

COLORS = {red=RED,green=GREEN,yellow=YELLOW}

HEALTHY = "healthy"
INJURED = "injured"
DEAD = "dead"

function Effect(title, color)
	return {text=title, color=color}
end

function BodyState(overall, head, body, leftArm, rightArm, leftLeg, rightLeg, effects)
	if effects == nil then effects = {} end
	return {overall=overall, head=head, body=body, leftArm=leftArm, rightArm=rightArm, leftLeg=leftLeg,rightLeg=rightLeg, effects=effects}
end

function BodyPart(color, effects)
	if effects == nil then effects = {} end
	return {color=color, effects=effects}
end

BROKEN_BODY_PART = BodyPart(RED, {Effect("broken", RED)}) 
BROKEN_NECK = BodyPart(RED, {Effect("broken neck", RED)}) 

HEALTHY_BODY_STATE = BodyState(
		HEALTHY,
		BodyPart(GREEN, {}),
		BodyPart(GREEN, {}),	
		BodyPart(GREEN, {}),
		BodyPart(GREEN, {}),
		BodyPart(GREEN, {}),
		BodyPart(GREEN, {}),
		{}
	)

function UiDrawBodyState(state)	
	UiTranslate(ARM_WIDTH+2+(BODY_WIDTH-HEAD_SIZE)/2,0)
	UiDrawHead(state.head.color)
	UiTranslate(-(BODY_WIDTH-HEAD_SIZE)/2,HEAD_SIZE+2)
	UiDrawBody(state.body.color)
	UiPush()
		UiTranslate(-ARM_WIDTH-2,0)
		UiDrawArm(state.leftArm.color)
	UiPop()
	UiPush()
		UiTranslate(BODY_WIDTH+3,0)
		UiDrawArm(state.rightArm.color)
	UiPop()
	UiTranslate(0,BODY_HEIGHT+2)
	UiDrawArm(state.leftLeg.color)
	UiTranslate(BODY_WIDTH-ARM_WIDTH,0)
	UiDrawArm(state.rightLeg.color)
end

function UiDrawHead(color)
	drawRect(0,0,HEAD_SIZE,HEAD_SIZE,color.r,color.g,color.b,color.a)
end

function UiDrawBody(color)
	drawRect(0,0,BODY_WIDTH,BODY_HEIGHT,color.r,color.g,color.b,color.a)
end

function UiDrawArm(color)
	drawRect(0,0,ARM_WIDTH,BODY_HEIGHT,color.r,color.g,color.b,color.a)
end