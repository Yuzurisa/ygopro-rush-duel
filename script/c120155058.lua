local m=120155058
local list={120155036,120155037}
local cm=_G["c"..m]
cm.name="地压的爆发"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1],list[2])
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(cm.condition1)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_DESTROYED)
	e2:SetCondition(cm.condition2)
	c:RegisterEffect(e2)
end
--Activate
function cm.confilter1(c,tp)
	return c:GetPreviousControler()==tp and c==Duel.GetAttackTarget()
		and c:IsPreviousPosition(POS_ATTACK) and bit.band(c:GetPreviousRaceOnField(),RACE_PYRO)~=0
end
function cm.confilter2(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousPosition(POS_ATTACK) and bit.band(c:GetPreviousRaceOnField(),RACE_PYRO)~=0
end
function cm.spfilter(c,e,tp)
	return c:IsCode(list[1],list[2]) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.exfilter(c)
	return c:IsAttribute(ATTRIBUTE_EARTH) and c:IsRace(RACE_PYRO)
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.confilter1,1,nil,tp)
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_TRAP) and eg:IsExists(cm.confilter2,1,nil,tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.IsExistingMatchingCard(cm.exfilter,tp,LOCATION_GRAVE,0,1,nil) then
		Duel.Recover(tp,1000,REASON_EFFECT)
	end
end