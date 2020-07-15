local m=120130039
local cm=_G["c"..m]
cm.name="世纪末兽机界"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk Up / Down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(cm.uptg)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetTarget(cm.downtg)
	e3:SetValue(-300)
	c:RegisterEffect(e3)
end
--Atk Up / Down
function cm.uptg(e,c)
	return c:IsFaceup() and c:IsRace(RACE_BEASTWARRIOR+RACE_FIEND+RACE_MACHINE)
end
function cm.downtg(e,c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON+RACE_SPELLCASTER+RACE_FAIRY)
end