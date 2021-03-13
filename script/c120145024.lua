local m=120145024
local list={120145022,120145023}
local cm=_G["c"..m]
cm.name="古代同盟龙"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1],list[2])
	--Atk Up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TODECK+CATEGORY_DESTROY+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
--Atk Up
function cm.tdfilter1(c,code)
	return c:IsCode(code) and c:IsAbleToDeck()
end
function cm.tdfilter2(c)
	return c:IsCode(list[1],list[2]) and c:IsAbleToDeck()
end
function cm.desfilter(c)
	return c:IsFaceup() and c:IsDefenseBelow(1500) and RushDuel.IsHasDefense(c)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	Duel.DiscardDeck(tp,1,REASON_COST)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(600)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.tdfilter1),tp,LOCATION_GRAVE,0,1,nil,list[1])
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.tdfilter1),tp,LOCATION_GRAVE,0,1,nil,list[2])
			and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			local mg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.tdfilter2),tp,LOCATION_GRAVE,0,nil)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=mg:SelectSubGroup(tp,aux.dncheck,true,2,2)
			Duel.ConfirmCards(1-tp,sg)
			if Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)~=0
				and Duel.IsExistingMatchingCard(cm.desfilter,tp,0,LOCATION_MZONE,1,nil)
				and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local g=Duel.SelectMatchingCard(tp,cm.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
				Duel.HintSelection(g)
				Duel.Destroy(g,REASON_EFFECT)
			end
		end
	end
end