local m=120183025
local cm=_G["c"..m]
cm.name="七轮之侍 腹身串狼"
function cm.initial_effect(c)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
--Destroy
function cm.confilter(c)
	return c:IsAttribute(ATTRIBUTE_FIRE)
end
function cm.desfilter(c)
	return c:IsFaceup() and c:IsLevelBelow(8) and c:IsAttackAbove(2500)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ((c:IsReason(REASON_SUMMON) and c:IsStatus(STATUS_SUMMON_TURN))
		or (c:IsReason(REASON_SPSUMMON) and c:IsStatus(STATUS_SPSUMMON_TURN)))
		and Duel.IsExistingMatchingCard(cm.confilter,tp,LOCATION_GRAVE,0,7,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end