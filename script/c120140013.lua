local m=120140013
local cm=_G["c"..m]
cm.name="一同礼状"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Activate
function cm.confilter1(c)
	return c:IsFaceup() and c:IsLevelAbove(5)
end
function cm.confilter2(c,tp)
	return c:GetSummonPlayer()==tp
end
function cm.posfilter(c)
	return c:IsAttackPos() and c:IsCanChangePosition() and RushDuel.IsHasDefense(c)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.confilter1,tp,LOCATION_MZONE,0,2,nil)
		and eg:IsExists(cm.confilter2,1,nil,1-tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		local sg=Duel.GetMatchingGroup(cm.posfilter,tp,LOCATION_MZONE,0,nil)
		if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.ChangePosition(sg,POS_FACEUP_DEFENSE)
		end
	end
end