local m=120183023
local list={120183046,120183047}
local cm=_G["c"..m]
cm.name="SP职员守卫"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1],list[2])
	--Set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
--Set
function cm.setfilter(c)
	return c:IsCode(list[1],list[2]) and c:IsSSetable()
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return (c:IsReason(REASON_SUMMON) and c:IsStatus(STATUS_SUMMON_TURN))
		or (c:IsReason(REASON_SPSUMMON) and c:IsStatus(STATUS_SPSUMMON_TURN))
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,600) end
	Duel.PayLPCost(tp,600)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cm.setfilter,tp,LOCATION_GRAVE,0,1,nil) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.setfilter),tp,LOCATION_GRAVE,0,nil)
	local ct=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if g:GetCount()>0 and ct>0 then
		if ct>2 then ct=2 end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
		if sg:GetCount()>0 then
			Duel.SSet(tp,sg)
		end
	end
	if Duel.GetFlagEffect(tp,m)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(cm.atktg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--Hint
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
function cm.atktg(e,c)
	return not c:IsRace(RACE_MACHINE)
end