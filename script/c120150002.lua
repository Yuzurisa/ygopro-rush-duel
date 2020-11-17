local m=120150002
local list={120150001,120150003}
local cm=_G["c"..m]
cm.name="超魔机神 大霸道王"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1],list[2])
	--Maximum Summon
	RushDuel.AddMaximumProcedure(c,3500,list[1],list[2])
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
function cm.efilter(e,re)
	return rp==1-e:GetHandlerPlayer() and re:GetOwner():IsType(TYPE_TRAP)
end