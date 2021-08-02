local m=120192017
local cm=_G["c"..m]
cm.name="幻刃工兵 测距龙"
function cm.initial_effect(c)
	--Confirm Card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
--Confirm Card
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_SUMMON) and c:IsStatus(STATUS_SUMMON_TURN)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<1 then return end
	Duel.ConfirmDecktop(tp,1)
	local op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
	if op==1 then
		local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
		Duel.MoveSequence(tc,1)
	end
end