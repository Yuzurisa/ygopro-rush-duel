local m=120145054
local list={120145032,120145002}
local cm=_G["c"..m]
cm.name="报道魂"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1],list[2])
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
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
	return c:GetPreviousPosition()==POS_FACEUP_ATTACK and c:GetPreviousControler()==tp
		and c==Duel.GetAttackTarget()
end
function cm.confilter2(c,tp)
	return c:GetPreviousPosition()==POS_FACEUP_ATTACK and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_MZONE)
end
function cm.spfilter(c,e,tp)
	return c:IsCode(list[1],list[2]) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.condition1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.confilter1,1,nil,tp)
end
function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and eg:IsExists(cm.confilter2,1,nil,tp)
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
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end