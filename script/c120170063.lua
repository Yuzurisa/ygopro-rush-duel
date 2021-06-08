local m=120170063
local list={120145000}
local cm=_G["c"..m]
cm.name="魔雷冥"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1])
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_TODECK+CATEGORY_GRAVE_ACTION)
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
	return c:IsFaceup() and (RushDuel.IsLegendCode(c,list[1])
		or (c:IsType(TYPE_NORMAL) and c:IsLevelAbove(7) and c:IsRace(RACE_FIEND)))
end
function cm.confilter2(c,tp)
	return c:GetSummonPlayer()==tp and c:IsFaceup() and c:IsLevelAbove(6)
end
function cm.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.confilter1,tp,LOCATION_MZONE,0,1,nil)
		and eg:IsExists(cm.confilter2,1,nil,1-tp)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.filter,tp,0,LOCATION_GRAVE,1,nil) end
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_GRAVE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,g:GetCount()*100)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,0,LOCATION_GRAVE,nil)
	local ct=g:GetCount()
	if ct>0 and Duel.Damage(tp,ct*100,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end