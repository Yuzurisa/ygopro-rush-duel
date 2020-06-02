local m=120130042
local cm=_G["c"..m]
cm.name="神风剑"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Activate
function cm.desfilter(c,tp)
	if c:IsControler(tp) then return c:IsFaceup() and c:IsType(TYPE_NORMAL)
	else return c:IsFaceup() and c:IsLevelBelow(8) end
end
function cm.check(g,tp)
	return g:FilterCount(Card.IsControler,nil,tp)==2
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	if chk==0 then return g:CheckSubGroup(cm.check,3,3,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,3,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	if not g:CheckSubGroup(cm.check,3,3,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=g:SelectSubGroup(tp,cm.check,false,3,3,tp)
	Duel.HintSelection(sg)
	Duel.Destroy(sg,REASON_EFFECT)
end