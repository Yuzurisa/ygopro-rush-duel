local m=120196013
local cm=_G["c"..m]
cm.name="虚钢演机乱流"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
--Activate
function cm.confilter1(c)
	return c:IsType(TYPE_NORMAL) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsDefense(500)
end
function cm.confilter2(c,tp)
	return c:GetSummonPlayer()==tp
end
function cm.posfilter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:IsLevelAbove(8) and c:IsAttribute(ATTRIBUTE_LIGHT)
		and c:IsCanChangePosition() and RushDuel.IsHasDefense(c)
end
function cm.exfilter(c)
	return c:IsType(TYPE_NORMAL)
end
function cm.desfilter(c,race)
	return c:IsFaceup() and c:IsRace(race)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.confilter1,tp,LOCATION_GRAVE,0,1,nil)
		and eg:IsExists(cm.confilter2,1,nil,1-tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.posfilter,tp,LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(cm.posfilter,tp,LOCATION_MZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,cm.posfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.ChangePosition(g,POS_FACEUP_DEFENSE)~=0 then
			local race=0
			local sg=Duel.GetMatchingGroup(cm.exfilter,tp,LOCATION_GRAVE,0,nil)
			local tc=sg:GetFirst()
			while tc do
				race=bit.bor(race, tc:GetRace())
				tc=sg:GetNext()
			end
			if race~=0
				and Duel.IsExistingMatchingCard(cm.desfilter,tp,0,LOCATION_MZONE,1,nil,race)
				and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local dg=Duel.SelectMatchingCard(tp,cm.desfilter,tp,0,LOCATION_MZONE,1,1,nil,race)
				if dg:GetCount()>0 then
					Duel.BreakEffect()
					Duel.HintSelection(dg)
					Duel.Destroy(dg,REASON_EFFECT)
				end
			end
		end
	end
end