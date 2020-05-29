local m=120130043
local cm=_G["c"..m]
cm.name="属性变更弹"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(cm.cost)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Activate
function cm.costfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and not c:IsPublic()
		and Duel.IsExistingMatchingCard(cm.attrfilter,tp,0,LOCATION_MZONE,1,nil,c:GetAttribute())
end
function cm.attrfilter(c,attr)
	return c:IsFaceup() and not c:IsAttribute(attr)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.costfilter,tp,LOCATION_HAND,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,cm.costfilter,tp,LOCATION_HAND,0,1,1,nil,tp)
	e:SetLabel(g:GetFirst():GetAttribute())
	Duel.ConfirmCards(1-tp,g)
	Duel.ShuffleHand(tp)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local attr=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,1))
	local g=Duel.SelectMatchingCard(tp,cm.attrfilter,tp,0,LOCATION_MZONE,1,3,nil,attr)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()
		while tc do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
			e1:SetValue(attr)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			tc=g:GetNext()
		end
	end
end