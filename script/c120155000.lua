local m=120155000
local cm=_G["c"..m]
cm.name="人造人-念力震慑者"
function cm.initial_effect(c)
	--Cannot Trigger
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0xa,0xa)
	e1:SetTarget(cm.distg)
	c:RegisterEffect(e1)
	--Disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e2:SetTarget(cm.distg)
	c:RegisterEffect(e2)
	--Disable Effect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(cm.disop)
	c:RegisterEffect(e3)
	--Disable Trap Monster
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_DISABLE_TRAPMONSTER)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e4:SetTarget(cm.distg)
	c:RegisterEffect(e4)
end
--Disable
function cm.distg(e,c)
	return c:IsType(TYPE_TRAP)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_TRAP) then
		Duel.NegateEffect(ev)
	end
end