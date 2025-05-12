--// ESP + Aimbot com FOV ajustável e distância (Mobile Friendly)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Configurações
local FOV = 100
local FOVColor = Color3.fromRGB(255, 255, 255)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = true
FOVCircle.Thickness = 1.5
FOVCircle.Radius = FOV
FOVCircle.Color = FOVColor
FOVCircle.Filled = false

local function UpdateFOVCircle()
	FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
	FOVCircle.Radius = FOV
	FOVCircle.Color = FOVColor
end

local function GetClosestEnemy()
	local closest = nil
	local shortest = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local pos, onScreen = Camera:WorldToViewportPoint(player.Character.HumanoidRootPart.Position)
			if onScreen then
				local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)).Magnitude
				if dist < FOV and dist < shortest then
					shortest = dist
					closest = player
				end
			end
		end
	end

	return closest
end

-- Aimbot
RunService.RenderStepped:Connect(function()
	UpdateFOVCircle()

	local target = GetClosestEnemy()
	if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
		Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.HumanoidRootPart.Position)
	end
end)

-- ESP com distância
for _, player in ipairs(Players:GetPlayers()) do
	if player ~= LocalPlayer then
		local nameTag = Drawing.new("Text")
		nameTag.Size = 14
		nameTag.Center = true
		nameTag.Outline = true
		nameTag.Color = Color3.new(1, 1, 0)
		nameTag.Visible = true

		RunService.RenderStepped:Connect(function()
			if player.Character and player.Character:FindFirstChild("Head") and player.Character:FindFirstChild("HumanoidRootPart") then
				local pos, visible = Camera:WorldToViewportPoint(player.Character.Head.Position)
				local dist = (player.Character.HumanoidRootPart.Position - Camera.CFrame.Position).Magnitude
				nameTag.Visible = visible
				if visible then
					nameTag.Position = Vector2.new(pos.X, pos.Y - 25)
					nameTag.Text = string.format("%s (%.0fm)", player.Name, dist)
				end
			else
				nameTag.Visible = false
			end
		end)
	end
end

-- Interface
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0, 20, 0, 200)
Frame.Size = UDim2.new(0, 150, 0, 150)
Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Frame.BorderSizePixel = 0

local FOVUp = Instance.new("TextButton", Frame)
FOVUp.Size = UDim2.new(1, 0, 0, 30)
FOVUp.Text = "Aumentar FOV"
FOVUp.MouseButton1Click:Connect(function()
	FOV = math.clamp(FOV + 25, 10, 300)
end)

local FOVDown = Instance.new("TextButton", Frame)
FOVDown.Position = UDim2.new(0, 0, 0, 35)
FOVDown.Size = UDim2.new(1, 0, 0, 30)
FOVDown.Text = "Diminuir FOV"
FOVDown.MouseButton1Click:Connect(function()
	FOV = math.clamp(FOV - 25, 10, 300)
end)

local ColorBtn = Instance.new("TextButton", Frame)
ColorBtn.Position = UDim2.new(0, 0, 0, 70)
ColorBtn.Size = UDim2.new(1, 0, 0, 30)
ColorBtn.Text = "Trocar Cor"
local cores = {
	Color3.fromRGB(255,255,255),
	Color3.fromRGB(255,0,0),
	Color3.fromRGB(0,255,0),
	Color3.fromRGB(0,255,255),
}
local corIndex = 1
ColorBtn.MouseButton1Click:Connect(function()
	corIndex = corIndex + 1
	if corIndex > #cores then corIndex = 1 end
	FOVColor = cores[corIndex]
end)
