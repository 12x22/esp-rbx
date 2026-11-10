-- ESP HUB "Pink Edition" pour Solara (2026) - Dédicace & Fonctions avancées
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- Message d'amour personnalisé dans sa console (F9)
print("--------------------------------------------------")
print("🌸 Pour ma bbtrickz, triche intelligemment bby 🌸")
print("--------------------------------------------------")

-- Configuration globale
local Config = {
    Enabled = true,
    TeamCheck = false,
    EnemyColor = Color3.fromRGB(255, 105, 180),
    AllyColor = Color3.fromRGB(186, 85, 211),
    Transparency = 0.5
}

-- Gestion de l'ESP (Highlights de Roblox)
local function UpdateESP(player)
    if not player or player == LocalPlayer then return end
    
    local function SetupHighlight(character)
        if not character then return end
        local highlight = character:FindFirstChild("Solara_Pink_ESP")
        
        if not Config.Enabled then
            if highlight then highlight:Destroy() end
            return
        end
        
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "Solara_Pink_ESP"
            highlight.Parent = character
            highlight.OutlineTransparency = 0
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = character
        end

        local function RefreshColor()
            if not highlight or not highlight.Parent or not player or not LocalPlayer then return end
            highlight.FillTransparency = Config.Transparency
            
            local success, sameTeam = pcall(function()
                return Config.TeamCheck and player.Team == LocalPlayer.Team and player.Team ~= nil
            end)
            
            if success and sameTeam then
                highlight.FillColor = Config.AllyColor
            else
                highlight.FillColor = Config.EnemyColor
            end
        end

        RefreshColor()
        
        pcall(function()
            player:GetPropertyChangedSignal("Team"):Connect(RefreshColor)
            LocalPlayer:GetPropertyChangedSignal("Team"):Connect(RefreshColor)
        end)
    end

    if player.Character then SetupHighlight(player.Character) end
    player.CharacterAdded:Connect(SetupHighlight)
end

local function RefreshAllESP()
    for _, p in ipairs(Players:GetPlayers()) do
        UpdateESP(p)
        if p.Character and not Config.Enabled then
            local hl = p.Character:FindFirstChild("Solara_Pink_ESP")
            if hl then hl:Destroy() end
        end
    end
end

Players.PlayerAdded:Connect(UpdateESP)

-- INTERFACE GRAPHIQUE (UI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SolaraPinkHub"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 260, 0, 310) -- Redimensionné pour être plus propre et compact
MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 4)
TopBar.BackgroundColor3 = Config.EnemyColor
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

-- Système de Drag
local dragging = false
local dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Right Shift Toggle
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Titre
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "🦇 4_6 HUB 🦇"
Title.TextColor3 = Color3.fromRGB(255, 105, 180)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local function CreateButton(text, position, size, baseColor, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = size
    Btn.Position = position
    Btn.BackgroundColor3 = baseColor
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Text = text
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 12
    Btn.BorderSizePixel = 0
    Btn.Parent = MainFrame
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Btn
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

local ToggleESP = CreateButton("ESP : ACTIVÉ", UDim2.new(0, 30, 0, 50), UDim2.new(0, 200, 0, 35), Color3.fromRGB(255, 105, 180), function() end)
ToggleESP.MouseButton1Click:Connect(function()
    Config.Enabled = not Config.Enabled
    if Config.Enabled then
        ToggleESP.Text = "ESP : ACTIVÉ"
        ToggleESP.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    else
        ToggleESP.Text = "ESP : DÉSACTIVÉ"
        ToggleESP.BackgroundColor3 = Color3.fromRGB(50, 40, 45)
    end
    RefreshAllESP()
end)

local ToggleTeam = CreateButton("TEAM CHECK : DÉSACTIVÉ", UDim2.new(0, 30, 0, 95), UDim2.new(0, 200, 0, 35), Color3.fromRGB(50, 40, 45), function() end)
ToggleTeam.MouseButton1Click:Connect(function()
    Config.TeamCheck = not Config.TeamCheck
    if Config.TeamCheck then
        ToggleTeam.Text = "TEAM CHECK : ACTIVÉ"
        ToggleTeam.BackgroundColor3 = Color3.fromRGB(186, 85, 211)
    else
        ToggleTeam.Text = "TEAM CHECK : DÉSACTIVÉ"
        ToggleTeam.BackgroundColor3 = Color3.fromRGB(50, 40, 45)
    end
    RefreshAllESP()
end)

-- SLIDER TRANSPARENCE
local TransLabel = Instance.new("TextLabel")
TransLabel.Size = UDim2.new(0, 200, 0, 20)
TransLabel.Position = UDim2.new(0, 30, 0, 140)
TransLabel.BackgroundTransparency = 1
TransLabel.Text = "Transparence : 50%"
TransLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TransLabel.Font = Enum.Font.Gotham
TransLabel.TextSize = 11
TransLabel.Parent = MainFrame

local SliderFrame = Instance.new("Frame")
SliderFrame.Size = UDim2.new(0, 200, 0, 8)
SliderFrame.Position = UDim2.new(0, 30, 0, 165)
SliderFrame.BackgroundColor3 = Color3.fromRGB(45, 35, 45)
SliderFrame.BorderSizePixel = 0
SliderFrame.Parent = MainFrame
local SliderCorner = Instance.new("UICorner")
SliderCorner.CornerRadius = UDim.new(0, 4)
SliderCorner.Parent = SliderFrame

local SliderButton = Instance.new("TextButton")
SliderButton.Size = UDim2.new(0, 16, 0, 16)
SliderButton.Position = UDim2.new(0.5, -8, 0, -4)
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
SliderButton.Text = ""
SliderButton.Parent = SliderFrame
local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(1, 0)
BtnCorner.Parent = SliderButton

local sliderDragging = false
SliderButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliderDragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = input.Position.X
        local frameLeft = SliderFrame.AbsolutePosition.X
        local frameWidth = SliderFrame.AbsoluteSize.X
        local percentage = math.clamp((mousePos - frameLeft) / frameWidth, 0, 1)
        
        SliderButton.Position = UDim2.new(percentage, -8, 0, -4)
        Config.Transparency = percentage
        TransLabel.Text = "Transparence : " .. math.floor(percentage * 100) .. "%"
        RefreshAllESP()
    end
end)

-- --- SYSTÈME COLOR PICKER CORRIGÉ AVEC UIGRADIENT ---
local ColorLabel = Instance.new("TextLabel")
ColorLabel.Size = UDim2.new(0, 200, 0, 20)
ColorLabel.Position = UDim2.new(0, 30, 0, 190)
ColorLabel.BackgroundTransparency = 1
ColorLabel.Text = "Couleur des Ennemis (Glisse sur la barre) :"
ColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
ColorLabel.Font = Enum.Font.Gotham
ColorLabel.TextSize = 11
ColorLabel.Parent = MainFrame

local ColorPicker = Instance.new("TextButton")
ColorPicker.Size = UDim2.new(0, 200, 0, 25)
ColorPicker.Position = UDim2.new(0, 30, 0, 215)
ColorPicker.Text = ""
ColorPicker.BorderSizePixel = 0
ColorPicker.Parent = MainFrame

local PickerCorner = Instance.new("UICorner")
PickerCorner.CornerRadius = UDim.new(0, 6)
