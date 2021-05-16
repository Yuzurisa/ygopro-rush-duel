local m=120151031
local cm=_G["c"..m]
cm.name="幻刃奥义 - 突陷攻事"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Activate
function cm.upfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_NORMAL) and c:IsLevelAbove(7) and c:IsRace(RACE_WYRM)
end
function cm.downfilter(c)
	return c:IsFaceup() and c:IsAttackAbove(3000)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.upfilter,tp,LOCATION_MZONE,0,1,nil) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local ug=Duel.GetMatchingGroup(cm.upfilter,tp,LOCATION_MZONE,0,nil)
	if ug:GetCount()==0 then return end
	local tc=ug:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(600)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=ug:GetNext()
	end
	local dg=Duel.GetMatchingGroup(cm.downfilter,tp,0,LOCATION_MZONE,nil)
	if dg:GetCount()==0 then return end
	Duel.BreakEffect()
	tc=dg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1200)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=dg:GetNext()
	end
end