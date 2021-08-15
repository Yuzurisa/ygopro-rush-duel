local m=120195001
local list={120195006,120195009}
local cm=_G["c"..m]
cm.name="钢铁勋章·阿修罗明星"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1],list[2])
	--Fusion Material
	aux.AddFusionProcCode2(c,list[1],list[2],true,true)
	--Select Effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
--Select Effect
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	Duel.DiscardDeck(tp,1,REASON_COST)
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
--Destroy
function cm.eff1con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,nil)
end
function cm.eff1op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
--Atk Up
function cm.filter(c)
	return c:IsFaceup() and c:IsRace(0x2000000)
end
function cm.atkfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end
function cm.eff2con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.atkfilter,tp,0,LOCATION_MZONE,1,nil)
end
function cm.eff2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,3))
	local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local ag=Duel.GetMatchingGroup(cm.atkfilter,tp,0,LOCATION_MZONE,nil)
		local atk=ag:GetSum(Card.GetAttack)
		local tc=g:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end