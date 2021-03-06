local m=120183051
local cm=_G["c"..m]
cm.name="兽战场的障壁"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk Up / Down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.downtg)
	e2:SetValue(-200)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetTarget(cm.uptg)
	e3:SetValue(400)
	c:RegisterEffect(e3)
end
--Atk Up / Down
function cm.downtg(e,c)
	return c:IsFaceup()
end
function cm.uptg(e,c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsRace(RACE_BEAST)
end