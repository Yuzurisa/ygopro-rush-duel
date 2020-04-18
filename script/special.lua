
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
	local e7=Effect.GlobalEffect()
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_CHAINING)
	e7:SetOperation(RushDuel.TrapChainLimitOperation)
	Duel.RegisterEffect(e7,0)
	--Once Per Turn
	local e5=Effect.GlobalEffect()
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_ACTIVATE_COST)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(1,0)
	e5:SetTarget(RushDuel.OncePerTurnTarget)
	e5:SetCost(RushDuel.OncePerTurnCost)
	e5:SetOperation(RushDuel.OncePerTurnOperation)
	local e6=Effect.GlobalEffect()
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e6:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetLabelObject(e5)
	Duel.RegisterEffect(e6,0)
end
function RushDuel.DrawCount(e)
	local p=Duel.GetTurnPlayer()
	local ct=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if ct>4 then return 1
	else return 5-ct end
end
--Lock Zone
function RushDuel.DisableZone(e,tp)
	return 0x11111111
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
--Once per turn
function RushDuel.OncePerTurnTarget(e,te,tp)
	return te:GetHandler()==e:GetHandler()
end
function RushDuel.OncePerTurnCost(e,te,tp)
	return e:GetHandler():GetFlagEffect(10001)==0
end
function RushDuel.OncePerTurnOperation(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(10001,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
