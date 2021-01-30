--幻竜重騎ウォームＥｘカベーター［Ｒ］
--Wurm Ex-Cavator the Heavy Mequestrian Wyrm [R]
--Scripted by Yuno
function c150155203.initial_effect(c)
    --Gain ATK
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(150155203, 0))
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(RushDuel.IsMaximumMode)
    e1:SetCost(c150155203.cost)
    e1:SetTarget(c150155203.target)
    e1:SetOperation(c150155203.operation)
	c:RegisterEffect(e1)
end
--Requirement
function c150155203.cost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeckAsCost, tp, LOCATION_GRAVE, 0, 1, nil) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp, Card.IsAbleToDeckAsCost, tp, LOCATION_GRAVE, 0, 1, 1, nil)
    Duel.SendtoDeck(g, nil, 1, REASON_COST)
end
--Effect
function c150155203.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c150155203.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c150155203.filter, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, nil)
        and Duel.IsPlayerCanDraw(tp, 1) end
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, nil, 1, 0, 0)
    Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 1, tp, 1)
end
function c150155203.operation(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
    local g=Duel.SelectMatchingCard(tp, c150155203.filter, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, 1, nil)
    local sg=g:GetFirst()
    if Duel.Destroy(sg, REASON_EFFECT)~=0 and Duel.Draw(tp, 1, REASON_EFFECT)~=0 then
        if sg:IsType(TYPE_SPELL+TYPE_FIELD) and Duel.SelectYesNo(tp, aux.Stringid(150155203, 0)) then
            Duel.Draw(tp, 1, REASON_EFFECT)
        end
    end
end