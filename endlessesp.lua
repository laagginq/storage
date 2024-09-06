getgenv().esp = {

    AutoStep = true, -- automatically updates the esp, you can disable this and use Player:Step() if you want to manually update them
    CharacterSize = Vector3.new(4, 5.75, 1.5),
    CharacterOffset = CFrame.new(0, -0.25, 0),
    UseBoundingBox = false, -- will use bounding box instead of size preset for dynamic box

    PriorityColor = Color3.new(1,0.25,0.25),

    BoxEnabled = false,
    BoxCorners = false,
    BoxDynamic = false,
    BoxStaticXFactor = 1.3,
    BoxStaticYFactor = 2.1,
    BoxColor = Color3.fromRGB(255, 255, 255),
    
    SkeletonEnabled = false,
    SkeletonColor = Color3.fromRGB(255, 255, 255),
    SkeletonMaxDistance = 300,

    ChamsEnabled = false,
    ChamsInnerColor = Color3.fromRGB(102, 60, 153),
    ChamsOuterColor = Color3.fromRGB(0, 0, 0),
    ChamsInnerTransparency = 0.5,
    ChamsOuterTransparency = 0.2,


    TextEnabled = false,
    TextColor = Color3.fromRGB(255, 255, 255),
    TextLayout = {
        ['nametag']  = { enabled = true, position = 'top', order = 1 },
        ['name']     = { enabled = true, position = 'top', order = 2 },
        ['health']   = { enabled = true, position = 'left', order = 1, bar = 'health' },
        ['armor']    = { enabled = false, position = 'left', order = 2, bar = 'armor' },
        ['tool']     = { enabled = true, position = 'bottom', suffix = '', prefix = '', order = 1 },
        ['distance'] = { enabled = false, position = 'bottom', suffix = 'm', order = 2 },
    },

    BarLayout = {
        ['health'] = { enabled = true, position = 'left', order = 1, color_empty = Color3.fromRGB(176, 84, 84), color_full = Color3.fromRGB(140, 250, 140) },
        ['armor']  = { enabled = false, position = 'left', order = 2, color_empty = Color3.fromRGB(58, 58, 97), color_full = Color3.fromRGB(72, 72, 250) }
    }
    
}

-- // variables
local runservice = game:GetService('RunService')
local camera = workspace.CurrentCamera
local world_to_viewport = camera.WorldToViewportPoint
local inf = math.huge

local skeleton_connections = {
    {'UpperTorso', 'Head', Vector3.new(0,0.4,0), Vector3.new(0,-0.2,0)},
    {'UpperTorso', 'LowerTorso', Vector3.new(0,0.4,0)},

    {'UpperTorso', 'RightUpperArm', Vector3.new(0,0.4,0)},
    {'UpperTorso', 'LeftUpperArm', Vector3.new(0,0.4,0)},
    {'RightUpperArm', 'RightHand'},
    {'LeftUpperArm', 'LeftHand'},

    {'LowerTorso', 'LeftUpperLeg'},
    {'LeftUpperLeg', 'LeftFoot'},
    {'LowerTorso', 'RightUpperLeg'},
    {'RightUpperLeg', 'RightFoot'}
}

function vector2_floor(vector2)
    return Vector2.new(math.floor(vector2.X), math.floor(vector2.Y))
end

function cframe_to_viewport(cframe, floor)
    local position, visible = world_to_viewport(camera, cframe * (cframe - cframe.p):ToObjectSpace(camera.CFrame - camera.CFrame.p).p)
    if floor then
        position = vector2_floor(position)
    end
    return position, visible
end

-- // drawing
local old; old = hookfunction(Drawing.new, function(class, properties)
    local drawing = old(class)
    for i,v in next, properties or {} do
        drawing[i] = v
    end
    return drawing
end)

-- // player
getgenv().players = {}
local player = {}
player.__index = player

