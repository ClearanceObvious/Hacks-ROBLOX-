VERSION = 'v0.7a'

--Local Variables
local player = game.Players.LocalPlayer
local players = game.Players:GetPlayers()
local camera = workspace.CurrentCamera
local viewport = camera.ViewportSize

local espColor = Color3.fromRGB(255, 255, 255)
local selectedType = 'Line'

local selectedDistance = 100

local sobj = {}

--Global Variables
_G.ShowEsp = false
_G.ShowAim = false


--Functions     [S Synapse Utlity ; U User Interface]
function SFlushEsp()
    players = game.Players:GetPlayers()
    for i, v in pairs(sobj) do
        v:Remove()
    end
    sobj = {}
end
function SRunEsp()
    --Flushing
    SFlushEsp()
    
    --Displaying
    for i, v in pairs(players) do
        xpcall(function()
            if v ~= player and v.Team ~= player.Team and v.Character ~= nil and v.Character.HumanoidRootPart ~= nil and v.Character.Head ~= nil then
                local off = {
                    head = Vector3.new(0, 0.2, 0),
                    leg = Vector3.new(0, 3, 0)
                }
                local vec, onscreen = camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                local hvec = camera:WorldToScreenPoint(v.Character.Head.Position + off.head)
                local lvec = camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position - off.leg)
                if onscreen then
                    local ln = Drawing.new(selectedType)
                    ln.Visible = true
                    ln.ZIndex = -1
                    ln.Transparency = 1
                    ln.Color = espColor
                    ln.Thickness = 3
                    
                    if selectedType == 'Line' then
                        ln.From = Vector2.new(viewport.X / 2, viewport.Y)
                        ln.To = Vector2.new(vec.X, vec.Y - (hvec.Y - lvec.Y) / 2)
                    elseif selectedType == 'Square' then
                        ln.Size = Vector2.new(viewport.X / vec.Z, hvec.Y - lvec.Y)
                        ln.Position = Vector2.new(vec.X - ln.Size.X / 2, vec.Y - ln.Size.Y + off.head.Y)
                    end
                    
                    sobj[i] = ln
                end
            end
        end, function()
            SFlushEsp()
        end)
    end
end
function SGetClosestPlayer()
    players = game.Players:GetPlayers()
    
    local closestDist, closestPlr = selectedDistance, nil
    for i, v in pairs(players) do
        if v ~= player and v.Team ~= player.Team and v.Character ~= nil and v.Character.HumanoidRootPart ~= nil then
            local dist = (player.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if dist < closestDist then
                closestDist = dist
                closestPlr = v.Character
            end
        end
    end
    return closestPlr
end
function SRunAim()
    local closest = SGetClosestPlayer()
    pcall(function()
        local vec, ons = camera:WorldToScreenPoint(closest.HumanoidRootPart.Position)
        if ons and closest.Head ~= nil then
            camera.CFrame = CFrame.lookAt(camera.CFrame.Position, closest.Head.Position)
        end
    end)
end

function UToggleESP()
    _G.ShowEsp = not _G.ShowEsp
    SFlushEsp()
end
function UDropdownESP(val)
    selectedType = val
    SFlushEsp()
end
function UColor(val)
    espColor = val
end
function UToggleAim()
    _G.ShowAim = not _G.ShowAim
end
function UDistance(val)
    pcall(function()
        selectedDistance = tonumber(val)
    end)
end


--Main Thread
task.spawn(function()
    while task.wait() do
        --Refreshing
        SFlushEsp()
        
        if _G.ShowEsp then
            SRunEsp()
        end
        if _G.ShowAim then
            SRunAim()
        end
    end
end)


--UI Bootup
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local hwnd = OrionLib:MakeWindow {
    Name = 'Arsenal'
}
OrionLib:MakeNotification {
    Name = 'Arsenal ' .. VERSION,
    Content = 'Welcome Back',
    Time = 5
}


--Tab Initializations
local tWorld = hwnd:MakeTab {
    Name = 'World'
}


--World Tab
tWorld:AddLabel 'ESP [Wallhack]'
tWorld:AddBind {
    Name = 'Toggle ESP',
    Default = Enum.KeyCode.E,
    Hold = false,
    Callback = UToggleESP
}
tWorld:AddDropdown {
    Name = 'ESP Type',
    Default = 'Line',
    Options = {'Line', 'Square'},
    Callback = UDropdownESP
}
tWorld:AddColorpicker{
	Name = "ESP Color",
	Default = Color3.fromRGB(255, 255, 255),
	Callback = UColor
}

tWorld:AddLabel 'Aimbot'
tWorld:AddBind {
    Name = 'Toggle Aim',
    Default = Enum.KeyCode.Z,
    Hold = false,
    Callback = UToggleAim
}
tWorld:AddTextbox {
    Name = 'Distance',
    Default = selectedDistance,
    Callback = UDistance
}

--Initialization
OrionLib:Init()