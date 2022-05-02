--Variables
local player = game.Players.LocalPlayer
local _char = player.Character
local hum = _char.Humanoid
hum.UseJumpPower = true

--Others
local base_wk = hum.WalkSpeed
local base_jp = hum.JumpPower

--Global Variables
getgenv().WK = 16
getgenv().JP = 50

--UI Setup
local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/AikaV3rm/UiLib/master/Lib.lua')))()
local hwnd = library:CreateWindow('SJHack v1.9')
local fold_v = hwnd:CreateFolder('Values')
local fold_ih = hwnd:CreateFolder('Index Hook')
local fold_ah = hwnd:CreateFolder('Assignment Hook') --New index hook
local fold_AK = hwnd:CreateFolder('Anti-Kick')

--UI Value
fold_v:Button('Reset', function()
    hum.WalkSpeed = base_wk
    hum.JumpPower = base_jp
end)
fold_v:Button('Apply Values', function()
    hum.WalkSpeed = getgenv().WK
    hum.JumpPower = getgenv().JP
end)
fold_v:Slider('WalkSpeed', {min = 0; max = 500; precise = false}, function(val)
    getgenv().WK = val
end)
fold_v:Slider('JumpPower', {min = 0; max = 500; precise = false}, function(val)
    getgenv().JP = val
end)

--UI Index Hooking
fold_ih:Button('WalkSpeed', function()
    local old = nil
    old = hookmetamethod(hum, '__index', function(obj, property)
        if not checkcaller() then
            if tostring(obj) == 'Humanoid' and tostring(property) == 'WalkSpeed' then
                return base_wk
            end
        end
        return old(obj, property)
    end)
end)
fold_ih:Button('JumpPower', function()
    local old = nil
    old = hookmetamethod(hum, '__index', function(obj, property)
        if not checkcaller() then
            if tostring(obj) == 'Humanoid' and tostring(property) == 'JumpPower' then
                return base_jp
            end
        end
        return old(obj, property)
    end)
end)

--UI NewIndex Hooking
fold_ah:Button('WalkSpeed', function()
    local old = nil
    old = hookmetamethod(hum, '__newindex', function(obj, property, newval)
        if not checkcaller() then
            if tostring(obj) == 'Humanoid' and tostring(property) == 'WalkSpeed' then
                return nil
            end
        end
        return old(obj, property, newval)
    end)
end)
fold_ah:Button('JumpPower', function()
    local old = nil
    old = hookmetamethod(hum, '__newindex', function(obj, property, newval)
        if not checkcaller() then
            if tostring(obj) == 'Humanoid' and tostring(property) == 'JumpPower' then
                return nil
            end
        end
        return old(obj, property, newval)
    end)
end)

--UI AntiKick
fold_AK:Button('Anti-Kick', function()
    local old = nil
    old = hookmetamethod(player, '__namecall', function(obj, ...)
        local mthd = getnamecallmethod()
        if tostring(mthd) == 'Kick' then
            return nil
        end
        return old(obj, ...)
    end)
end)