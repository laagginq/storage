local Notifications = {Notifs = {}};
local TweenService = game:GetService("TweenService");
local ScreenGui = Instance.new("ScreenGui", game:GetService("RunService"):IsStudio() and game.Players.LocalPlayer.PlayerGui or game.CoreGui)
ScreenGui.Name = "ScreenGui"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
--
function Notifications:updateNotifsPositions(position)
	for i, v in pairs(Notifications.Notifs) do 
		local Position = Vector2.new(20, 20)
		game:GetService("TweenService"):Create(v.Container, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Position = UDim2.new(0,Position.X,0,Position.Y + (i * 25))}):Play()
	end 
end

function Notifications:Notification(message, duration, color, flash)
	local notification = {Container = nil, Objects = {}}
	--
	local Position = Vector2.new(20, 20)
	--
	local NewInd = Instance.new("Frame")
	NewInd.Name = "NewInd"
	NewInd.AutomaticSize = Enum.AutomaticSize.X
	NewInd.Position = UDim2.new(0,20,0,20)
	NewInd.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	NewInd.BackgroundTransparency = 1
	NewInd.BorderColor3 = Color3.fromRGB(0, 0, 0)
	NewInd.Size = UDim2.fromOffset(0, 20)
	NewInd.Parent = ScreenGui
	notification.Container = NewInd

	local ActualInd = Instance.new("Frame")
	ActualInd.Name = "ActualInd"
	ActualInd.AutomaticSize = Enum.AutomaticSize.X
	ActualInd.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	ActualInd.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ActualInd.Size = UDim2.fromScale(1, 1)
	ActualInd.BackgroundTransparency = 1

	local Accent = Instance.new("Frame")
	Accent.Name = "Accent"
	Accent.BackgroundColor3 = color or Color3.fromRGB(255,255,255)
	Accent.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Accent.Size = UDim2.new(0, 2, 1, 0)
	Accent.ZIndex = 2
	Accent.BackgroundTransparency = 1

	local UIGradient = Instance.new("UIGradient")
	UIGradient.Name = "UIGradient"
	UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 55, 55)),
	})
	UIGradient.Parent = Accent

	Accent.Parent = ActualInd

	local IndInline = Instance.new("Frame")
	IndInline.Name = "IndInline"
	IndInline.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	IndInline.BorderColor3 = Color3.fromRGB(0, 0, 0)
	IndInline.BorderSizePixel = 0
	IndInline.Position = UDim2.fromOffset(1, 1)
	IndInline.Size = UDim2.new(1, -2, 1, -2)
	IndInline.BackgroundTransparency = 1

	local UIGradient1 = Instance.new("UIGradient")
	UIGradient1.Name = "UIGradient"
	UIGradient1.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 170, 170)),
	})
	UIGradient1.Rotation = 90
	UIGradient1.Parent = IndInline

	local TextLabel = Instance.new("TextLabel")
	TextLabel.Name = "TextLabel"
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.Text = message
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.TextSize = 13
	TextLabel.TextStrokeTransparency = 0
	TextLabel.AutomaticSize = Enum.AutomaticSize.X
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.BackgroundTransparency = 1
	TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel.BorderSizePixel = 0
	TextLabel.Position = UDim2.fromOffset(6, 0)
	TextLabel.Size = UDim2.fromScale(0, 1)
	TextLabel.Parent = IndInline
	TextLabel.TextTransparency = 1

	local UIPadding = Instance.new("UIPadding")
	UIPadding.Name = "UIPadding"
	UIPadding.PaddingRight = UDim.new(0, 6)
	UIPadding.Parent = IndInline

	IndInline.Parent = ActualInd

	ActualInd.Parent = NewInd


	function notification:remove()
		table.remove(Notifications.Notifs, table.find(Notifications.Notifs, notification))
		Notifications:updateNotifsPositions(Position)
		task.wait(0.5)
		NewInd:Destroy()
	end
	
	function notification:updatetext(new)
		TextLabel.Text = new
	end

	task.spawn(function()
		ActualInd.AnchorPoint = Vector2.new(1,0)
		for i,v in next, NewInd:GetDescendants() do
			if v:IsA("Frame") then
				game:GetService("TweenService"):Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
			elseif v:IsA("UIStroke") then
				game:GetService("TweenService"):Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Transparency = 0.8}):Play()
			end
		end
		local Tween1 = game:GetService("TweenService"):Create(ActualInd, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {AnchorPoint = Vector2.new(0,0)}):Play()
		game:GetService("TweenService"):Create(TextLabel, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
		task.wait(duration)
		for i,v in next, NewInd:GetDescendants() do
			if v:IsA("Frame") then
				game:GetService("TweenService"):Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
			elseif v:IsA("UIStroke") then
				game:GetService("TweenService"):Create(v, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Transparency = 1}):Play()
			end
		end
		game:GetService("TweenService"):Create(TextLabel, TweenInfo.new(1, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {TextTransparency = 1}):Play()
	end)

	task.delay(duration + 0.1, function()
		notification:remove()
	end)
	
	-- Flashing
	if flash then
		local time = 0 -- Start at 0 seconds
		task.spawn(function()
			while task.wait() do
				local progress = (math.sin(2 * math.pi * 2 * time) + 1) / 2;
				local value = color:Lerp(Color3.fromRGB(0, 0, 0), progress)

				Accent.BackgroundColor3 = value

				time = time + 0.01;
			end
		end)
	end

	table.insert(Notifications.Notifs, notification)
	Notifications:updateNotifsPositions(Position)
	NewInd.Position = UDim2.new(0,Position.X,0,Position.Y + (table.find(Notifications.Notifs, notification) * 25))
	return notification
end

return Notifications
