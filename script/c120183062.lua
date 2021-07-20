local m=120183062
local cm=_G["c"..m]
cm.name="攻击减俸"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Activate
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local c=Duel.GetAttackTarget()
	return tc:IsControler(1-tp) and tc:IsLevelBelow(8) and c and c:IsControler(tp) and c:IsFaceup()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,600) end
	Duel.PayLPCost(tp,600)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local c=Duel.GetAttackTarget()
	if tc and tc:IsRelateToBattle() and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-400)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e2)
		if c and c:IsRelateToBattle() and c:IsFaceup() then
			local e3=e2:Clone()
			c:RegisterEffect(e3)
		end
	end
end