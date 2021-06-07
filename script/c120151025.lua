local m=120151025
local cm=_G["c"..m]
cm.name="宿灵椅·消酸痛式"
function cm.initial_effect(c)
	--Discard Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
--Discard Deck
function cm.costfilter(c)
	return c:IsAttack(0) and c:IsAbleToGraveAsCost()
end
function cm.exfilter(c)
	return c:IsLevelBelow(8) and c:IsAttribute(ATTRIBUTE_DARK)
end
function cm.thfilter(c)
	return c:IsLevelBelow(8) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsAbleToHand()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardDeck(tp,2,REASON_EFFECT)==0 then return end
	local g=Duel.GetOperatedGroup()
	if not g:IsExists(cm.exfilter,1,nil) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if sg:GetCount()>0 and Duel.SendtoHand(sg,nil,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-tp,sg)
		Duel.Recover(1-tp,sg:GetFirst():GetAttack(),REASON_EFFECT)
	end
end