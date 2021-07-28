local m=120190026
local cm=_G["c"..m]
cm.name="王之骑士"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DRAW)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Activate
function cm.filter(c)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_FIEND) and c:IsLevelAbove(1) and c:IsAbleToHand()
end
function cm.check(g)
	return g:GetClassCount(Card.GetLevel)==g:GetCount()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and r==REASON_RULE
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return g:CheckSubGroup(cm.check,2,3) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,2,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.filter),tp,LOCATION_GRAVE,0,nil)
	if not g:CheckSubGroup(cm.check,2,3) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=g:SelectSubGroup(tp,cm.check,false,2,3)
	if sg:GetCount()>0 then
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end