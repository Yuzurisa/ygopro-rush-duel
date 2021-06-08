local m=120150029
local cm=_G["c"..m]
cm.name="迷途猫"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Activate
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp)
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
			if Duel.NegateAttack() then
				Duel.Damage(1-tp,300,REASON_EFFECT)
			end
		end
	end
end