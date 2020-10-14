local m=120150041
local cm=_G["c"..m]
cm.name="被压垮的椅子"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Activate
function cm.confilter(c,tp)
	return c:GetPreviousControler()==tp and c==Duel.GetAttackTarget()
		and c:IsPreviousPosition(POS_FACEUP_ATTACK)
		and bit.band(c:GetPreviousAttributeOnField(),ATTRIBUTE_DARK)~=0
		and c:GetPreviousAttackOnField()==0
end
function cm.desfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsLevelBelow(8)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.confilter,1,nil,tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,PLAYER_ALL,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local ct=Duel.Destroy(g,REASON_EFFECT)
		local dg1=Duel.GetDecktopGroup(tp,ct)
		local dg2=Duel.GetDecktopGroup(1-tp,ct)
		dg1:Merge(dg2)
		if dg1:GetCount()>0 then
			Duel.BreakEffect()
			Duel.DisableShuffleCheck()
			Duel.SendtoGrave(dg1,REASON_EFFECT)
		end
	end
end