local m=120155021
local cm=_G["c"..m]
cm.name="幻龙重骑 超斗轮挖掘鳞虫［L］"
function cm.initial_effect(c)
	--Atk Up
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_XMATERIAL)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(RushDuel.IsMaximumMode)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
end
--Atk Up
function cm.atkval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)*300
end