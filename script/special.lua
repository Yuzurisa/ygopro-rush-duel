--Constant
SUMMON_TYPE_MAXIMUM = 0x45000000
RACE_CYBORG = 0x2000000

RushDuel={}

function Auxiliary.PreloadUds()
	--Duel Start
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e1:SetOperation(function(e)
		--Draw 1 For First Hand
		if not Auxiliary.Load2PickRule then
			Duel.Draw(0,1,REASON_RULE)
		end
		--Legend Card
		local g=Duel.GetMatchingGroup(Card.IsCode,0,0xff,0xff,nil,120000000)
		local legend=g:GetFirst()
		while legend do
			local e1=Effect.GlobalEffect()
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_CODE)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetRange(0xff)
			e1:SetValue(legend:GetOriginalCode())
			legend:RegisterEffect(e1)
			legend=g:GetNext()
		end
		e:Reset()
	end)
	Duel.RegisterEffect(e1,0)
	--Draw
	local e2=Effect.GlobalEffect()
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DRAW_COUNT)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	e2:SetValue(RushDuel.DrawCount)
	Duel.RegisterEffect(e2,0)
	--Hand Limit
	local e3=Effect.GlobalEffect()
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_HAND_LIMIT)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,1)
	e3:SetValue(100)
	Duel.RegisterEffect(e3,0)
	--Summon Limit
	local e4=Effect.GlobalEffect()
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SET_SUMMON_COUNT_LIMIT)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetValue(100)
	Duel.RegisterEffect(e4,0)
	--Lock Zone
	local e5=Effect.GlobalEffect()
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DISABLE_FIELD)
	e5:SetOperation(RushDuel.DisableZone)
	Duel.RegisterEffect(e5,0)
	--Skip M2
	local e6=Effect.GlobalEffect()
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_SKIP_M2)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetTargetRange(1,1)
	Duel.RegisterEffect(e6,0)
	--Trap Chain
	local e8=Effect.GlobalEffect()
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_CHAINING)
	e8:SetOperation(RushDuel.TrapChainLimitOperation)
	Duel.RegisterEffect(e8,0)
	--Once Per Turn
	local e9=Effect.GlobalEffect()
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_CANNOT_ACTIVATE)
	e9:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e9:SetTargetRange(1,1)
	e9:SetValue(RushDuel.ActivateLimit)
	Duel.RegisterEffect(e9,0)
	local e9=Effect.GlobalEffect()
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_CHAIN_SOLVING)
	e9:SetOperation(RushDuel.ActivateCount)
	Duel.RegisterEffect(e9,0)
end
function RushDuel.DrawCount(e)
	local p=Duel.GetTurnPlayer()
	local ct=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if ct>4 then return 1
	else return 5-ct end
end
--Lock Zone
function RushDuel.DisableZone(e,tp)
	return 0x11711171
end
--Trap Chain
function RushDuel.TrapChainLimitOperation(e,tp,eg,ep,ev,re,r,rp)
	local time=re:GetCode()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_TRAP) then
		Duel.SetChainLimit(RushDuel.chaintime)
	end
end
function RushDuel.chaintime(e,rp,tp)
	return not (e:IsHasType(EFFECT_TYPE_ACTIVATE) and e:IsActiveType(TYPE_TRAP)) 
end
--Once Per Turn
function RushDuel.ActivateLimit(e,re,tp)
	local code=re:GetOwner():GetCode()
	return re:GetHandler():GetFlagEffect(code)~=0
end
function RushDuel.ActivateCount(e,tp,eg,ep,ev,re,r,rp)
	local te=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
	local code=te:GetOwner():GetCode()
	te:GetHandler():RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
--Legend
function RushDuel.IsLegendCode(c,code)
	return (c:GetOriginalCode()==code and c:IsCode(120000000)) or c:IsCode(code)
end
--Maximum Summon
function RushDuel.AddMaximumProcedure(c,max_atk,left_code,right_code)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000000,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(RushDuel.MaximumSummonCondition(left_code,right_code))
	e1:SetOperation(RushDuel.MaximumSummonOperation(left_code,right_code))
	e1:SetValue(SUMMON_TYPE_MAXIMUM)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCondition(RushDuel.IsMaximumMode)
	e2:SetOperation(RushDuel.MaximumMaterial)
	c:RegisterEffect(e2)
	--Maximun Atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SET_BASE_ATTACK)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(RushDuel.IsMaximumMode)
	e3:SetValue(max_atk)
	c:RegisterEffect(e3)
	--Position
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_POSITION)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(POS_FACEUP_ATTACK)
	e4:SetCondition(RushDuel.IsMaximumMode)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(RushDuel.IsMaximumMode)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_CANNOT_CHANGE_POS_E)
	e6:SetCondition(RushDuel.MaxPosCondition)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_TURN_SET)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCondition(RushDuel.IsMaximumMode)
	c:RegisterEffect(e7)
	--Use 3 MZone
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_MAX_MZONE)
	e8:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetRange(LOCATION_MZONE)
	e8:SetTargetRange(1,0)
	e8:SetCondition(RushDuel.IsMaximumMode)
	e8:SetValue(1)
	c:RegisterEffect(e8)
	--Leave Field
    local e9=Effect.CreateEffect(c)
    e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e9:SetCode(EVENT_LEAVE_FIELD_P)
    e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCondition(RushDuel.IsMaximumMode)
    e9:SetOperation(RushDuel.LeaveOperation)
    c:RegisterEffect(e9)
