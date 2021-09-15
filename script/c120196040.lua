local m=120196040
local list={120196042,120196041}
local cm=_G["c"..m]
cm.name="迷宫的魔战车"
function cm.initial_effect(c)
	aux.AddCodeList(c,list[1],list[2])
	--Fusion Material
	aux.AddFusionProcCode2(c,list[1],list[2],true,true)
end