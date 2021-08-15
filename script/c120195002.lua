local m=120195002
local list={120195006,120195008}
local cm=_G["c"..m]
cm.name="钢铁勋章·维特拉明星"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1],list[2])
	--Fusion Material
	aux.AddFusionProcCode2(c,list[1],list[2],true,true)
	--Select Effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
--Select Effect
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return cm.eff1con(e,tp,eg,ep,ev,re,r,rp) or cm.eff2con(e,tp,eg,ep,ev,re,r,rp) end
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local eff1=cm.eff1con(e,tp,eg,ep,ev,re,r,rp)
	local eff2=cm.eff2con(e,tp,eg,ep,ev,re,r,rp)
	local select=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,0))
	if eff1 and eff2 then
		select=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))+1
	elseif eff1 then
		Duel.SelectOption(tp,aux.Stringid(m,1))
		select=1
	elseif eff2 then
		Duel.SelectOption(tp,aux.Stringid(m,2))
		select=2
	end
	if select==1 then cm.eff1op(e,tp,eg,ep,ev,re,r,rp)
	elseif select==2 then cm.eff2op(e,tp,eg,ep,ev,re,r,rp)
	end
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
	return c:IsFaceup() and c:IsRace(0x2000000)
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