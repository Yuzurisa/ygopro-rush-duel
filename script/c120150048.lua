local m=120150048
local cm=_G["c"..m]
cm.name="手札抹杀"
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
--Activate
function cm.filter(c,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:GetPreviousControler()==tp
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local h1=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if e:GetHandler():IsLocation(LOCATION_HAND) then h1=h1-1 end
		local h2=Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)
		return (h1+h2>0) and (Duel.IsPlayerCanDraw(tp,h1) or h1==0) and (Duel.IsPlayerCanDraw(1-tp) or h2==0)
	end
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	if Duel.SendtoGrave(g,REASON_EFFECT)~=0 then
		local og=Duel.GetOperatedGroup()
		local h1=og:FilterCount(cm.filter,nil,tp)
		local h2=og:FilterCount(cm.filter,nil,1-tp)
		if h1+h2>0 then
			Duel.BreakEffect()
			Duel.Draw(tp,h1,REASON_EFFECT)
			Duel.Draw(1-tp,h2,REASON_EFFECT)
		end
	end
end