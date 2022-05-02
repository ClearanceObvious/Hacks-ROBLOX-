--Boot
local lib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local hwnd = lib:MakeWindow {
    Name = 'Prison Life v0.1a'
}


--Local Variables
local player = game.Players.LocalPlayer
local _char = player.Character
local hum = _char.Humanoid or _char:WaitForChild('Humanoid')
hum.UseJumpPower = true

local def_wk = hum.WalkSpeed
local def_jp = hum.JumpPower

local POLICE = CFrame.new(834, 101.5, 2268)
local PRISON = CFrame.new(919, 101.5, 2376)
local BASE = CFrame.new(-953.4, 95.7, 2047.6)
local YARD = CFrame.new(803, 99.5, 2451)


--Local Tab
local tab_local = hwnd:MakeTab {
    Name = 'Local',
    Icon = '',
    PremiumOnly = false
}
s_wk = tab_local:AddSlider {
    Name = 'WalkSpeed',
    Min = 0,
    Max = 200,
    Default = def_wk,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = 'Velocity',
    Callback = function(val)
        _char = player.Character
        hum = _char.Humanoid or _char:WaitForChild('Humanoid')
        hum.WalkSpeed = val
    end
}
s_jp = tab_local:AddSlider {
    Name = 'Jump Power',
    Min = 0,
    Max = 200,
    Default = def_jp,
    Color = Color3.fromRGB(255,255,255),
    Increment = 1,
    ValueName = 'High',
    Callback = function(val)
        _char = player.Character
        hum = _char.Humanoid or _char:WaitForChild('Humanoid')
        hum.JumpPower = val
    end
}
tab_local:AddButton {
    Name = 'Reset [To Default]',
    Callback = function()
        s_wk:Set(def_wk)
        s_jp:Set(def_jp)
    end
}


--Weapons Tab
local tab_guns = hwnd:MakeTab {
    Name = 'Guns',
    Icon = '',
    PremiumOnly = false
}
tab_guns:AddButton {
    Name = 'Pistol',
    Callback = function()
        local arg = workspace.Prison_ITEMS.giver:FindFirstChild('M9').ITEMPICKUP
        workspace.Remote.ItemHandler:InvokeServer(arg)
    end
}
tab_guns:AddButton {
    Name = 'AK-47',
    Callback = function()
        local arg = workspace.Prison_ITEMS.giver:FindFirstChild('AK-47').ITEMPICKUP
        workspace.Remote.ItemHandler:InvokeServer(arg)
    end
}
tab_guns:AddButton {
    Name = 'Shotgun',
    Callback = function()
        local arg = workspace.Prison_ITEMS.giver:FindFirstChild('Remington 870').ITEMPICKUP
        workspace.Remote.ItemHandler:InvokeServer(arg)
    end
}


--Teleport Tab
local tab_teleports = hwnd:MakeTab {
    Name = 'Teleports',
    Icon = '',
    PremiumOnly = false
}
tab_teleports:AddButton {
    Name = 'Criminal Base',
    Callback = function()
        _char = player.Character
        _char:SetPrimaryPartCFrame(BASE)
    end
}
tab_teleports:AddButton {
    Name = 'Prison',
    Callback = function()
        _char = player.Character
        _char:SetPrimaryPartCFrame(PRISON)
    end
}
tab_teleports:AddButton {
    Name = 'Yard',
    Callback = function()
        _char = player.Character
        _char:SetPrimaryPartCFrame(YARD)
    end
}
tab_teleports:AddButton {
    Name = 'Police',
    Callback = function()
        _char = player.Character
        _char:SetPrimaryPartCFrame(POLICE)
    end
}


--Cars Tab
local tab_cars = hwnd:MakeTab {
    Name = 'Cars',
    Icon = '',
    PremiumOnly = false
}
tab_cars:AddLabel('Coming Soon')