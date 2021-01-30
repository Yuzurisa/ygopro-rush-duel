--拡がるささやき
--Echoing Whispers
--Scripted by Yuno
function c120150052.initial_effect(c)
    --Shuffle into deck
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_MSET)
    e1:SetCondition(c120150052.condition)
    e1:SetTarget(c120150052.target)
    e1:SetOperation(c120150052.operation)
    c:RegisterEffect(e1)
end
--Requirement
function c120150052.filter1(c)
    return c:IsSummonPlayer(1-tp) and c:IsPreviousLocation(LOCATION_HAND)
end
function c120150052.condition(e, tp, eg, ep, ev, re, r, rp)
    return eg:IsExists(c120150052.filter1, 1, nil, tp)
end
--Effect
function c120150052.filter2(c)
    return c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c120150052.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk==0 then return Duel.IsExistingMatchingCard(c120150052.filter2, tp, LOCATION_GRAVE, LOCATION_GRAVE, 1, nil) end
    Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, tp, LOCATION_GRAVE)
end
function c120150052.operation(e, tp, eg, ep, ev, re, r, rp)
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp, c120150052.filter2, tp, LOCATION_GRAVE, LOCATION_GRAVE, 1, 5, nil)
    if g:GetCount()>0 then
        Duel.SendtoDeck(g, nil, 2, REASON_EFFECT)
    end
end