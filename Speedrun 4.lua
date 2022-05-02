--Functions
function beatLevel()
    local args = {
        [1] = 65.54618430137634,
        [2] = "Level 1",
        [3] = "Normal",
        [4] = true
    }
    game:GetService("ReplicatedStorage").BeatLevel:FireServer(unpack(args))
end

--Global Vars
getgenv().AutoBeat = false
getgenv().Cooldown = 0.05

--UI
local library = loadstring(game:HttpGet(('https://raw.githubusercontent.com/AikaV3rm/UiLib/master/Lib.lua')))()
local hwd = library:CreateWindow('Speed Run')
local fold = hwd:CreateFolder('Misc')

--UI functionality
fold:Toggle('Auto Beat', function(bool)
    getgenv().AutoBeat = bool
end)

fold:Slider('Cooldown',{
    min = 0; -- min value of the slider
    max = 3; -- max value of the slider
    precise = true; -- max 2 decimals
}, function(value)
    getgenv().Cooldown = value
end)

fold:DestroyGui()

while task.wait() do
    if getgenv().AutoBeat == true then
        task.wait(getgenv().Cooldown)
        beatLevel()
    end
end