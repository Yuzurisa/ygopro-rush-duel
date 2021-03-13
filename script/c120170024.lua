local m=120170024
local cm=_G["c"..m]
cm.name="王家魔族·死亡厄运歌手"
function cm.initial_effect(c)
	--Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
	--Tribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetLabelObject(e1)
	e2:SetValue(cm.tricheck)
	c:RegisterEffect(e2)
end
--Destroy
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_SUMMON) and c:IsStatus(STATUS_SUMMON_TURN) and e:GetLabel()==1
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 and Duel.Destroy(g,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		local lv=og:GetSum(Card.GetOriginalLevel)
		if lv>0 then
			Duel.BreakEffect()
			Duel.Damage(1-tp,lv*100,REASON_EFFECT)
		end
	end
end
--Tribute
function cm.trifilter(c)
	return c:IsLevelAbove(7) and c:IsRace(RACE_FIEND)
end
function cm.tricheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(cm.trifilter,2,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end