local m=120160005
local cm=_G["c"..m]
cm.name="尖流射击"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Activate
function cm.filter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsLevelAbove(1)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_GRAVE,0,1,nil) end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.filter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local lv=g:GetFirst():GetLevel()
		Duel.Recover(tp,lv*100,REASON_EFFECT,true)
		Duel.Damage(1-tp,lv*100,REASON_EFFECT,true)
		Duel.RDComplete()
	end
end