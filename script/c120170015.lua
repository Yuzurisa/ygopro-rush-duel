local m=120170015
local list={120170014,120170016}
local cm=_G["c"..m]
cm.name="灰霸炎神 辽阔火山"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1],list[2])
	--Maximum Summon
	RushDuel.AddMaximumProcedure(c,3300,list[1],list[2])
	--Indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
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