local m=120140014
local cm=_G["c"..m]
cm.name="仙人的神髓"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Activate
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsAttack(0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	return Duel.GetAttacker():IsControler(1-tp) and c and c:IsFaceup() and c:IsAttack(0)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetAttacker()
	if chk==0 then return tc:IsAttackPos() and tc:IsCanChangePosition() and RushDuel.IsHasDefense(tc) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,tc,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToBattle() and tc:IsAttackPos()
		and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)~=0
		and Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end