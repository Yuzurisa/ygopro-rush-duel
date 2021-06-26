local m=120183026
local cm=_G["c"..m]
cm.name="七轮之侍 腹身串狼"
function cm.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
--Special Summon
function cm.spfilter(c,e,tp)
	return c:IsType(TYPE_NORMAL) and c:IsLevelAbove(6) and c:IsRace(RACE_BEAST)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.exfilter(c)
	return c:IsType(TYPE_NORMAL) and c:IsRace(RACE_BEAST)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0
		and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0
		and Duel.IsExistingMatchingCard(cm.exfilter,tp,LOCATION_GRAVE,0,3,nil)
		and Duel.IsPlayerCanDraw(tp,1)
		and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end