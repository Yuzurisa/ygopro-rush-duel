local m=120145053
local cm=_G["c"..m]
cm.name="森"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk & Def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.uptg)
	e2:SetValue(200)
	c:RegisterEffect(e2)
end
--Atk & Def
function cm.uptg(e,c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT+RACE_BEAST+RACE_PLANT+RACE_BEASTWARRIOR)
end