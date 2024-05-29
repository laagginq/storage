local utility = {
    invite = "rbxfanclub",
    camlock = {
        enabled = false,
        rmb = false,
        target = nil,
        key = Enum.KeyCode.C,
        mode = "Camera",
        part = "Head",
        smoothness = 50,
        pred = {
            use = false,
            x = 7,
            y = 7,
        }
    },
    checks = {
        visible = false,
        friend = false,
        distance = false,
        team = false,
    },
    esp = {
        enabled = false,
        dist = 500,
        name = {
           enabled = false,
           outline = false,
           color = Color3.fromRGB(255,255,255)
        },
        box = {
           enabled = false,
           outline = false,
           color = Color3.fromRGB(255,255,255)
        },
        health = {
           enabled = false,
           outline = false,
           color = Color3.fromRGB(0,255,0)
        },
        distance = {
           enabled = false,
           outline = false,
           color = Color3.fromRGB(255,255,255)
        },
    },
    keys = {"C","Q","E","Z","X","F","V","T","CapsLock","LeftAlt"},
}

function deb(text)
    if _G.Debug == true then 
       print("[Alysum]: "..text)
    end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local InputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Gui = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer
local CurrentCamera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
local esp_players = {}

local Circle = Drawing.new("Circle")
Circle.Radius = 50
Circle.Visible = false
Circle.Color = Color3.new(1,1,1)
Circle.Thickness = 1
Circle.NumSides = 25

deb("Variables")

function ConvertKey(KeyInput)
    return Enum.KeyCode[KeyInput]
end

function notify(Text)
    game:GetService("StarterGui"):SetCore("SendNotification",{
        Title = "Alysum",
        Text = Text, 
    })
end

function MouseMove(Position, SmoothingX, SmoothingY)
    local MousePosition = InputService:GetMouseLocation()
    mousemoverel((Position.X - MousePosition.X) / SmoothingX, (Position.Y - MousePosition.Y) / SmoothingY)
end

function WorldToScreen(Position)
    if not Position then return end

    local ViewportPointPosition, OnScreen = CurrentCamera:WorldToViewportPoint(Position)
    local ScreenPosition = Vector2.new(ViewportPointPosition.X, ViewportPointPosition.Y)
    return {
       Position = ScreenPosition,
       OnScreen = OnScreen
    }
end

function OnScreen(Object)
    local _, screen = CurrentCamera:WorldToScreenPoint(Object.Position)
    return screen
end