function player:Check()
    
    local character = self.instance.Character
    local rootpart = character and character:FindFirstChild('HumanoidRootPart')
    local torso = character and character:FindFirstChild('UpperTorso')
    local humanoid = rootpart and character:FindFirstChild('Humanoid')
    local bodyeffects = character and character:FindFirstChild('BodyEffects')
    local armor = bodyeffects and bodyeffects:FindFirstChild('Armor')

    if not humanoid or 0 >= humanoid.Health then
        return false
    end

    local screen_position, screen_visible = cframe_to_viewport(torso.CFrame * esp.CharacterOffset, true)

    if not screen_visible then
        return false
    end

    return true, {
        character = character,
        rootpart = rootpart,
        humanoid = humanoid,
        bodyeffects = bodyeffects,
        armor = armor,
        position = screen_position,
        cframe = rootpart.CFrame * esp.CharacterOffset,
        health = humanoid.Health,
        maxhealth = humanoid.MaxHealth,
        healthfactor = humanoid.Health / humanoid.MaxHealth,
        armorfactor = armor.Value / 200,
        distance = (rootpart.CFrame.p - camera.CFrame.p).magnitude
    }
    
end

function player:Step(delta)

    local check_pass, check_data = self:Check()

    self:SetVisible(false)

    if not check_pass then
        return
    else
        self.visible = true
    end
    
    local size = self:GetBoxSize(check_data.position, check_data.cframe)
    local position = vector2_floor(check_data.position - size / 2)
    local color = self.priority and esp.PriorityColor
    local box_drawings = self.drawings.box

    if esp.BoxEnabled and esp.BoxCorners then

        local corner_size = size.X / 3

        box_drawings[9].Position = position
        box_drawings[10].Position = position + Vector2.new(size.X - 1, 0)
        box_drawings[11].Position = position + Vector2.new(0, size.Y - corner_size)
        box_drawings[12].Position = position + Vector2.new(size.X - 1, size.Y - corner_size)

        box_drawings[13].Position = position
        box_drawings[14].Position = position + Vector2.new(size.X - corner_size, 0)
        box_drawings[15].Position = position + Vector2.new(0, size.Y - 1)
        box_drawings[16].Position = position + Vector2.new(size.X - corner_size, size.Y - 1)

        for i = 1, 8 do
            local outline = box_drawings[i]
            local inline = box_drawings[i + 8]

            inline.Visible = true
            outline.Visible = true
            inline.Filled = true
            outline.Filled = true
            inline.Color = color or (self.useboxcolor and self.boxcolor) or esp.BoxColor

            outline.Position = inline.Position - Vector2.new(1, 1)
            
            if i > 4 then
                inline.Size = Vector2.new(corner_size, 1)
                outline.Size = Vector2.new(corner_size + 2, 3)
            else
                inline.Size = Vector2.new(1, corner_size)
                outline.Size = Vector2.new(3, corner_size + 2)
            end
        end



    elseif esp.BoxEnabled then
        local outline = box_drawings[1]
        local inline = box_drawings[9]

        outline.Visible = true
        outline.Size = size
        outline.Position = position

        inline.Visible = true
        inline.Size = size
        inline.Position = position
        inline.Color = color or (self.useboxcolor and self.boxcolor) or esp.BoxColor
    end
    
    self.highlight.Enabled = esp.ChamsEnabled
    self.highlight.FillColor = (self.usehighlightcolor and self.highlightcolor) or esp.ChamsInnerColor
    self.highlight.FillTransparency = esp.ChamsInnerTransparency
    self.highlight.OutlineColor = (self.usehighlightcolor and self.outlinehighlightcolor) or esp.ChamsOuterColor
    self.highlight.OutlineTransparency = esp.ChamsOuterTransparency
    self.highlight.Parent = check_data.character
    self.highlight.Adornee = check_data.character

    local bar_data = self:GetBarData(check_data)
    local bar_positions = { top = 0, bottom = 0, left = 0, right = 0 }

    for idx, data in next, self.drawings.bar do
        local flag = data[1]
        local layout = data[2]
        local outline = data[3]
        local inline = data[4]
        local data = bar_data[flag]

        if not layout.enabled or data.enabled == false then
            continue
        end

        local progress = data.progress or 0
        local vertical = layout.position == 'left' or layout.position == 'right'

        outline.Visible = true
        inline.Visible = true

        outline.Size = vertical and Vector2.new(3, size.Y + 2) or Vector2.new(size.X + 2, 3)
        outline.Position = position + (
            layout.position == 'top' and Vector2.new(-1, -(5 + bar_positions.top)) or
            layout.position == 'bottom' and Vector2.new(-1, size.Y + 2 + bar_positions.bottom) or
            layout.position == 'left' and Vector2.new(-5-bar_positions.left, -1) or
            layout.position == 'right' and Vector2.new(size.X + 2 + bar_positions.right, -1)
        )

        inline.Color = layout.color_empty:lerp(layout.color_full, progress)
        inline.Size = vertical and Vector2.new(1, progress * size.Y) or Vector2.new(progress * size.X, 1)

        if vertical then
            inline.Position = outline.Position + Vector2.new(1,1 + size.Y - progress * size.Y)
        else
            inline.Position = outline.Position + Vector2.new(size.X - progress * size.X ,1)
        end

        bar_positions[layout.position] += 4

    end

    if esp.TextEnabled then
        local text_data = self:GetTextData(check_data)
        local text_positions = { top = bar_positions.top, bottom = bar_positions.bottom, left = 0, right = 0 }

        for idx, data in next, self.drawings.text do
            local flag = data[1]
            local layout = data[2]
            local drawing = data[3]
            local data = text_data[flag]

            if not layout.enabled or data.enabled == false then
                continue
            end

            drawing.Visible = true
            drawing.Text = (layout.prefix or '') .. (data.text or '') .. (layout.suffix or '')
            drawing.Color = data.color or color or layout.color or esp.TextColor

            if layout.bar then
                drawing.Position = position + (
                    layout.position == 'left' and Vector2.new(-(bar_positions.left + drawing.TextBounds.X + 2), size.Y - bar_data[layout.bar].progress * size.Y - 3) or
                    layout.position == 'right' and Vector2.new(size.X + bar_positions.right + 2, size.Y - bar_data[layout.bar].progress * size.Y -3)               
                )
            else
                drawing.Position = position + (
                    layout.position == 'top' and Vector2.new(size.X / 2, -3 - (text_positions.top + 14)) or
                    layout.position == 'bottom' and Vector2.new(size.X / 2, size.Y + text_positions.bottom + 2) or
                    layout.position == 'left' and Vector2.new(-(bar_positions.left + drawing.TextBounds.X + 2), text_positions.left - 3) or
                    layout.position == 'right' and Vector2.new(size.X + bar_positions.right + 2, size.Y + text_positions.right - 3)               
                )
    
                text_positions[layout.position] += 14
            end

        end 
    end

    if esp.SkeletonEnabled and esp.SkeletonMaxDistance > check_data.distance then

        local cache = {}

        for idx, connection_data in next, skeleton_connections do
            local drawing = self.drawings.skeleton[idx]
            local part_a = check_data.character:FindFirstChild(connection_data[1])
            local part_b = check_data.character:FindFirstChild(connection_data[2])

            if part_a and part_b then
                local screen_position_a = cache[part_a] or cframe_to_viewport(part_a.CFrame + (connection_data[3] or Vector3.new()), true)
                local screen_position_b = cache[part_b] or cframe_to_viewport(part_b.CFrame + (connection_data[4] or Vector3.new()), true)

                cache[part_a] = screen_position_a
                cache[part_b] = screen_position_b

                drawing.Visible = true
                drawing.Color = color or esp.SkeletonColor
                drawing.From = screen_position_a
                drawing.To = screen_position_b
            end
        end
    end


