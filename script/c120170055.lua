local m=120170055
local cm=_G["c"..m]
cm.name="美☆魔女封禁"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Activate
function cm.confilter1(c)
	return c:IsFaceup() and c:IsLevelAbove(8) and c:IsRace(RACE_AQUA)
end
function cm.confilter2(c,tp)
	return c:GetSummonPlayer()==tp
end
function cm.tdfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function cm.exfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.confilter1,tp,LOCATION_MZONE,0,1,nil)
		and eg:IsExists(cm.confilter2,1,nil,1-tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tdfilter,tp,0,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(cm.tdfilter,tp,0,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tdfilter),tp,0,LOCATION_GRAVE,1,5,nil)
	if g:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g)
		if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0
			and Duel.IsExistingMatchingCard(cm.exfilter,tp,0,LOCATION_MZONE,1,nil)
			and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.tdfilter),tp,0,LOCATION_GRAVE,1,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.tdfilter),tp,0,LOCATION_GRAVE,1,5,nil)
			if sg:GetCount()>0 then
				Duel.ConfirmCards(1-tp,sg)
				Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
			end
		end
	end
end