function GetDistance(Player) 
    if Player ~= nil and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then 
        return math.floor((Player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
     else
        return 0
     end
end


function GetMagnitudeFromMouse(Part)
    local PartPos, OnScreen = CurrentCamera:WorldToScreenPoint(Part.Position)
    if OnScreen then
        local Magnitude = (Vector2.new(PartPos.X, PartPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
        return Magnitude
    end
    return math.huge
end

function RayCastCheck(Part, PartDescendant)
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded.Wait(LocalPlayer.CharacterAdded)
    local Origin = CurrentCamera.CFrame.Position

    local RayCastParams = RaycastParams.new()
    RayCastParams.FilterType = Enum.RaycastFilterType.Blacklist
    RayCastParams.FilterDescendantsInstances = {Character, CurrentCamera}

    local Result = Workspace.Raycast(Workspace, Origin, Part.Position - Origin, RayCastParams)
    
    if (Result) then
        local PartHit = Result.Instance
        local Visible = (not PartHit or Instance.new("Part").IsDescendantOf(PartHit, PartDescendant))
        
        return Visible
    end
    return false
end

function GetClosestPlayer()
    local Target = nil
    local Closest = math.huge
    for _, v in pairs(Players:GetPlayers()) do
        if v.Character and v ~= LocalPlayer and v.Character:FindFirstChild("HumanoidRootPart") then
            if not OnScreen(v.Character.HumanoidRootPart) then 
                continue 
            end
            if utility.checks.visible and not RayCastCheck(v.Character[utility.camlock.part], v.Character) then 
                continue 
            end
            if utility.checks.friend and LocalPlayer:IsFriendsWith(v.UserId) then
                continue
            end
            if utility.checks.team and LocalPlayer.Team == v.Team then 
                continue
            end
            local Distance = GetMagnitudeFromMouse(v.Character.HumanoidRootPart)
            if (Distance < Closest and Circle.Radius + Distance * 0.3 > Distance) then
                Closest = Distance
                Target = v
            end
        end
    end
    utility.camlock.target = Target
end

function Draw(Type, Properties)
    local NewDrawing = Drawing.new(Type)
   
    for i,v in next, Properties or {} do
       NewDrawing[i] = v
    end
    return NewDrawing
end

function AddEsp(Player)
    esp_players[Player] = {
        Name = Draw("Text", {Color = Color3.fromRGB(255,2550, 255), Outline = true, Visible = false, Center = true, Size = 13, Font = 3}),
        BoxOutline = Draw("Square", {Color = Color3.fromRGB(0, 0, 0), Thickness = 3, Visible = false}),
        Box = Draw("Square", {Color = Color3.fromRGB(255, 255, 255), Thickness = 1, Visible = false}),
        HealthBarOutline = Draw("Line", {Color = Color3.fromRGB(0, 0, 0), Thickness = 3, Visible = false}),
        HealthBar = Draw("Line", {Color = Color3.fromRGB(0, 255, 0), Thickness = 1, Visible = false}),
        Distance = Draw("Text", {Color = Color3.fromRGB(255, 255, 255), Outline = true, Visible = false, Center = true, Size = 13, Font = 3})
     }
end

function UpdateEsp()
    for i,v in pairs(esp_players) do
        if utility.esp.enabled and i ~= LocalPlayer and i.Character and i.Character:FindFirstChild("Humanoid") and i.Character:FindFirstChild("HumanoidRootPart") and i.Character:FindFirstChild("Head") then
           local Hum = i.Character.Humanoid
           local Hrp = i.Character.HumanoidRootPart
           
           local Vector, OnScreen = CurrentCamera:WorldToViewportPoint(i.Character.HumanoidRootPart.Position)
           local Size = (CurrentCamera:WorldToViewportPoint(Hrp.Position - Vector3.new(0, 3, 0)).Y - CurrentCamera:WorldToViewportPoint(Hrp.Position + Vector3.new(0, 2.6, 0)).Y) / 2
           local BoxSize = Vector2.new(math.floor(Size * 1.5), math.floor(Size * 1.9))
           local BoxPos = Vector2.new(math.floor(Vector.X - Size * 1.5 / 2), math.floor(Vector.Y - Size * 1.6 / 2))
           local BottomOffset = BoxSize.Y + BoxPos.Y + 1

           if OnScreen and GetDistance(i) < utility.esp.dist then
                 if utility.esp.name.enabled then
                    v.Name.Position = Vector2.new(BoxSize.X / 2 + BoxPos.X, BoxPos.Y - 20)
                    v.Name.Outline = utility.esp.name.outline
                    v.Name.Text = i.DisplayName.." (@"..i.Name..")"
                    v.Name.Color = utility.esp.name.color
                    v.Name.OutlineColor = Color3.fromRGB(0, 0, 0)
                    v.Name.Font = 3
                    v.Name.Size = 16

                    v.Name.Visible = true
                 else
                    v.Name.Visible = false
                 end
                 if utility.esp.distance.enabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    v.Distance.Position = Vector2.new(BoxSize.X / 2 + BoxPos.X, BottomOffset)
                    v.Distance.Outline = utility.esp.distance.outline
                    v.Distance.Text = math.floor((Hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) .. " studs"
                    v.Distance.Color = utility.esp.distance.color
                    v.Distance.OutlineColor = Color3.fromRGB(0, 0, 0)
                    BottomOffset = BottomOffset + 15

                    v.Distance.Font = 3
                    v.Distance.Size = 16

                    v.Distance.Visible = true
                 else
                    v.Distance.Visible = false
                 end
                 if utility.esp.box.enabled then
                    v.BoxOutline.Size = BoxSize
                    v.BoxOutline.Position = BoxPos
                    v.BoxOutline.Visible = utility.esp.box.outline
                    v.BoxOutline.Color = Color3.fromRGB(0, 0, 0)
     
                    v.Box.Size = BoxSize
                    v.Box.Position = BoxPos
                    v.Box.Color = utility.esp.box.color
                    v.Box.Visible = true
                 else
                    v.BoxOutline.Visible = false
                    v.Box.Visible = false
                 end
                 if utility.esp.health.enabled then
                    v.HealthBar.From = Vector2.new((BoxPos.X - 5), BoxPos.Y + BoxSize.Y)
                    v.HealthBar.To = Vector2.new(v.HealthBar.From.X, v.HealthBar.From.Y - (Hum.Health / Hum.MaxHealth) * BoxSize.Y)
                    v.HealthBar.Color = utility.esp.health.color
                    v.HealthBar.Visible = true

                    v.HealthBarOutline.From = Vector2.new(v.HealthBar.From.X, BoxPos.Y + BoxSize.Y + 1)
                    v.HealthBarOutline.To = Vector2.new(v.HealthBar.From.X, (v.HealthBar.From.Y - 1 * BoxSize.Y) -1)
                    v.HealthBarOutline.Color = Color3.fromRGB(0, 0, 0)
                    v.HealthBarOutline.Visible = utility.esp.health.outline
                 else
                    v.HealthBarOutline.Visible = false
                    v.HealthBar.Visible = false
                 end
           else
                 v.Name.Visible = false
                 v.BoxOutline.Visible = false
                 v.Box.Visible = false
                 v.HealthBarOutline.Visible = false
                 v.HealthBar.Visible = false
                 v.Distance.Visible = false
           end
        else
           v.Name.Visible = false
           v.BoxOutline.Visible = false
           v.Box.Visible = false
           v.HealthBarOutline.Visible = false
           v.HealthBar.Visible = false
           v.Distance.Visible = false
        end
     end
end


deb("Functions")

for _, Player in ipairs(Players:GetPlayers()) do
    AddEsp(Player)
end

Players.PlayerAdded:Connect(function(Player)
    AddEsp(Player)
end)

Players.PlayerRemoving:Connect(function(Player)
    for i,v in pairs(esp_players[Player]) do
       v:Remove()
    end
    esp_players[Player] = nil
end)

deb("ESP")

RunService.Heartbeat:Connect(function() 
    UpdateEsp()
    Circle.Position = Vector2.new(Mouse.X, Mouse.Y + Gui:GetGuiInset().Y)
    if utility.camlock.enabled and utility.camlock.target then 
        local Prediction
        local Checks = true
        if utility.camlock.pred.use then 
            Prediction = utility.camlock.target.Character[utility.camlock.part].Position + utility.camlock.target.Character[utility.camlock.part].Velocity / Vector3.new(utility.camlock.pred.x,utility.camlock.pred.y,utility.camlock.pred.x)
        else
            Prediction = utility.camlock.target.Character[utility.camlock.part].Position
        end
        if utility.checks.visible and not RayCastCheck(utility.camlock.target.Character[utility.camlock.part], utility.camlock.target.Character) then 
            Checks = false
        end
        if utility.camlock.mode == "Camera" then
            if Checks == true then 
                local Main = CFrame.new(CurrentCamera.CFrame.p,Prediction)
                local s = utility.camlock.smoothness * 0.01
                CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(Main, s, Enum.EasingStyle.Elastic, Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
            end 
        else
            if Checks == true then 
                local main = WorldToScreen(Prediction)
                local s = utility.camlock.smoothness
                if main.OnScreen and isrbxactive() then
                    MoveMouse(main.Position, s, s)
                end
            end
        end
    end
end)

deb("HeartBeat")


-- // Toggle

InputService.InputBegan:Connect(function(Key)
    if (Key.KeyCode ~= utility.camlock.key) or utility.camlock.rmb then return end
    if utility.camlock.enabled then 
        if utility.camlock.target ~= nil then 
            utility.camlock.target = nil
            notify("Unlocked")
        else
            GetClosestPlayer()
            if utility.camlock.target ~= nil then 
                notify("Locked on: "..utility.camlock.target.Name)
            else
                notify("No Player in FOV")
            end
        end
    end
end)

-- // Hold

InputService.InputBegan:Connect(function(Key)
    if not utility.camlock.rmb then return end
    if Key.UserInputType == Enum.UserInputType.MouseButton2 then 
        GetClosestPlayer()
        if utility.camlock.target ~= nil then 
            notify("Locked on: "..utility.camlock.target.Name)
        else
            notify("No Player in FOV")
        end
    end
end)

InputService.InputEnded:Connect(function(Key)
    if not utility.camlock.rmb then return end
    if Key.UserInputType == Enum.UserInputType.MouseButton2 then 
        utility.camlock.target = nil
        notify("Unlocked")
    end
end)

deb("Input")

local Lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/laagginq/ui-libraries/main/coastified/src.lua"))()
local Window = Lib:Window("Alysum Solara", "Aimbot", Enum.KeyCode.RightShift)
local TargetAimbot = Window:Tab("Settings")

TargetAimbot:Toggle('Enabled',function(state)
    utility.camlock.enabled = state
end)

TargetAimbot:Toggle('Use RMB',function(state)
    utility.camlock.rmb = state
end)

TargetAimbot:Dropdown("Mode",{"Camera","Mouse"}, function(objective)
    utility.camlock.mode = objective
end)

TargetAimbot:Dropdown("Keybind",utility.keys, function(objective)
    utility.camlock.key = ConvertKey(objective)
end)


TargetAimbot:Dropdown("Part",{'Head',"UpperTorso","HumanoidRootPart","LowerTorso"}, function(objective)
    utility.camlock.part = objective
end)

TargetAimbot:Slider('Smoothness',1,100,50,function(Value)
    utility.camlock.smoothness = Value
end)

TargetAimbot:Line()

TargetAimbot:Toggle('Use Prediction',function(state)
    utility.camlock.pred.use = state
end)

TargetAimbot:Slider('X Pred',1,100,70,function(Value)
    utility.camlock.pred.x = Value * 0.1
end)

TargetAimbot:Slider('Y Pred',1,100,70,function(Value)
    utility.camlock.pred.y = Value * 0.1
end)

local Checks = Window:Tab("Checks")

Checks:Toggle('Visible',function(state)
    utility.checks.visible = state
end)

Checks:Toggle('Friend',function(state)
    utility.checks.friend = state
end)

Checks:Toggle('Team',function(state)
    utility.checks.team = state
end)



local FOV = Window:Tab("Field Of View")

FOV:Toggle('Visible',function(state)
    Circle.Visible = state
end)

FOV:Slider('Radius',1,500,50,function(Value)
    Circle.Radius = Value
end)

FOV:Colorpicker("Color",Color3.fromRGB(255,255,255), function(color)
    Circle.Color = color
end)

local Esp = Window:Tab("ESP")

Esp:Toggle('Enabled',function(state)
    utility.esp.enabled = state
end)

Esp:Toggle('Outline',function(state)
    utility.esp.name.outline = state
    utility.esp.box.outline = state
    utility.esp.health.outline = state
    utility.esp.distance.outline = state
end)

Esp:Slider('Max Distance',10,5000,500,function(Value)
    utility.esp.dist = Value 
end)

Esp:Toggle('Names',function(state)
    utility.esp.name.enabled = state
end)

Esp:Toggle('Distance',function(state)
    utility.esp.distance.enabled = state
end)

Esp:Toggle('Boxes',function(state)
    utility.esp.box.enabled = state
end)

Esp:Toggle('Health',function(state)
    utility.esp.health.enabled = state
end)

Esp:Line()

Esp:Colorpicker("Names Color",Color3.fromRGB(255,255,255), function(color)
    utility.esp.name.color = color
end)

Esp:Colorpicker("Distance Color",Color3.fromRGB(255,255,255), function(color)
    utility.esp.distance.color = color
end)

Esp:Colorpicker("Boxes Color",Color3.fromRGB(255,255,255), function(color)
    utility.esp.box.color = color
end)

Esp:Colorpicker("Health Color",Color3.fromRGB(0,255,0), function(color)
    utility.esp.health.color = color
end)

deb("Library")