end

function player:GetTextData(data)
    local tool = data.character:FindFirstChildOfClass('Tool')
    return {
        ['nametag']  = { text = self.nametag_text, enabled = self.nametag_enabled, color = self.nametag_color },
        ['name']     = { text = self.instance.DisplayName },
        ['armor']    = { text = tostring(math.floor(data.armor.Value)), color = esp.BarLayout.armor.color_empty:lerp(esp.BarLayout.armor.color_full, data.armorfactor)},
        ['health']   = { text = tostring(math.floor(data.health)), color = esp.BarLayout.health.color_empty:lerp(esp.BarLayout.health.color_full, data.healthfactor) },
        ['distance'] = { text = tostring(math.floor(data.distance)) },
        ['tool']     = { text = tool and tool.Name, enabled = tool ~= nil }
    }
end

function player:GetBarData(data) -- progress should be a number 0-1, you can get this by doing value / maxvalue aka armor / maxarmor
    return {
        ['health'] = { progress = data.healthfactor },
        ['armor'] = { progress = data.armorfactor }
    }
end

function player:GetBoxSize(position, cframe)
    if esp.BoxDynamic then
        local size = esp.CharacterSize
        
        if esp.UseBoundingBox then
            _, size = self.instance.Character:GetBoundingBox()
        end

        local x = cframe_to_viewport(cframe * CFrame.new(size.X, 0, 0))
        local y = cframe_to_viewport(cframe * CFrame.new(0, size.Y, 0))
        local z = cframe_to_viewport(cframe * CFrame.new(0, 0, size.Z))

        local SizeX = math.max(math.abs(position.X - x.X), math.abs(position.X - z.X))
        local SizeY = math.max(math.abs(position.Y - y.Y), math.abs(position.Y - x.Y))

        return Vector2.new(math.clamp(math.floor(SizeX), 3, inf), math.clamp(math.floor(SizeY), 6, inf))
    else
        local distance = (camera.CFrame.p - cframe.p).magnitude
        local factor = 1 / ((distance / 3) * math.tan(math.rad(camera.FieldOfView / 2)) * 2) * 1000
        return Vector2.new(math.clamp(math.floor(factor * esp.BoxStaticXFactor), 3, inf), math.clamp(math.floor(factor * esp.BoxStaticYFactor), 6, inf))
    end
