local m=120192010
local cm=_G["c"..m]
cm.name="幻刃斗士 搅拌龙"
function cm.initial_effect(c)
	--Discard Deck
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DECKDES+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
--Discard Deck
function cm.exfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_WYRM) and c:IsLocation(LOCATION_GRAVE)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_SUMMON) and c:IsStatus(STATUS_SUMMON_TURN)
		and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardDeck(tp,1,REASON_EFFECT)==0 then return end
	local g=Duel.GetOperatedGroup()
	if g:IsExists(cm.exfilter,1,nil)
		and Duel.IsPlayerCanDraw(tp,1)
		and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end