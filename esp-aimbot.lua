local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Position = UDim2.new(0, 20, 0, 200)
Frame.Size = UDim2.new(0, 180, 0, 240)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true -- PC

-- Suporte mobile (toque)
local UIS = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos

local function update(input)
local delta = input.Position - dragStart
Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

Frame.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
dragging = true
dragStart = input.Position
startPos = Frame.Position

input.Changed:Connect(function()  
		if input.UserInputState == Enum.UserInputState.End then  
			dragging = false  
		end  
	end)  
end

end)

Frame.InputChanged:Connect(function(input)
if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then
dragInput = input
end
end)

UIS.InputChanged:Connect(function(input)
if input == dragInput and dragging then
update(input)
end
end)

-- Variáveis globais para usar em outro trecho do script
getgenv().FOV = 150
getgenv().FOVColor = Color3.fromRGB(255, 255, 255)
getgenv().AimbotEnabled = true
getgenv().ESPEnabled = true

-- Botões

local function criarBotao(txt, posY)
local btn = Instance.new("TextButton", Frame)
btn.Size = UDim2.new(1, 0, 0, 30)
btn.Position = UDim2.new(0, 0, 0, posY)
btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.Font = Enum.Font.SourceSans
btn.TextSize = 18
btn.Text = txt
return btn
end

local FOVUp = criarBotao("Aumentar FOV", 0)
FOVUp.MouseButton1Click:Connect(function()
FOV = math.clamp(FOV + 25, 10, 300)
end)

local FOVDown = criarBotao("Diminuir FOV", 35)
FOVDown.MouseButton1Click:Connect(function()
FOV = math.clamp(FOV - 25, 10, 300)
end)

local ColorBtn = criarBotao("Trocar Cor", 70)
local cores = {
Color3.fromRGB(255,255,255),
Color3.fromRGB(255,0,0),
Color3.fromRGB(0,255,0),
Color3.fromRGB(0,255,255),
}
local corIndex = 1
ColorBtn.MouseButton1Click:Connect(function()
corIndex = (corIndex % #cores) + 1
FOVColor = cores[corIndex]
end)

local AimbotBtn = criarBotao("Aimbot: ON", 105)
AimbotBtn.MouseButton1Click:Connect(function()
AimbotEnabled = not AimbotEnabled
AimbotBtn.Text = AimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
end)

local ESPBtn = criarBotao("ESP: ON", 140)
ESPBtn.MouseButton1Click:Connect(function()
ESPEnabled = not ESPEnabled
ESPBtn.Text = ESPEnabled and "ESP: ON" or "ESP: OFF"
end)

local CloseBtn = criarBotao("Fechar Interface", 180)
CloseBtn.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
CloseBtn.MouseButton1Click:Connect(function()
ScreenGui:Destroy()
end)

