VERSION = 'v0.1a'

--Helper
local syn_f = is_synapse_function
function search_funcs(scrpt, tabl)
    local fvx = {}
    for i, v in pairs(tabl) do
        if (type(v) == 'function') and not syn_f(v) then
            if tostring(getfenv(v).script) == tostring(scrpt) then
                fvx[#fvx+1] = v
            end
        end
    end
    return fvx
end
function search_env(func, env_func, output_)
    if output_ then
        for i, v in pairs(env_func(func)) do
            print(i, ':', v)
        end
    end
    return env_func(func)
end


--Local Variables
local player = game.Players.LocalPlayer
local hum = player.Character.Humanoid
hum.UseJumpPower = true

local shieldButton = game:GetService("Players").Pikinkuinku.PlayerGui.LeftButtons.MainContainer.ShieldButton.button

local base = {
    wk = hum.WalkSpeed,
    jp = hum.JumpPower
}


--Global Variables


--Bootup Hooks
local old1, old2
old1 = hookmetamethod(hum, '__index', newcclosure(function(slf, prop)
    if not checkcaller() and slf == hum then
        if tostring(prop) == 'WalkSpeed' then
            return base.wk
        end
        if tostring(prop) == 'JumpPower' then
            return base.jp
        end
    end
    
    return old1(slf, prop)
end))
old2 = hookmetamethod(hum, '__newindex', newcclosure(function(slf, prop, val)
    if not checkcaller() and slf == hum then
        if tostring(prop) == 'WalkSpeed' or tostring(prop) == 'JumpPower' then
            return
        end
    end
    
    return old2(slf, prop, val)
end))

hookfunction(
    debug.getupvalue(getconnections(shieldButton.Activated)[1].Function, 3),
    function() return end
)


--Functions     [S Synapse / Utlity ; U User Interface]
function USliderWK(val)
    hum.WalkSpeed = val
end
function USliderJP(val)
    hum.JumpPower = val
end

function UTogglePVP()
    getconnections(shieldButton.Activated)[1]:Fire()
end


--Main Thread
task.spawn(function()
end)


--UI Bootup
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local hwnd = OrionLib:MakeWindow {
    Name = 'Boxing Beta'
}
OrionLib:MakeNotification {
    Name = 'Welcome back',
    Content = 'Boxing Beta ' .. VERSION
}


--Tab Initializations
local tLocal = hwnd:MakeTab {
    Name = 'Local'
}
local tPVP = hwnd:MakeTab {
    Name = 'PVP'
}


--Local Tab
tLocal:AddSlider {
    Name = 'WalkSpeed',
    Min = 0,
    Max = 100,
    Default = base.wk,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = '',
    Callback = USliderWK
}
tLocal:AddSlider {
    Name = 'JumpPower',
    Min = 0,
    Max = 100,
    Default = base.jp,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 1,
    ValueName = '',
    Callback = USliderJP
}


--PVP Tab
tPVP:AddButton {
    Name = 'Toggle',
    Callback = UTogglePVP
}
