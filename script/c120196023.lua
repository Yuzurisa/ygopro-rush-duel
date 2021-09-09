local m=120196023
local list={120110004,120110008,120196050}
local cm=_G["c"..m]
cm.name="月轮龙 暗影蓝瑟龙F"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1],list[2])
	--Fusion Material
	aux.AddFusionProcCode2(c,list[1],list[2],true,true)
	--Select Effect
	local e1=RushDuel.BaseSelectEffect(c,aux.Stringid(m,1),cm.eff1con,cm.eff1op,aux.Stringid(m,2),cm.eff2con,cm.eff2op)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON+CATEGORY_TOHAND+CATEGORY_GRAVE_ACTION)
	e1:SetCost(cm.cost)
	c:RegisterEffect(e1)
end
--Select Effect
function cm.costfilter(c)
	return not RushDuel.IsLegendCode(c,list[3]) and c:IsAbleToGrave()
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
--Special Summon
function cm.spfilter(c,e,tp)
	return c:IsRace(RACE_HYDRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.eff1con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
end
function cm.eff1op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
--To Hand
function cm.thfilter(c)
	return RushDuel.IsLegendCode(c,list[3]) and c:IsAbleToHand()
end
function cm.eff2con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function cm.eff2op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end