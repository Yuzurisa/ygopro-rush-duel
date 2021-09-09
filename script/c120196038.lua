local m=120196038
local list={120183024,120196039,120183062,120183063}
local cm=_G["c"..m]
cm.name="漆黑社员王 巨恶德话术大王"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1],list[2],list[3],list[4])
	--Fusion Material
	aux.AddFusionProcCode2(c,list[1],list[2],true,true)
	--Atk Up
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
--Atk Up
function cm.filter(c)
	return c:IsRace(RACE_MACHINE)
end
function cm.tdfilter(c)
	return c:IsCode(list[3],list[4]) and c:IsAbleToDeck()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,600) end
	Duel.PayLPCost(tp,600)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local atk=Duel.GetMatchingGroupCount(cm.filter,tp,LOCATION_GRAVE,0,nil)*200
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.tdfilter),tp,LOCATION_GRAVE,0,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tdfilter),tp,LOCATION_GRAVE,0,1,1,nil)
			Duel.ConfirmCards(1-tp,g)
			if Duel.SendtoDeck(g,nil,1,REASON_EFFECT)~=0
				and Duel.IsPlayerCanDraw(tp,1)
				and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
				Duel.Draw(tp,1,REASON_EFFECT)
			end
		end
	end
end