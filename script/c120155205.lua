--鋼機神ミラーイノベイター
--Steeltek Deity Mirror Innovator
--Scripted by Yuno
function c120155205.initial_effect(c)
    --Gain ATK and shuffle into deck
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TODECK)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetTarget(c120155205.target)
    e1:SetOperation(c120155205.operation)
    c:RegisterEffect(e1)
end
--Effect
function c120155205.filter(c, race)
    return c:IsType(TYPE_MONSTER) and c:IsRace(race) and c:IsAbleToDeck()
end
function c120155205.target(e, tp, eg, ep, ev, re, r, rp, chk)
    local race=e:GetHandler():GetRace()
    if chk==0 then return Duel.IsExistingMatchingCard(c120155205.filter, tp, LOCATION_GRAVE, 0, 1, nil, race) end
    Duel.SetOperationInfo(0, CATEGORY_TODECK, nil, 1, tp, LOCATION_GRAVE)
end
function c120155205.operation(e, tp, eg, ep, ev, re, r, rp)
    local c=e:GetHandler()
    local race=e:GetHandler():GetRace()
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_TODECK)
    local g=Duel.SelectMatchingCard(tp, c120155205.filter, tp, LOCATION_GRAVE, 0, 1, 3, nil, race)
    if c:IsFaceup() and c:IsRelateToEffect(e) then
        local level=g:GetSum(Card.GetLevel)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(level*100)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
        c:RegisterEffect(e1)
        Duel.BreakEffect()
        local prcon=Duel.SendtoDeck(g, nil, 2, REASON_EFFECT)
        if prcon==1 then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_PIERCE)
            e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
            c:RegisterEffect(e1)
        end
    end
end