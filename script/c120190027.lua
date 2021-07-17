local m=120190027
local cm=_G["c"..m]
cm.name="鞠躬石膏绷带"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DRAW)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Activate
function cm.posfilter(c)
	return c:IsAttackPos() and c:IsCanChangePosition() and RushDuel.IsHasDefense(c)
end
function cm.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and r==REASON_RULE
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.posfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(cm.posfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,cm.posfilter,tp,LOCATION_MZONE,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.ChangePosition(g,POS_FACEUP_DEFENSE)~=0
			and Duel.GetMatchingGroupCount(Card.IsDefensePos,tp,LOCATION_MZONE,0,nil)==3
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.tdfilter),tp,0,LOCATION_GRAVE,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tdfilter),tp,0,LOCATION_GRAVE,1,5,nil)
			if sg:GetCount()>0 then
				Duel.BreakEffect()
				Duel.ConfirmCards(1-tp,sg)
				Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
			end
		end
	end
end