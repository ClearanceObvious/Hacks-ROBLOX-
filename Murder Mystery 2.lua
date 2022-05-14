VERSION = 'v0.4a'

--Local Variables
local player = game.Players.LocalPlayer
local players = game.Players:GetPlayers()
local camera = workspace.CurrentCamera
local viewport = camera.ViewportSize

local espColor = Color3.fromRGB(255, 255, 255)
local selectedType = 'Line'

local sobj = {}

--Global Variables
_G.ShowEsp = false


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
            if v ~= player and v.Character ~= nil and v.Character.HumanoidRootPart ~= nil and v.Character.Head ~= nil then
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


--Main Thread
task.spawn(function()
    while task.wait() do
        --Refreshing
        SFlushEsp()
        
        if _G.ShowEsp then
            SRunEsp()
        end
    end
end)


--UI Bootup
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local hwnd = OrionLib:MakeWindow {
    Name = 'Murder Mystery'
}
OrionLib:MakeNotification {
    Name = 'Murder Mystery ' .. VERSION,
    Content = 'Welcome Back',
    Time = 5
}


--Tab Initializations
local tWorld = hwnd:MakeTab {
    Name = 'World'
}


--World Tab
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

--Initialization
OrionLib:Init()