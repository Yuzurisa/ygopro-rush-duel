local m=120170000
local cm=_G["c"..m]
cm.name="破坏之剑士"
function cm.initial_effect(c)
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
	return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsRace(RACE_DRAGON)
end
function cm.atkval(e,c)
	return Duel.GetMatchingGroupCount(cm.filter,c:GetControler(),0,LOCATION_GRAVE+LOCATION_MZONE,nil)*500
end