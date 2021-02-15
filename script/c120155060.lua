local m=120155060
local cm=_G["c"..m]
cm.name="兽机界奥义 兽之拳"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Activate
function cm.desfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	return Duel.GetAttacker():IsControler(1-tp)
		and c and c:IsControler(tp) and c:IsFaceup()
		and c:IsLevel(7,8,9) and c:IsRace(RACE_BEASTWARRIOR+RACE_FIEND+RACE_MACHINE)
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
		and tc:IsRace(RACE_DRAGON+RACE_SPELLCASTER+RACE_FAIRY)
		and Duel.IsExistingMatchingCard(cm.desfilter,tp,0,LOCATION_ONFIELD,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,cm.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	end
end