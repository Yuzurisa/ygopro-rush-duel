local m=120195003
local list={120195006,120195010}
local cm=_G["c"..m]
cm.name="钢铁勋章·娱乐狂野明星"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1],list[2])
	--Fusion Material
	aux.AddFusionProcCode2(c,list[1],list[2],true,true)
	--Select Effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
--Select Effect
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeckAsCost,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.ConfirmCards(1-tp,g)
	Duel.SendtoDeck(g,nil,1,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cm.eff1con(e,tp,eg,ep,ev,re,r,rp) or cm.eff2con(e,tp,eg,ep,ev,re,r,rp) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local eff1=cm.eff1con(e,tp,eg,ep,ev,re,r,rp)
	local eff2=cm.eff2con(e,tp,eg,ep,ev,re,r,rp)
	local select=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	if eff1 and eff2 then
		select=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))+1
	elseif eff1 then
		Duel.SelectOption(tp,aux.Stringid(m,1))
		select=1
	elseif eff2 then
		Duel.SelectOption(tp,aux.Stringid(m,2))
		select=2
	end
	if select==1 then cm.eff1op(e,tp,eg,ep,ev,re,r,rp)
	elseif select==2 then cm.eff2op(e,tp,eg,ep,ev,re,r,rp)
	end
end
--To Deck(Grave)
function cm.tdfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.eff1con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.tdfilter1,tp,0,LOCATION_GRAVE,1,nil)
end
function cm.eff1op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tdfilter1),tp,0,LOCATION_GRAVE,1,3,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end
--To Deck(Monstar)
function cm.tdfilter2(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsAbleToDeck()
end
function cm.eff2con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.tdfilter2,tp,0,LOCATION_MZONE,1,nil)
end
function cm.eff2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,cm.tdfilter2,tp,0,LOCATION_MZONE,1,2,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end