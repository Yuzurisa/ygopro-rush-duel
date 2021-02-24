--幻刃竜ビルド・ドラゴン
--Build Dragon the Mythic Sword Dragon
--Scripted by Yuno
function c120155204.initial_effect(c)
    --Special Summon a Normal Wyrm from GY
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCondition(c120155204.condition)
    e1:SetTarget(c120155204.target)
    e1:SetOperation(c120155204.operation)
    c:RegisterEffect(e1)
end
--Requirement
function c120155204.condition(e, tp, eg, ep, ev, re, r, rp)
    return Duel.IsExistingMatchingCard(Card.IsFaceup, tp, LOCATION_FZONE, LOCATION_FZONE, 1, nil)
end
--Effect
function c120155204.filter(c, e, tp)
    return c:IsRace(RACE_WYRM) and c:IsType(TYPE_NORMAL) and c:IsCanBeSpecialSummoned(e, 0, tp, false, false)
end
function c120155204.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk==0 then return Duel.GetLocationCount(tp, LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(c120155204.filter, tp, LOCATION_GRAVE, 0, 1, nil, e, tp) end
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 1, tp, LOCATION_GRAVE)
end
function c120155204.operation(e, tp, eg, ep, ev, re, r, rp)
    if Duel.GetLocationCount(tp, LOCATION_MZONE)<=0 then return end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp, c120155204.filter, tp, LOCATION_GRAVE, 0, 1, 1, nil, e, tp)
    if g:GetCount()>0 then
        Duel.SpecialSummon(g, 0, tp, tp, false, false, POS_FACEUP)
    end
end