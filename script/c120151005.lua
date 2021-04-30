local m=120151005
local cm=_G["c"..m]
cm.name="大恐龙驾 联力恐龙车［L］"
function cm.initial_effect(c)
	--Indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_XMATERIAL)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(RushDuel.IsMaximumMode)
	e1:SetValue(cm.indes)
	c:RegisterEffect(e1)
end
--Indes
function cm.indes(e,c)
	return c:IsLevelBelow(7)
end