local m=120190002
local list={120130000}
local cm=_G["c"..m]
cm.name="黑魔导少女"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1])
	--Atk Up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
end
--Atk Up
function cm.filter(c)
	return RushDuel.IsLegendCode(c,list[1])
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.filter,c:GetControler(),LOCATION_GRAVE,LOCATION_GRAVE,nil)*500
end