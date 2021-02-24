--幻竜重騎ウォームＥｘカベーター［Ｌ］
--Wurm Ex-Cavator the Heavy Mequestrian Wyrm [L]
--Scripted by Yuno
function c150155202.initial_effect(c)
    --Gain ATK
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(RushDuel.IsMaximumMode)
    e1:SetValue(c150155202.value)
	c:RegisterEffect(e1)
end
function c150155202.value(e, c)
	return Duel.GetFieldGroupCount(c:GetControler(), LOCATION_HAND, 0)*300
end