local m=120196002
local list={120196006,120196008}
local cm=_G["c"..m]
cm.name="钢铁徽章之弗栗多明星"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1],list[2])
	--Fusion Material
	aux.AddFusionProcCode2(c,list[1],list[2],true,true)
	--Select Effect
	local e1=RushDuel.BaseSelectEffect(c,aux.Stringid(m,1),cm.eff1con,cm.eff1op,aux.Stringid(m,2),cm.eff2con,cm.eff2op)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
	c:RegisterEffect(e1)
end
--Position
function cm.posfilter(c)
	return c:IsCanChangePosition() and RushDuel.IsHasDefense(c)
		and (not c:IsPosition(POS_FACEUP_ATTACK) or c:IsCanTurnSet())
end
function cm.eff1con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.posfilter,tp,0,LOCATION_MZONE,1,nil)
end
function cm.eff1op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,cm.posfilter,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		local pos=POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE
		if tc:IsPosition(POS_FACEUP_ATTACK) then
			pos=POS_FACEDOWN_DEFENSE
		elseif tc:IsFacedown() or not tc:IsCanTurnSet() then
			pos=POS_FACEUP_ATTACK
		end
		pos=Duel.SelectPosition(tp,tc,pos)
		Duel.ChangePosition(tc,pos)
	end
end
--Destroy
function cm.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBORG)
end
function cm.desfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function cm.eff2con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(cm.desfilter,tp,0,LOCATION_MZONE,1,nil)
end
function cm.eff2op(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(cm.filter,tp,LOCATION_MZONE,0,nil)
	if ct<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,cm.desfilter,tp,0,LOCATION_MZONE,1,ct,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end