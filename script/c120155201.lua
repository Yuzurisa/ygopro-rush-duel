--幻竜重騎ウォームＥｘカベーター
--Wurm Ex-Cavator the Heavy Mequestrian Wyrm
--Scripted by Yuno
function c120155201.initial_effect(c)
    aux.AddCodeList(c, 120155202, 120155203)
    --Maximum Summon
	RushDuel.AddMaximumProcedure(c, 3500, 120155202, 120155203)
	--Cannot be destroyed by traps
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(RushDuel.IsMaximumMode)
	e1:SetValue(c120155201.efilter)
	c:RegisterEffect(e1)
end
--Cannot be destroyed by traps
function c120155201.efilter(e, re, rp)
	return rp==1-e:GetHandlerPlayer() and re:IsActiveType(TYPE_TRAP)
end