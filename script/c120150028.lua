local m=120150028
local cm=_G["c"..m]
cm.name="猫之眼"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Activate
function cm.confilter(c)
	return c:IsFaceup() and c:IsRace(RACE_BEAST)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(cm.confilter,tp,LOCATION_MZONE,0,nil)==3
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,1-tp,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanDiscardDeck(1-tp,1) then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CARDTYPE)
	local opt=Duel.AnnounceType(1-tp)
	if Duel.DiscardDeck(1-tp,1,REASON_EFFECT)==1 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		if (opt==0 and not tc:IsType(TYPE_MONSTER))
			or (opt==1 and not tc:IsType(TYPE_SPELL))
			or (opt==2 and not tc:IsType(TYPE_TRAP)) then
			local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
			local sc=g:GetFirst()
			while sc do
				local e1=Effect.CreateEffect(e:GetHandler())
				e1:SetDescription(aux.Stringid(m,1))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DIRECT_ATTACK)
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				sc:RegisterEffect(e1)
				sc=g:GetNext()
			end
		end
	end
end