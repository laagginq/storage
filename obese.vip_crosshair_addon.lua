-- // From misery.cc but enjoy the addon 👍

local crosshair = {
    enabled = false,
    refreshrate = 0.015,
    mode = 'mouse', -- center, mouse, custom
    position = Vector2.new(0,0), -- custom position

    width = 2.5,
    length = 10,
    radius = 11,
    color = Color3.fromRGB(255, 128, 139),

    spin = false, -- animate the rotation
    spin_speed = 150,
    spin_max = 340,
    spin_style = Enum.EasingStyle.Circular, -- Linear for normal smooth spin

    resize = false, -- animate the length
    resize_speed = 150,
    resize_min = 5,
    resize_max = 22,
}

local CrosshairSec = ObeseAddons:Section({Name = "Crosshair", Side = "right"})

CrosshairSec:Toggle({Name = "Enabled", Flag = "CrosshairEnabled", Def = false, Callback = function(v) 
    crosshair.enabled = v
end}):Colorpicker({Name = "Color", Flag = "CrosshairColor", Default = ObeseAccent, Callback = function(v) 
    crosshair.color = v
end})

CrosshairSec:List({Name = "Mode", Flag = "CrosshairMode", Options = {"Center","Mouse"}, Default = "Center", CallBack = function(v)
	crosshair.mode = v:lower()
end})

CrosshairSec:Slider({Name = "Width", Flag = "CrosshairWidth", Suffix = "%", Min = 0.1, Max = 100, Default = 2.5, Decimals = 0.01, Callback = function(v)
    crosshair.width = v
end})

CrosshairSec:Slider({Name = "Length", Flag = "CrosshairLength", Suffix = "%", Min = 0.1, Max = 100, Default = 10, Decimals = 0.01, Callback = function(v)
    crosshair.length = v
end})

CrosshairSec:Slider({Name = "Radius", Flag = "CrosshairRadius", Suffix = "%", Min = 0.1, Max = 100, Default = 11, Decimals = 0.01, Callback = function(v)
    crosshair.radius = v
end})

CrosshairSec:Toggle({Name = "Spin", Flag = "CrosshairSpinEnabled", Def = false, Callback = function(v) 
    crosshair.spin = v
end})

CrosshairSec:Toggle({Name = "Resize", Flag = "CrosshairResizeEnabled", Def = false, Callback = function(v) 
    crosshair.resize = v
end})

local old; old = hookfunction(Drawing.new, function(class, properties)
    local drawing = old(class)
    for i,v in next, properties or {} do
        drawing[i] = v
    end
    return drawing
end)

local runservice = game:GetService('RunService')
local inputservice = game:GetService('UserInputService')
local tweenservice = game:GetService('TweenService')
local camera = workspace.CurrentCamera

local last_render = 0

local drawings = {
    crosshair = {},
    text = {
        Drawing.new('Text', {Size = 13, Font = 2, Outline = true, Text = 'Obese', Color = Color3.new(1,1,1)}),
        Drawing.new('Text', {Size = 13, Font = 2, Outline = true, Text = '.vip'}),
    }
}

for idx = 1, 4 do
    drawings.crosshair[idx] = Drawing.new('Line')
    drawings.crosshair[idx + 4] = Drawing.new('Line')
end

function solve(angle, radius)
    return Vector2.new(
        math.sin(math.rad(angle)) * radius,
        math.cos(math.rad(angle)) * radius
    )
end

runservice.PostSimulation:Connect(function()

    local _tick = tick()

    if _tick - last_render > crosshair.refreshrate then
        last_render = _tick

        local position = (
            crosshair.mode == 'center' and camera.ViewportSize / 2 or
            crosshair.mode == 'mouse' and inputservice:GetMouseLocation() or
            crosshair.position
        )

        local text_1 = drawings.text[1]
        local text_2 = drawings.text[2]

        text_1.Visible = crosshair.enabled
        text_2.Visible = crosshair.enabled

        if crosshair.enabled then

            local text_x = text_1.TextBounds.X + text_2.TextBounds.X

            text_1.Position = position + Vector2.new(-text_x / 2, crosshair.radius + (crosshair.resize and crosshair.resize_max or crosshair.length) + 15)
            text_2.Position = text_1.Position + Vector2.new(text_1.TextBounds.X)
            text_2.Color = crosshair.color
            
            for idx = 1, 4 do
                local outline = drawings.crosshair[idx]
                local inline = drawings.crosshair[idx + 4]
    
                local angle = (idx - 1) * 90
                local length = crosshair.length
    
                if crosshair.spin then
                    local spin_angle = -_tick * crosshair.spin_speed % crosshair.spin_max
                    angle = angle + tweenservice:GetValue(spin_angle / 360, crosshair.spin_style, Enum.EasingDirection.InOut) * 360
                end
    
                if crosshair.resize then
                    local resize_length = tick() * crosshair.resize_speed % 180
                    length = crosshair.resize_min + math.sin(math.rad(resize_length)) * crosshair.resize_max
                end
    
                inline.Visible = true
                inline.Color = crosshair.color
                inline.From = position + solve(angle, crosshair.radius)
                inline.To = position + solve(angle, crosshair.radius + length)
                inline.Thickness = crosshair.width
    
                outline.Visible = false
                outline.From = position + solve(angle, crosshair.radius - 1)
                outline.To = position + solve(angle, crosshair.radius + length + 1)
                outline.Thickness = crosshair.width + 1.5    
            end
        else
            for idx = 1, 4 do
                drawings.crosshair[idx].Visible = false
                drawings.crosshair[idx + 4].Visible = false
            end
        end

    end
end)
