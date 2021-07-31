local m=120192027
local cm=_G["c"..m]
cm.name="透幻乡的万绿"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	c:RegisterEffect(e1)
	--Atk & Def Down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.adtg)
	e2:SetValue(-300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
end
--Activate
function cm.confilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.confilter,tp,LOCATION_MZONE,0,nil)
	return g:GetSum(Card.GetLevel)>=10
end
--Atk & Def Down
function cm.adtg(e,c)
	return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_EARTH)
end