--NOTE: THIS SCRIPT ONLY WORKS AS EXPECTED WITH NUMBERS. WE WILL MAKE UPDATES FOR MULTIPLE TYPE-SUPPORTS.

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
    Name = 'Enviroment v1.7b', --1.7 beta
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
_G.CurrentFunctionIndex = 1
_G.LOutput = 'Output'

_G.IOutput = 'Output'
_G.InputType = debug.setconstant
_G.CurrentFunctionIN = nil
_G.CurrentFunctionINIndex = 1
_G.INDEX = 1
_G.VALUE = ''

_G.ACTION = 'Input'
_G.COutput = 'Output'
_G.COMPILEOUTPUT = ''
_G.BASECOMPILE = 
[[local syn_f = is_synapse_function
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
end]]


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
                _G.CurrentFunctionIndex = tonumber(i)
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
                _G.CurrentFunctionIN = v
                _G.CurrentFunctionINIndex = i
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
            to_change:Refresh(get_keys(search_env(_G.CurrentFunctionIN, _G.OutputType, false)), true)
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
                if tostring(type(debug.getconstant(_G.CurrentFunctionIN, _G.INDEX))) == 'number' then
                    _G.VALUE = tonumber(_G.VALUE)
                end
            end
            if _G.InputType == debug.setupvalue then
                if tostring(type(debug.getupvalue(_G.CurrentFunctionIN, _G.INDEX))) == 'number' then
                    _G.VALUE = tonumber(_G.VALUE)
                end
            end
            _G.InputType(_G.CurrentFunctionIN, _G.INDEX, _G.VALUE)
            _G.IOutput = 'Successfully Changed'
        else
            _G.IOutput = 'No Script Available'
        end
        _ioutput:Set(_G.IOutput)
    end
}


--Compile Tab
local tab_compile = hwnd:MakeTab {
    Name = 'Compiler',
    Icon = '',
    PremiumOnly = false
}
tab_compile:AddDropdown {
    Name = 'Action',
    Default = 'Input',
    Options = {'Input', 'Output'},
    Callback = function(val)
        _G.ACTION = val
    end
}
local _coutput = tab_compile:AddLabel(_G.COutput)
tab_compile:AddButton {
    Name = 'Compile',
    Callback = function()
        if _G.ACTION == 'Output' then
            if _G.TargetScript and _G.CurrentFunction then
                _G.COMPILEOUTPUT = _G.BASECOMPILE .. '\n\n' .. tostring(_G.TargetScript) .. '\n' .. 
                'local func = search_funcs(a, getreg())\n' ..
                'print("--- CONSTANTS ---")\n' .. 'for i, v in pairs(search_env(func[' .. tostring(_G.CurrentFunctionIndex) .. '], debug.getconstants, false)) do\n' ..
                '   print(i .. " : " .. tostring(v))\nend\n' ..
                'print("--- UPVALUES ---")\n' .. 'for i, v in pairs(search_env(func[' .. tostring(_G.CurrentFunctionIndex) .. '], debug.getupvalues, false)) do\n' ..
                '   print(i .. " : " .. tostring(v))\nend\n'
                
                
                _G.COutput = 'Compilation Success [Copied to Clipboard]'
                setclipboard(_G.COMPILEOUTPUT)
            else
                _G.COutput = 'Error Loading'
            end
        elseif _G.ACTION == 'Input' then
            if _G.TargetScript and _G.CurrentFunctionIN then
                _G.COMPILEOUTPUT = _G.BASECOMPILE .. '\n\n' .. tostring(_G.TargetScript) .. '\n' ..
                'local func = search_funcs(a, getreg())\n'
                if _G.InputType == debug.setconstant then
                   _G.COMPILEOUTPUT = _G.COMPILEOUTPUT .. 'debug.setconstant(func[' .. tostring(_G.CurrentFunctionINIndex) .. '], ' .. tostring(_G.INDEX) .. ', ' .. tostring(_G.VALUE) .. ')\n' ..
                   '\n\n--Printing new value to the screen\n' ..
                   'print(debug.getconstant(func[' .. tostring(_G.CurrentFunctionINIndex) .. '], ' .. _G.INDEX .. '))\n'
                elseif _G.InputType == debug.setupvalue then
                    _G.COMPILEOUTPUT = _G.COMPILEOUTPUT .. 'debug.setupvalue(func[' .. tostring(_G.CurrentFunctionINIndex) .. '], ' .. tostring(_G.INDEX) .. ', ' .. tostring(_G.VALUE) .. '))\n' ..
                   '\n\n--Printing new value to the screen\n' ..
                   'print(debug.getupvalue(func[' .. tostring(_G.CurrentFunctionINIndex) .. '], ' .. _G.INDEX .. '))\n'
                end
                
                _G.COutput = 'Compilation Success [Copied to Clipboard]'
                setclipboard(_G.COMPILEOUTPUT)
            else
                _G.COutput = 'Error Loading'
            end
        end
        _coutput:Set(_G.COutput)
    end
}
