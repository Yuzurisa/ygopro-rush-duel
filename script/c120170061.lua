local m=120170061
local cm=_G["c"..m]
cm.name="乐姬的独演"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(cm.condition)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Activate
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==1 and Duel.GetAttacker():IsControler(1-tp)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end