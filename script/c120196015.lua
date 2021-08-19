local m=120196015
local list={120105001,120196021}
local cm=_G["c"..m]
cm.name="魔导骑士-七魔导骑士"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1],list[2])
	--Fusion Material
	aux.AddFusionProcCode2(c,list[1],list[2],true,true)
	--Select Effect
	local e1=RushDuel.BaseSelectEffect(c,aux.Stringid(m,1),cm.eff1con,cm.eff1op,aux.Stringid(m,2),cm.eff2con,cm.eff2op)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetCost(cm.cost)
	c:RegisterEffect(e1)
end
--Select Effect
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	Duel.DiscardDeck(tp,1,REASON_COST)
end
--Atk Up
function cm.atkfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function cm.eff1con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.atkfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
end
function cm.eff1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(cm.atkfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		local atk=g:GetClassCount(Card.GetAttribute)*400
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
--To Deck
function cm.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.eff2con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.tdfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function cm.eff2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tdfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0
			and Duel.IsPlayerCanDraw(tp,1)
			and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
			Duel.BreakEffect()
			Duel.ShuffleDeck(tp)
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end