local m=120170040
local list={120170002}
local cm=_G["c"..m]
cm.name="果酱跳：P开始！"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1])
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Activate
function cm.costfilter(c)
	return c:IsRace(RACE_PSYCHO) and c:IsAbleToDeckAsCost()
end
function cm.thfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_PSYCHO) and c:IsAbleToHand()
end
function cm.costcheck(g,tp)
	return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,g)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.costfilter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:CheckSubGroup(cm.costcheck,2,2,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local sg=g:SelectSubGroup(tp,cm.costcheck,false,2,2,tp)
	Duel.ConfirmCards(1-tp,sg)
	Duel.SendtoDeck(sg,nil,0,REASON_COST)
	Duel.SortDecktop(tp,tp,2)
	for i=1,2 do
		local tg=Duel.GetDecktopGroup(tp,1)
		Duel.MoveSequence(tg:GetFirst(),1)
	end
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if g:GetFirst():IsCode(list[1]) then
			Duel.Recover(tp,1000,REASON_EFFECT)
		end
	end
end