local m=120183050
local cm=_G["c"..m]
cm.name="狂野厨房"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	c:RegisterEffect(e1)
	--Atk Up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.atktg)
	e2:SetValue(300)
	c:RegisterEffect(e2)
end
--Activate
function cm.confilter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(cm.confilter,tp,LOCATION_MZONE,0,nil)==3
end
--Atk Up
function cm.atktg(e,c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE)
end