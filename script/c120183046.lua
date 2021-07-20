local m=120183046
local list={120183024}
local cm=_G["c"..m]
cm.name="名片的命死交换"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1])
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Activate
function cm.confilter(c)
	return c:IsFaceup() and c:IsCode(list[1])
end
function cm.desfilter(c)
	return c:IsFaceup() and c:IsLevelBelow(7)
end
function cm.spfilter(c,e,tp)
	return c:IsLevelBelow(5) and c:IsRace(RACE_MACHINE)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(cm.desfilter,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,cm.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		if Duel.Destroy(g,REASON_EFFECT)~=0
			and Duel.GetMZoneCount(tp)>0
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,nil,e,tp)
			and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
			if sg:GetCount()>0 then
				Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
			end
		end
	end
end