end
function RushDuel.MaximumSummonFilter(c,e,tp,left_code,right_code)
	return c:IsCode(left_code,right_code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function RushDuel.MaximumSummonCheck(g)
	return g:GetClassCount(Card.GetCode)==g:GetCount()
end
function RushDuel.MaximumSummonCondition(left_code,right_code)
	return function(e,c,og)
		if c==nil then return true end
		local tp=c:GetControler()
		local mg=Duel.GetMatchingGroup(RushDuel.MaximumSummonFilter,tp,LOCATION_HAND,0,nil,e,tp,left_code,right_code)
		local fg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
		return Duel.GetMZoneCount(tp,fg)>0 and not Duel.IsPlayerAffectedByEffect(tp,59822133)
			and mg:CheckSubGroup(RushDuel.MaximumSummonCheck,2,2)
	end
end
function RushDuel.MaximumSummonOperation(left_code,right_code)
	return function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
		local mg=Duel.GetMatchingGroup(RushDuel.MaximumSummonFilter,tp,LOCATION_HAND,0,nil,e,tp,left_code,right_code)
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(120000000,1))
		local cancel=Duel.GetCurrentChain()==0
		local g=mg:SelectSubGroup(tp,RushDuel.MaximumSummonCheck,cancel,2,2)
		if not g then return end
		local fg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
		Duel.SendtoGrave(fg,REASON_RULE)
		c:SetMaterial(g)
		sg:AddCard(c)
		sg:Merge(g)
	end
end
function RushDuel.IsMaximumMode(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_MAXIMUM)
end
function RushDuel.MaxPosCondition(e)
	return RushDuel.IsMaximumMode(e) and e:GetHandler():IsAttackPos()
end
function RushDuel.MaximumMaterial(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	Duel.Overlay(c,mg)
	Duel.MoveSequence(c,2)
end
function RushDuel.LeaveOperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local loc=c:GetDestination()
	local g=c:GetOverlayGroup()
	if loc==LOCATION_HAND then
		Duel.SendtoHand(g,nil,REASON_RULE)
	elseif loc==LOCATION_DECK then
		Duel.SendtoDeck(g,nil,2,REASON_RULE)
	elseif loc==LOCATION_REMOVED then
		Duel.Remove(g,POS_FACEUP,REASON_RULE)
	end
end
--Def Check
function RushDuel.IsHasDefense(c)
	return c:IsDefenseAbove(0)
		and not (c:IsSummonType(SUMMON_TYPE_MAXIMUM) and c:GetOverlayCount()>0)
end
--Select Effect
function RushDuel.BaseSelectEffect(c,eff1hint,eff1con,eff1op,eff2hint,eff2con,eff2op)
    local e=Effect.CreateEffect(c)
    e:SetType(EFFECT_TYPE_IGNITION)
    e:SetRange(LOCATION_MZONE)
    e:SetTarget(RushDuel.SelectEffectTarget(eff1con,eff2con))
    e:SetOperation(RushDuel.SelectEffectOperation(eff1hint,eff1con,eff1op,eff2hint,eff2con,eff2op))
    return e
end
function RushDuel.SelectEffectCondition(eff1con,eff2con)
	return function(e,tp,eg,ep,ev,re,r,rp)
		return eff1con(e,tp,eg,ep,ev,re,r,rp) or eff2con(e,tp,eg,ep,ev,re,r,rp)
	end
end
function RushDuel.SelectEffectTarget(eff1con,eff2con)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return eff1con(e,tp,eg,ep,ev,re,r,rp) or eff2con(e,tp,eg,ep,ev,re,r,rp) end
	end
end
function RushDuel.SelectEffectOperation(eff1hint,eff1con,eff1op,eff2hint,eff2con,eff2op)
	return function(e,tp,eg,ep,ev,re,r,rp)
		local eff1=eff1con(e,tp,eg,ep,ev,re,r,rp)
		local eff2=eff2con(e,tp,eg,ep,ev,re,r,rp)
		local select=0
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
		if eff1 and eff2 then
			select=Duel.SelectOption(tp,eff1hint,eff2hint)+1
		elseif eff1 then
			Duel.SelectOption(tp,eff1hint)
			select=1
		elseif eff2 then
			Duel.SelectOption(tp,eff2hint)
			select=2
		end
		if select==1 then eff1op(e,tp,eg,ep,ev,re,r,rp)
		elseif select==2 then eff2op(e,tp,eg,ep,ev,re,r,rp)
		end
	end
end