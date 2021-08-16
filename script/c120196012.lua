local m=120196012
local cm=_G["c"..m]
cm.name="虚钢演机塔"
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
	--Indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(cm.target)
	e3:SetValue(cm.efilter)
	c:RegisterEffect(e3)
end
--Activate
function cm.confilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsDefense(500)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.confilter,tp,LOCATION_GRAVE,0,1,nil)
end
--Atk & Def Down
function cm.adtg(e,c)
	return c:IsFaceup() and not c:IsAttribute(ATTRIBUTE_LIGHT)
end
--Indes
function cm.target(e,c)
	return c:IsFaceup() and c:IsLevel(9) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function cm.efilter(e,re,rp)
	return re:IsActiveType(TYPE_TRAP)
end