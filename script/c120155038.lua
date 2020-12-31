local m=120155038
local cm=_G["c"..m]
cm.name="阴阳士 坂风"
function cm.initial_effect(c)
	--To Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
--To Deck
function cm.confilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function cm.ctfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.confilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.ctfilter,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(cm.tdfilter,tp,0,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,0,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(cm.ctfilter,tp,0,LOCATION_ONFIELD,nil)
	if ct<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tdfilter),tp,0,LOCATION_GRAVE,1,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end