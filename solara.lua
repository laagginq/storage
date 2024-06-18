--[[ hello very cool incognito / solara (mostly incognito because solara has most of these functions, just not all) btw please showcase this script and make sure to join https://discord.gg/BkTebksHgr for more scripts like these!! 
pls dont steal source code :( ]]
local bit = bit32
function ToEnum(a)
 for i, v in pairs(Enum.KeyCode:GetEnumItems()) do if tostring(v) == a then return v end end
end
local Functions = {}
local keys={[0x08]=Enum.KeyCode.Backspace,[0x09]=Enum.KeyCode.Tab,[0x0C]=Enum.KeyCode.Clear,[0x0D]=Enum.KeyCode.Return,[0x10]=Enum.KeyCode.LeftShift,[0x11]=Enum.KeyCode.LeftControl,[0x12]=Enum.KeyCode.LeftAlt,[0x13]=Enum.KeyCode.Pause,[0x14]=Enum.KeyCode.CapsLock,[0x1B]=Enum.KeyCode.Escape,[0x20]=Enum.KeyCode.Space,[0x21]=Enum.KeyCode.PageUp,[0x22]=Enum.KeyCode.PageDown,[0x23]=Enum.KeyCode.End,[0x24]=Enum.KeyCode.Home,[0x2D]=Enum.KeyCode.Insert,[0x2E]=Enum.KeyCode.Delete,[0x30]=Enum.KeyCode.Zero,[0x31]=Enum.KeyCode.One,[0x32]=Enum.KeyCode.Two,[0x33]=Enum.KeyCode.Three,[0x34]=Enum.KeyCode.Four,[0x35]=Enum.KeyCode.Five,[0x36]=Enum.KeyCode.Six,[0x37]=Enum.KeyCode.Seven,[0x38]=Enum.KeyCode.Eight,[0x39]=Enum.KeyCode.Nine,[0x41]=Enum.KeyCode.A,[0x42]=Enum.KeyCode.B,[0x43]=Enum.KeyCode.C,[0x44]=Enum.KeyCode.D,[0x45]=Enum.KeyCode.E,[0x46]=Enum.KeyCode.F,[0x47]=Enum.KeyCode.G,[0x48]=Enum.KeyCode.H,[0x49]=Enum.KeyCode.I,[0x4A]=Enum.KeyCode.J,[0x4B]=Enum.KeyCode.K,[0x4C]=Enum.KeyCode.L,[0x4D]=Enum.KeyCode.M,[0x4E]=Enum.KeyCode.N,[0x4F]=Enum.KeyCode.O,[0x50]=Enum.KeyCode.P,[0x51]=Enum.KeyCode.Q,[0x52]=Enum.KeyCode.R,[0x53]=Enum.KeyCode.S,[0x54]=Enum.KeyCode.T,[0x55]=Enum.KeyCode.U,[0x56]=Enum.KeyCode.V,[0x57]=Enum.KeyCode.W,[0x58]=Enum.KeyCode.X,[0x59]=Enum.KeyCode.Y,[0x5A]=Enum.KeyCode.Z,[0x5D]=Enum.KeyCode.Menu,[0x60]=Enum.KeyCode.KeypadZero,[0x61]=Enum.KeyCode.KeypadOne,[0x62]=Enum.KeyCode.KeypadTwo,[0x63]=Enum.KeyCode.KeypadThree,[0x64]=Enum.KeyCode.KeypadFour,[0x65]=Enum.KeyCode.KeypadFive,[0x66]=Enum.KeyCode.KeypadSix,[0x67]=Enum.KeyCode.KeypadSeven,[0x68]=Enum.KeyCode.KeypadEight,[0x69]=Enum.KeyCode.KeypadNine,[0x6A]=Enum.KeyCode.KeypadMultiply,[0x6B]=Enum.KeyCode.KeypadPlus,[0x6D]=Enum.KeyCode.KeypadMinus,[0x6E]=Enum.KeyCode.KeypadPeriod,[0x6F]=Enum.KeyCode.KeypadDivide,[0x70]=Enum.KeyCode.F1,[0x71]=Enum.KeyCode.F2,[0x72]=Enum.KeyCode.F3,[0x73]=Enum.KeyCode.F4,[0x74]=Enum.KeyCode.F5,[0x75]=Enum.KeyCode.F6,[0x76]=Enum.KeyCode.F7,[0x77]=Enum.KeyCode.F8,[0x78]=Enum.KeyCode.F9,[0x79]=Enum.KeyCode.F10,[0x7A]=Enum.KeyCode.F11,[0x7B]=Enum.KeyCode.F12,[0x90]=Enum.KeyCode.NumLock,[0x91]=Enum.KeyCode.ScrollLock,[0xBA]=Enum.KeyCode.Semicolon,[0xBB]=Enum.KeyCode.Equals,[0xBC]=Enum.KeyCode.Comma,[0xBD]=Enum.KeyCode.Minus,[0xBE]=Enum.KeyCode.Period,[0xBF]=Enum.KeyCode.Slash,[0xC0]=Enum.KeyCode.Backquote,[0xDB]=Enum.KeyCode.LeftBracket,[0xDD]=Enum.KeyCode.RightBracket,[0xDE]=Enum.KeyCode.Quote}
local funcs, names = {}, {}
local c = 1

local vim = game:GetService('VirtualInputManager');
function _BLANK() end
function DescendantCount(tbl)
    local count = 0
    if type(tbl) ~= 'table' then 
        return 1 
    end
    for _, v in pairs(tbl) do
        count = count + 1
        if type(v) == 'table' then
            count = count + DescendantCount(v)
        end
    end
    return count
end


function Descendants(tbl)
    local descendants = {}
    
    local function process_table(subtbl, prefix)
        for k, v in pairs(subtbl) do
            local index = prefix and (prefix .. "." .. tostring(k)) or tostring(k)
            descendants[index] = v  -- Include the table itself
            if type(v) == 'table' then
                process_table(v, index)
            else
                descendants[index] = v
            end
        end
    end

    if type(tbl) ~= 'table' then
        descendants[tostring(1)] = tbl
    else
        process_table(tbl, nil)
    end
    
    return descendants
end




local Debug = loadstring(game:HttpGet('https://rawscripts.net/raw/Universal-Script-Basic-Functions-12707'))()

--[[ Libraries ]]


funcs.base64 = {}
funcs.crypt = {hex={},url={}}
funcs.syn = {}
funcs.syn_backup = {}
funcs.http = {}
funcs.Drawing = {}
funcs.Vector2 = table.clone(Vector2) -- [[ Extra vector2 functions for scaling. ]]

funcs.Drawing.Fonts = {
  ['UI'] = 0,
  ['System'] = 1,
  ['Plex'] = 2,
  ['Monospace'] = 3
}
local Fonts = {
 [0] = Enum.Font.Arial,
 [1] = Enum.Font.BuilderSans,
 [2] = Enum.Font.Gotham,
 [3] = Enum.Font.RobotoMono
}

local drawingHistory = {}
local DrawingDict = Instance.new("ScreenGui")

-- [[ Functions ]]
funcs.Vector2.rel = function(x, y)
 local size = workspace.CurrentCamera.ViewportSize
 return Vector2.new(size.X * x, size.Y * y)
end
funcs.Vector2.relx = function(x)
 return workspace.CurrentCamera.ViewportSize.X * x
end
funcs.Vector2.rely = function(y)
 return workspace.CurrentCamera.ViewportSize.Y * y
end
funcs.Vector2.fromRel = funcs.Vector2.rel
funcs.Vector2.scale = funcs.Vector2.rel
funcs.Vector2.fromScale = funcs.Vector2.rel

funcs.clonefunction = function(a)
 return function(...)
  return a(...)
 end
end
funcs.cloneref = function(a) -- [[ Not a real cloneref but works]
 local s, _ = pcall(function() return a:Clone() end) return s and _ or a
end
funcs.deepclone = function(a)
 local Result = {}
 for i, v in pairs(a) do
  if type(v) == 'table' then
    Result[i] = funcs.deepclone(v)
  end
  Result[i] = v
 end
 return Result
end
getgenv = getgenv or getfenv(2)
function SafeOverride(a, b, c) --[[ Index, Data, Should override ]]
 if getgenv()[a] and not c then return 1 end
 getgenv()[a] = b
 return 2
end
--[[ The base64 functions were made by https://scriptblox.com/u/yofriendfromschool1 , Credits to him.]]
funcs.base64.encode = function(data)
    local letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return letters:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end
funcs.base64.decode = function(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if x == '=' then return '' end
        local r, f = '', (b:find(x) - 1)
        for i = 6, 1, -1 do
            r = r .. (f % 2^i - f % 2^(i - 1) > 0 and '1' or '0')
        end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if #x ~= 8 then return '' end
        local c = 0
        for i = 1, 8 do
            c = c + (x:sub(i, i) == '1' and 2^(8 - i) or 0)
        end
        return string.char(c)
    end))
end

funcs.loadstring = loadstring
funcs.getgenv = getgenv
funcs.crypt.base64 = funcs.base64
funcs.crypt.base64encode = funcs.base64.encode
funcs.crypt.base64decode = funcs.base64.decode
funcs.crypt.base64_encode = funcs.base64.encode
funcs.crypt.base64_decode = funcs.base64.decode
funcs.base64_encode = funcs.base64.encode
funcs.base64_decode = funcs.base64.decode

funcs.crypt.hex.encode = function(txt)
 txt = tostring(txt)
 local hex = ''
 for i = 1, #txt do
    hex = hex .. string.format("%02x", string.byte(txt, i))
 end
 return hex
end
funcs.crypt.hex.decode = function(hex)
    hex = tostring(hex)
    local text = ""
    for i = 1, #hex, 2 do
        local byte_str = string.sub(hex, i, i+1)
        local byte = tonumber(byte_str, 16)
        text = text .. string.char(byte)
    end
    return text
end
funcs.crypt.url.encode = function(a)
 return game:GetService("HttpService"):UrlEncode(a)
end
funcs.crypt.url.decode = function(a)
    a = tostring(a)
    a = string.gsub(a, "+", " ")
    a = string.gsub(a, "%%(%x%x)", function(hex)
        return string.char(tonumber(hex, 16))
    end)
    a = string.gsub(a, "\r\n", "\n")
    return a
end
funcs.crypt.generatekey = function(optionalSize)
 local key = ''
 local a = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
 for i = 1, optionalSize or 32 do local n = math.random(1, #a) key = key .. a:sub(n, n) end
 return funcs.base64.encode(key)
end
funcs.crypt.generatebytes = function(size)
 if type(size) ~= 'number' then return error('missing arguement #1 to \'generatebytes\' (number expected)') end
 return funcs.crypt.generatekey(size)
end
--[[ Basic XOR encryption because i don't know wtf synapse uses for crypt.encrypt ]]
funcs.crypt.encrypt = function(a, b)
 local result = {}
 a = tostring(a) b = tostring(b)
 for i = 1, #a do
    local byte = string.byte(a, i)
    local keyByte = string.byte(b, (i - 1) % #b + 1)
    table.insert(result, string.char(bit32.bxor(byte, keyByte)))
 end
 return table.concat(result)
end
funcs.crypt.decrypt = funcs.crypt.encrypt
funcs.crypt.random = function(len)
 assert(type(len)~='number', 'invalid arguement #1 to \'random\', number expected got ' .. type(len))
 return funcs.crypt.generatekey(len)
end

local active = true
game:GetService("UserInputService").WindowFocused:Connect(function()
 active = true
end)

game:GetService("UserInputService").WindowFocusReleased:Connect(function()
 active = false
end)

funcs.isrbxactive = function()
 return active
end
funcs.isgameactive = funcs.isrbxactive
funcs.gethui = function()
 local s, H = pcall(function()
  return game:GetService("CoreGui")
 end)
 return s and H or game:GetService("Players").LocalPlayer.PlayerGui
end
funcs.setclipboard = function(data)
    local old = game:GetService("UserInputService"):GetFocusedTextBox()
    local copy = tostring(data)
    local gui = Instance.new("ScreenGui", getgenv().gethui())
    local a = Instance.new('TextBox', gui)
    a.PlaceholderText = ''
    a.Text = copy
    a.ClearTextOnFocus = false
    a.Size = UDim2.new(.1, 0, .15, 0)
    a.Position = UDim2.new(10, 0, 10, 0)
    a:CaptureFocus()
    a = Enum.KeyCode
    local Keys = {
     a.RightControl, a.A
    }
    local Keys2 = {
     a.RightControl, a.C, a.V
    }
    for i, v in ipairs(Keys) do
     vim:SendKeyEvent(true, v, false, game)
     task.wait()
    end
    for i, v in ipairs(Keys) do
     vim:SendKeyEvent(false, v, false, game)
     task.wait()
    end
    for i, v in ipairs(Keys2) do
     vim:SendKeyEvent(true, v, false, game)
     task.wait()
    end
    for i, v in ipairs(Keys2) do
     vim:SendKeyEvent(false, v, false, game)
     task.wait()
    end
    gui:Destroy()
    if old then old:CaptureFocus() end
end
funcs.syn.write_clipboard = funcs.setclipboard
funcs.toclipboad = funcs.setclipboard
funcs.setrbxclipboard = funcs.setclipboard

funcs.syn.protect_gui = function(gui) -- Does not actually protect it, just parents to gethui and renames the gui to a roblox gui.
 names[gui] = {name=gui.Name,parent=gui.Parent}
 if getgenv().gethui() == game:GetService("Players").LocalPlayer.PlayerGui then
  gui.Name = 'Chat'
 else
  gui.Name = 'RobloxGui'
 end
 gui.Parent = getgenv().gethui()
end
funcs.syn.unprotect_gui = function(gui)
 if names[gui] then gui.Name = names[gui].name gui.Parent = names[gui].parent end
end
funcs.syn.secure_call = function(func) -- Does not do a secure call, just pcalls it.
 return pcall(func)
end


funcs.isreadonly = function(tbl)
 if type(tbl) ~= 'table' then return false end
 return table.isfrozen(tbl)
end
funcs.setreadonly = function(tbl, cond)
 if cond then
  table.freeze(tbl)
 else
  return funcs.deepclone(tbl)
 end
end
funcs.httpget = function(url)
 return game:HttpGet(url)
end
funcs.httppost = function(url, body, contenttype)
 return game:HttpPostAsync(url, body, contenttype)
end
funcs.request = function(args)
 if args.Method == 'GET' then
  local result = {}
  local s, getresult = pcall(function() return funcs.httpget(args.Url) end)
  result.Body = s and getresult or ''
  result.Success = s
  result.StatusCode = s and 200 or 400 -- Inaccurate but works i guess?
  return result
 elseif args.Method == 'POST' then
  local result = {}
  local s, r = pcall(function() return funcs.httppost(args.Url, args.Body or '', args.Headers and args.Headers['Content-Type'] and args.Headers['Content-Type'] or 'application/x-www-form-urlencoded') end)
  result.Success = s
  result.Body = r
  result.StatusCode = s and 200 or 400 -- Inaccurate but works i guess?
  return result
 else
  print('script tried to send an http request with a non implemented method',args.Method)
  return {Success=false,StatusCode=404} -- 404 means not found which can cause some errors in scripts.
 end
end
funcs.newcclosure = function(func) -- This is a horrible attempt at making newcclosure but it is practically impossible in luau (or so i think)
 return function(...)
  func(...)
 end
end
funcs.mouse1click = function(x, y)
 x = x or 0
 y = y or 0
 vim:SendMouseButtonEvent(x, y, 0, true, game, false)
 task.wait()
 vim:SendMouseButtonEvent(x, y, 0, false, game, false)
end
funcs.mouse2click = function(x, y)
 x = x or 0
 y = y or 0
 vim:SendMouseButtonEvent(x, y, 1, true, game, false)
 task.wait()
 vim:SendMouseButtonEvent(x, y, 1, false, game, false)
end
funcs.mouse1press = function(x, y)
 x = x or 0
 y = y or 0
 vim:SendMouseButtonEvent(x, y, 0, true, game, false)
end
funcs.mouse1release = function(x, y)
 x = x or 0
 y = y or 0
 vim:SendMouseButtonEvent(x, y, 0, false, game, false)
end
funcs.mouse2press = function(x, y)
 x = x or 0
 y = y or 0
 vim:SendMouseButtonEvent(x, y, 1, true, game, false)
end
funcs.mouse2release = function(x, y)
 x = x or 0
 y = y or 0
 vim:SendMouseButtonEvent(x, y, 1, false, game, false)
end
funcs.mousescroll = function(x, y, a)
 x = x or 0
 y = y or 0
 a = a and true or false
 vim:SendMouseWheelEvent(x, y, a, game)
end
funcs.keyclick = function(key)
 if typeof(key) == 'number' then
 if not keys[key] then return error("Key "..tostring(key) .. ' not found!') end
 vim:SendKeyEvent(true, keys[key], false, game)
 task.wait()
 vim:SendKeyEvent(false, keys[key], false, game)
 elseif typeof(Key) == 'EnumItem' then
  vim:SendKeyEvent(true, key, false, game)
  task.wait()
  vim:SendKeyEvent(false, key, false, game)
 end
end
funcs.keypress = function(key)
 if typeof(key) == 'number' then
 if not keys[key] then return error("Key "..tostring(key) .. ' not found!') end
 vim:SendKeyEvent(true, keys[key], false, game)
 elseif typeof(Key) == 'EnumItem' then
  vim:SendKeyEvent(true, key, false, game)
 end
end
funcs.keyrelease = function(key)
 if typeof(key) == 'number' then
 if not keys[key] then return error("Key "..tostring(key) .. ' not found!') end
 vim:SendKeyEvent(false, keys[key], false, game)
 elseif typeof(Key) == 'EnumItem' then
  vim:SendKeyEvent(false, key, false, game)
 end
end
funcs.mousemoverel = function(relx, rely)
 local Pos = workspace.CurrentCamera.ViewportSize
 relx = relx or 0
 rely = rely or 0
 local x = Pos.X * relx
 local y = Pos.Y * rely
 vim:SendMouseMoveEvent(x, y, game)
end
funcs.mousemoveabs = function(x, y)
 x = x or 0 y = y or 0
 vim:SendMouseMoveEvent(x, y, game)
end

funcs.isexecutorclosure = function(fnc)
 return Functions[fnc] and true or false
end

--[[ File system is something i do not know how to implement in roblox lua.
UPDATE AT 18/5/2024:
I figured out i can use temp file system.
]]
local files = {}

local function MakeFile(name, content)
    local Folders = name:split('/')
    local FileName = table.remove(Folders)
    local currentFolder = files
    
    for _, FolderName in ipairs(Folders) do
        if not currentFolder[FolderName] then
            currentFolder[FolderName] = {}
        end
        currentFolder = currentFolder[FolderName]
    end
    
    currentFolder[FileName] = content
end

local function getPath(name)
    local Folders = name:split('/')
    local currentFolder = files
    
    for _, FolderName in ipairs(Folders) do
        currentFolder = currentFolder[FolderName]
        if not currentFolder then
            return nil
        end
    end
    
    return currentFolder
end

funcs.writefile = function(name, content)
    local success, err = pcall(function()
        name = tostring(name)
        content = tostring(content)
        MakeFile(name, content)
    end)
    if not success then error('file error: ' .. err) end
end

funcs.makefolder = function(name)
    local success, err = pcall(function()
        name = tostring(name)
        MakeFile(name, {})
    end)
    if not success then error('file error: ' .. err) end
end

funcs.readfile = function(name)
    local Folders = name:split('/')
    local FileName = table.remove(Folders)
    local currentFolder = files
    
    for _, FolderName in ipairs(Folders) do
        currentFolder = currentFolder[FolderName]
        if not currentFolder then
            return nil
        end
    end
    
    return currentFolder[FileName]
end

funcs.delfile = function(name)
    local success, err = pcall(function()
        local Folders = name:split('/')
        local FileName = table.remove(Folders)
        local currentFolder = files
        
        for _, FolderName in ipairs(Folders) do
            currentFolder = currentFolder[FolderName]
            if not currentFolder then
                return
            end
        end
        
        currentFolder[FileName] = nil
    end)
    if not success then error('file error: ' .. err) end
end

funcs.delfolder = function(name)
    local success, err = pcall(function()
        local Folders = name:split('/')
        local FolderName = table.remove(Folders)
        local currentFolder = files
        
        for _, FolderName in ipairs(Folders) do
            currentFolder = currentFolder[FolderName]
            if not currentFolder then
                return
            end
        end
        
        currentFolder[FolderName] = nil
    end)
    if not success then error('folder error: ' .. err) end
end

funcs.isfile = function(name)
    local path = getPath(name)
    return path ~= nil and type(path) ~= "table"
end

funcs.isfolder = function(name)
    local path = getPath(name)
    return path ~= nil and type(path) == "table"
end

funcs.listfiles = function(path)
    if path and path:sub(-1) == '/' then
        path = path:sub(1, -2)
    end

    local updated = {}
    local Files = path and getPath(path) or files
    
    if Files and type(Files) == "table" then
        for i, v in pairs(Files) do
            if v ~= nil then
                table.insert(updated, i)
            end
        end
    end
    
    return updated
end

funcs.loadfile = function(path)
    local fileContent = funcs.readfile(path)
    if fileContent then
        return loadstring(fileContent)
    else
        return error('file not found: ' .. path)
    end
end

funcs.appendfile = function(name, extra)
    local content = funcs.readfile(name)
    if content then
        MakeFile(name, content .. tostring(extra))
    else
        error('file not found: ' .. name)
    end
end


funcs.http.request = funcs.request
funcs.syn.crypt = funcs.crypt
funcs.syn.crypto = funcs.crypt
funcs.syn_backup = funcs.syn


funcs.getexecutorname = function()
 return 'MoreUNC', 1
end
funcs.identifyexecutor = funcs.getexecutorname
funcs.http_request = getgenv().request or funcs.request
funcs.getscripts = function()
 local a = {};for i, v in pairs(game:GetDescendants()) do if v:IsA("LocalScript") or v:IsA("ModuleScript") then table.insert(a, v) end end return a
end
funcs.get_scripts = function()
 local a = {};for i, v in pairs(game:GetDescendants()) do if v:IsA("LocalScript") or v:IsA("ModuleScript") then table.insert(a, v) end end return a
end
funcs.getmodules = function()
 local a = {};for i, v in pairs(game:GetDescendants()) do if v:IsA("ModuleScript") then table.insert(a, v) end end return a
end
funcs.make_readonly = funcs.setreadonly
funcs.makereadonly = funcs.setreadonly
funcs.base64encode = funcs.crypt.base64encode
funcs.base64decode = funcs.crypt.base64decode
funcs.clonefunc = funcs.clonefunction
funcs.getinstances = function()
 return game:GetDescendants()
end
funcs.iswriteable = function(tbl)
 return not table.isfrozen(tbl)
end
funcs.makewriteable = function(tbl)
 return
