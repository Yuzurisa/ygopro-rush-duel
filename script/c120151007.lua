local m=120151007
local cm=_G["c"..m]
cm.name="大恐龙驾 联力恐龙车［R］"
function cm.initial_effect(c)
	--Indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_XMATERIAL)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(RushDuel.IsMaximumMode)
	e1:SetValue(cm.efilter)
	c:RegisterEffect(e1)
end
--Indes
function cm.efilter(e,re,rp)
	return rp==1-e:GetHandlerPlayer() and re:IsActiveType(TYPE_TRAP)
end