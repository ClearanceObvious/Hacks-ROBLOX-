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
function get_keys(dict)
    local keys = {}
    for i, v in pairs(dict) do
        keys[#keys+1] = i
    end
    return keys
end

--Boot
local lib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local hwnd = lib:MakeWindow {
    Name = 'Enviroment v1.3b', --1.3 beta
    HidePremium = false,
    SaveConfig = false,
    ConfigFolder = ''
}


--Global Variables
_G.TargetScript = nil
_G.SCRIPT = {}
_G.EnviromentType = getgc
_G.MOutput = 'Output'

_G.OutputType = debug.getconstants
_G.CurrentFunction = nil
_G.LOutput = 'Output'

_G.IOutput = 'Output'
_G.InputType = debug.setconstant
_G.CurrentFunctionOUT = nil
_G.INDEX = 1
_G.VALUE = ''


--Main tab
local tab = hwnd:MakeTab {
    Name = 'Main',
    Icon = '',
    PremiumOnly = false
}

--Target Function
tab:AddTextbox {
    Name = 'Target Script',
    Default = '',
    TextDisappear = false,
    Callback = function(val)
        _G.TargetScript = 'a = ' .. tostring(val)
    end
}

--Enviroment Choice (registry / garbage collector)
tab:AddDropdown {
    Name = 'Enviroment Type',
    Default = 'Garbage Collector',
    Options = {'Garbage Collector', 'Registry'},
    Callback = function(val)
        if val == 'Garbage Collector' then
            _G.EnviromentType = getgc
        elseif val == 'Registry' then
            _G.EnviromentType = getreg
        end
    end
}

--Functionality Button
local _output = tab:AddLabel('Output')
tab:AddButton {
    Name = 'Search',
    Callback = function()
        xpcall(function()
            if _G.TargetScript and _G.EnviromentType then
                local fft = loadstring(tostring(_G.TargetScript))
                local src = debug.getconstants(fft)[#debug.getconstants(fft)-1]
                _G.SCRIPT = search_funcs(src, _G.EnviromentType())
                if not tostring(src.ClassName) == 'LocalScript' then
                    _G.MOuput = 'No Local Script Found'
                else
                    local found = search_funcs(src, _G.EnviromentType())
                    _G.MOuput = 'Functions found: ' .. tostring(#found)
                end
            else
                _G.MOuput = 'No Target Script found'
            end
        end, function()
            _G.MOuput = 'Unknown Error Occured'
        end)
        _output:Set(tostring(_G.MOuput))
    end
}


--Output Tab
local tab_output = hwnd:MakeTab {
    Name = 'Output',
    Icon = '',
    PremiumOnly = false
}

--Output Type
tab_output:AddDropdown {
    Name = 'Type',
    Default = 'Constants',
    Options = {'Constants', 'Upvalues'},
    Callback = function(val)
        if val == 'Constants' then
            _G.OutputType = debug.getconstants
        elseif val == 'Upvalues' then
            _G.OutputType = debug.getupvalues
        end
    end
}

--Functions
local _functions = tab_output:AddDropdown {
    Name = 'Current Function',
    Default = '',
    Options = get_keys(_G.SCRIPT),
    Callback = function(val)
        for i, v in pairs((_G.SCRIPT)) do
            if i == val then
                _G.CurrentFunction = v
                break
            end
        end
    end
}
tab_output:AddButton {
    Name = 'Refresh',
    Callback = function()
        _functions:Refresh(get_keys(_G.SCRIPT), true)
    end
}

--Outputting
local _loutput = tab_output:AddLabel(_G.LOutput)
tab_output:AddButton {
    Name = 'Search',
    Callback = function()
        if _G.CurrentFunction then
            search_env(_G.CurrentFunction, _G.OutputType, true)
            _G.LOutput = 'Successfully Searched'
        else
            _G.LOutput = 'No Script Available'
        end
        _loutput:Set(_G.LOutput)
    end
}


--Input Tab
local tab_input = hwnd:MakeTab {
    Name = 'Input',
    Icon = '',
    PremiumOnly = false
}
tab_input:AddDropdown {
    Name = 'Type',
    Default = 'Constants',
    Options = {'Constants', 'Upvalues'},
    Callback = function(val)
        if val == 'Constants' then
            _G.InputType = debug.setconstant
        elseif val == 'Upvalues' then
            _G.InputType = debug.setupvalue
        end
    end
}
local out_functions = tab_input:AddDropdown {
    Name = 'Current Function',
    Default = '',
    Options = get_keys(_G.SCRIPT),
    Callback = function(val)
        for i, v in pairs((_G.SCRIPT)) do
            if i == val then
                _G.CurrentFunctionOUT = v
                break
            end
        end
    end
}
local to_change = tab_input:AddDropdown {
    Name = 'Current Index',
    Default = '',
    Options = {},
    Callback = function(val)
        _G.INDEX = val
    end
}
tab_input:AddButton {
    Name = 'Refresh',
    Callback = function()
        pcall(function()
            out_functions:Refresh(get_keys(_G.SCRIPT), true)
            to_change:Refresh(get_keys(search_env(_G.CurrentFunctionOUT, _G.OutputType, false)), true)
        end)
    end
}
tab_input:AddTextbox {
    Name = 'Value',
    Default = '',
    TextDisappear = true,
    Callback = function(val)
        _G.VALUE = val
    end
}
local _ioutput = tab_input:AddLabel(_G.IOutput)
tab_input:AddButton {
    Name = 'Change',
    Callback = function()
        if _G.CurrentFunction then
            if _G.InputType == debug.setconstant then
                if tostring(type(debug.getconstant(_G.CurrentFunctionOUT, _G.INDEX))) == 'number' then
                    _G.VALUE = tonumber(_G.VALUE)
                end
            end
            if _G.InputType == debug.setupvalue then
                if tostring(type(debug.getupvalue(_G.CurrentFunctionOUT, _G.INDEX))) == 'number' then
                    _G.VALUE = tonumber(_G.VALUE)
                end
            end
            _G.InputType(_G.CurrentFunctionOUT, _G.INDEX, _G.VALUE)
            _G.IOutput = 'Successfully Changed'
        else
            _G.IOutput = 'No Script Available'
        end
        _ioutput:Set(_G.IOutput)
    end
}