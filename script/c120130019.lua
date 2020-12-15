local m=120130019
local list={120130001}
local cm=_G["c"..m]
cm.name="龙队后卫"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1])
	--Position
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.condition)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
--Atk Up
function cm.confilter(c)
	return c:IsFaceup() and c:IsCode(list[1])
end
function cm.posfilter(c,tp)
	if c:IsControler(tp) then
		return c:IsPosition(POS_FACEUP_ATTACK) and c:IsCode(list[1]) and c:IsCanChangePosition() and RushDuel.IsHasDefense(c)
	else
		return c:IsAttackPos() and c:IsCanChangePosition() and RushDuel.IsHasDefense(c)
	end
end
function cm.check(g,tp)
	return g:GetClassCount(Card.GetControler)==2
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.confilter,tp,LOCATION_MZONE,0,1,nil)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(cm.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	if chk==0 then return g:CheckSubGroup(cm.check,2,2,tp) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,2,0,0)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	if not g:CheckSubGroup(cm.check,2,2,tp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local sg=g:SelectSubGroup(tp,cm.check,false,2,2,tp)
	Duel.HintSelection(sg)
	Duel.ChangePosition(sg,POS_FACEUP_DEFENSE)
end