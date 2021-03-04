local m=120170029
local cm=_G["c"..m]
cm.name="花牙女忍·绘都兰世"
function cm.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
--Special Summon
function cm.confilter(c)
	return c:IsCode(m)
end
function cm.tgfilter(c)
	return c:IsRace(RACE_PLANT) and c:IsAbleToGrave()
end
function cm.spfilter(c,e,tp)
	return c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.confilter,tp,LOCATION_GRAVE,0,1,nil)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_HAND,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()==0 or Duel.SendtoGrave(g,REASON_EFFECT)==0 or Duel.GetMZoneCount(tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=sg:GetFirst()
	if tc then
		Duel.BreakEffect()
		local c=e:GetHandler()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetCountLimit(1)
			e1:SetLabelObject(tc)
			e1:SetCondition(cm.tdcon)
			e1:SetOperation(cm.tdop)
			Duel.RegisterEffect(e1,tp)
			if c:IsFaceup() and c:IsRelateToEffect(e) then
				local e1=Effect.CreateEffect(c)
				e1:SetDescription(aux.Stringid(m,2))
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
				e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				c:RegisterEffect(e1)
			end
		end
	end
end
function cm.tdcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsLocation(LOCATION_MZONE) and tc:IsSummonType(SUMMON_TYPE_SPECIAL)
		and tc:GetReasonEffect():GetHandler()==e:GetHandler() then return true
	else
		e:Reset()
		return false
	end
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoDeck(e:GetLabelObject(),nil,1,REASON_EFFECT)
end