end

function player:SetPriority(bool)
    self.priority = bool
end

function player:GetPriority()
    return self.priority
end

function player:SetBoxColorEnabled(bool)
    self.useboxcolor = bool
end

function player:SetBoxColor(color)
    self.boxcolor = color
end

function player:SetHighlightColorEnabled(bool)
    self.usehighlightcolor = bool
end

function player:SetHighlightColor(color, color2)
    self.highlightcolor = color
    self.outlinehighlightcolor = color2
end

function player:SetNametagText(str)
    self.nametag_text = str
end

function player:SetNametagEnabled(bool)
    self.nametag_enabled = bool
end

function player:SetNametagColor(color)
    self.nametag_color = color
end

function player:SetNametag(str, bool, color)
    self:SetNametagText(str)
    self:SetNametagEnabled(bool)
    self:SetNametagColor(color)
end

function player:SetVisible(bool)
    if self.visible ~= bool then
        self.visible = bool
        for i,v in next, self.drawings.box do v.Visible = bool end
        for i,v in next, self.drawings.skeleton do v.Visible = bool end
        for i,v in next, self.drawings.text do v[3].Visible = bool end
        for i,v in next, self.drawings.bar do v[3].Visible = bool; v[4].Visible = bool end
    end
end

-- // new player
function esp.NewPlayer(player_instance)
    local player = setmetatable({}, player)

    player.instance = player_instance
    player.priority = false
    player.useboxcolor = false
    player.nametag_enabled = false
    player.nametag_text = 'nametag'
    player.nametag_color = Color3.new(1,1,1)
    player.boxcolor = Color3.new(1,1,1)

    player.highlight = Instance.new('Highlight')
    player.drawings = {
        text = {},
        bar = {},
        skeleton = {},
        box = {}
    }

    player.remove_esp = function() 
        for i,v in next, player.drawings.box do v:Remove() end
        for i,v in next, player.drawings.skeleton do v:Remove() end
        for i,v in next, player.drawings.text do v[3]:Remove() end
        for i,v in next, player.drawings.bar do v[3]:Remove(); v[4]:Remove() end

        player.highlight:Destroy()
    end

    for i = 1, 8 do
        player.drawings.box[i] = Drawing.new('Square')
    end

    for i = 9, 16 do
        player.drawings.box[i] = Drawing.new('Square')
    end

    for i = 1, 10 do
        player.drawings.skeleton[i] = Drawing.new('Line', { Thickness = 1 })
    end

    for flag, layout in next, esp.TextLayout do
        table.insert(player.drawings.text, { 
            flag,
            layout,
            Drawing.new('Text', { Size = 13, Font = 2, Outline = true, Center = layout.position == 'top' or layout.position == 'bottom' }) 
        })
    end

    for flag, layout in next, esp.BarLayout do
        table.insert(player.drawings.bar, { 
            flag,
            layout,
            Drawing.new('Square', { Thickness = 1, Filled = true }),
            Drawing.new('Square', { Thickness = 1, Filled = true }),
        })
    end

    table.sort(player.drawings.text, function(a,b)
        return a[2].order < a[2].order
    end)

    table.sort(player.drawings.bar, function(a,b)
        return a[2].order < a[2].order
    end)
    
    table.insert(players, player)
    return player
end

-- // update
game:GetService('RunService').PreRender:Connect(function(delta)
    if esp.AutoStep then
        for i, player in next, players do
            player:Step(delta)
        end
    end
end)

for i,v in next, game.Players:GetPlayers() do 
esp.NewPlayer(v)
end 
-- // return
return esp
