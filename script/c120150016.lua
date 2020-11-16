local m=120150016
local list={120150014,120150015}
local cm=_G["c"..m]
cm.name="仄普粒子机"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1],list[2])
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW+CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(cm.condition)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
end
--Draw
function cm.confilter(c,code)
	return c:IsCode(code)
end
function cm.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<=1
		and Duel.IsExistingMatchingCard(cm.confilter,tp,LOCATION_GRAVE,0,1,nil,list[1])
		and Duel.IsExistingMatchingCard(cm.confilter,tp,LOCATION_GRAVE,0,1,nil,list[2])
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGrave() and Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,tp,2)
end
function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.SendtoGrave(c,REASON_EFFECT)~=0 and Duel.Draw(tp,2,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,2,2,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			local ct=Duel.SendtoDeck(g,nil,0,REASON_EFFECT)
			Duel.SortDecktop(tp,tp,ct)
			for i=1,ct do
				local tg=Duel.GetDecktopGroup(tp,1)
				Duel.MoveSequence(tg:GetFirst(),1)
			end
		end
	end
end