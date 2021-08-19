local m=120196022
local list={120110001,120196026}
local cm=_G["c"..m]
cm.name="超击龙 星齿车戒龙F"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1],list[2])
	--Fusion Material
	aux.AddFusionProcCode2(c,list[1],list[2],true,true)
	--Select Effect
	local e1=RushDuel.BaseSelectEffect(c,aux.Stringid(m,1),cm.eff1con,cm.eff1op,aux.Stringid(m,2),cm.eff2con,cm.eff2op)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	c:RegisterEffect(e1)
end
--Select Effect
function cm.confilter1(c)
	return c:IsRace(RACE_DRAGON) or c:IsRace(0x8000000)
end
function cm.confilter2(c)
	return c:IsType(TYPE_MONSTER) and not cm.confilter1(c)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.confilter1,tp,LOCATION_GRAVE,0,1,nil)
		and not Duel.IsExistingMatchingCard(cm.confilter2,tp,LOCATION_GRAVE,0,1,nil)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
	Duel.DiscardDeck(tp,1,REASON_COST)
end
--Atk Up
function cm.eff1con(e,tp,eg,ep,ev,re,r,rp)
	return true
end
function cm.eff1op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(900)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		--Extra Attack
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(m,3))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end
--Pierce
function cm.eff2con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function cm.eff2op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		--Extra Attack
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,4))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		--Pierce
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(m,5))
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_PIERCE)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
	end
end