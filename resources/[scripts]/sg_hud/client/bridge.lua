SGHUD = {player=nil, extra={blackMoney=0,society=0,hasSociety=false}, hidden=false, ready=false}
local core = exports.sg_core
function SGHUD.refresh()
    SGHUD.player = core:getPlayer()
    return SGHUD.player
end
function SGHUD.percent(value,max)
    value,max=tonumber(value) or 0,tonumber(max) or 100
    if max<=0 then return 0 end
    return math.min(100, math.max(0,value/max*100))
end
function SGHUD.status()
    if GetResourceState('sg_status') ~= 'started' then return {} end
    return exports.sg_status:getStatus() or {}
end
function SGHUD.visible()
    return SGHUD.player ~= nil and not SGHUD.hidden and not IsPauseMenuActive()
end
function SGHUD.initialize()
    SGHUD.refresh()
    SendNUIMessage({action='ui',config=Config.ui})
    SendNUIMessage({action='setFont',url=Config.font.url,name=Config.font.name})
    SendNUIMessage({action='setLogo',value=Config.serverLogo})
    SendNUIMessage({action='toggleUi',value=SGHUD.visible()})
end
function SGHUD.voiceDistance()
    local proximity=LocalPlayer.state.proximity or {}
    if proximity.index==1 then return 'whisper' elseif proximity.index and proximity.index>=3 then return 'shout' end
    return 'normal'
end
function SGHUD.pushData()
    local p=SGHUD.refresh()
    if not p then return end
    local j=p.jobInfo or {};local rank=tostring(j.rankName or '')
    local job=j.label or p.job or 'Unemployed'
    if rank~='' and rank~=job then job=job..': '..rank end
    SendNUIMessage({action='setText',id='job',value=job})
    for name,value in pairs({wallet=p.cash or 0,bank=p.bank or 0,blackMoney=SGHUD.extra.blackMoney or 0,society=SGHUD.extra.society or 0}) do
        SendNUIMessage({action='setMoney',id=name,value=value})
    end
    SendNUIMessage({action='element',task=(Config.ui.showSocietyMoney and SGHUD.extra.hasSociety and j.isBoss and not SGHUD.infoHidden) and 'enable' or 'disable',value='society'})
    local status=SGHUD.status();local ped=PlayerPedId()
    local message={action='setStatus',isdead=IsEntityDead(ped),status={}}
    local function add(name,value) message.status[#message.status+1]={name=name,value=value} end
    if Config.ui.showHealth then add('health',SGHUD.percent(GetEntityHealth(ped)-100,GetEntityMaxHealth(ped)-100)) end
    if Config.ui.showArmor then add('armor',SGHUD.percent(GetPedArmour(ped),GetPlayerMaxArmour(PlayerId()))) end
    if Config.ui.showStamina then local s=status.stamina;add('stamina',s and SGHUD.percent(s.status,s.max) or GetPlayerSprintStaminaRemaining(PlayerId())) end
    -- Trew's renderer inverts hunger/thirst internally; feed depletion, not remaining supply.
    if Config.ui.showHunger then local s=status.hunger;add('hunger',100-(s and SGHUD.percent(s.status,s.max) or 100)) end
    if Config.ui.showThirst then local s=status.thirst;add('thirst',100-(s and SGHUD.percent(s.status,s.max) or 100)) end
    SendNUIMessage(message)
end
RegisterNetEvent('SG:characterLoaded',function(p) SGHUD.player=p;SGHUD.extra={blackMoney=0,society=0,hasSociety=false};SGHUD.initialize();SGHUD.pushData() end)
RegisterNetEvent('SG:updateCharacter',function(p) SGHUD.player=p;SGHUD.pushData() end)
RegisterNetEvent('SG:updateMoney',function() SGHUD.pushData() end)
RegisterNetEvent('SG:characterUnloaded',function() SGHUD.player=nil;SGHUD.extra={blackMoney=0,society=0,hasSociety=false};SendNUIMessage({action='toggleUi',value=false}) end)
RegisterNUICallback('ready',function(_,cb) SGHUD.ready=true;SGHUD.initialize();SGHUD.pushData();cb({ok=true}) end)
CreateThread(function() Wait(1000);SGHUD.initialize();while true do Wait(Config.UpdateInterval);SGHUD.pushData() end end)
CreateThread(function()
    while true do
        Wait(Config.AccountInterval)
        local p=SGHUD.refresh()
        if p and (Config.ui.showBlackMoney or Config.ui.showSocietyMoney) then
            local id=p.id
            local ok,result=pcall(lib.callback.await,'sg_hud:accounts',false)
            if ok and type(result)=='table' and SGHUD.player and SGHUD.player.id==id then SGHUD.extra=result end
        end
    end
end)
