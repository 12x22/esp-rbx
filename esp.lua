-- ESP HUB "Pink Edition" pour Solara (2026) - Version 4 "Discrète"
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")

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
    Transparency = 0.5,
    FullBright = false,
    NoFog = false,
    Streamproof = false
}

-- Sauvegarde des paramètres de lumière d'origine du jeu
local OriginalLighting = {
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime,
    FogEnd = Lighting.FogEnd,
    FogStart = Lighting.FogStart
}

-- Boucle pour forcer les modifications de l'Ambiancer et No Fog
local LightingConnection
LightingConnection = game:GetService("RunService").RenderStepped:Connect(function()
    if Config.FullBright then
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 3
        Lighting.ClockTime = 12
    end
    if Config.NoFog then
        Lighting.FogStart = 999999
        Lighting.FogEnd = 999999
    end
end)

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
MainFrame.Size = UDim2.new(0, 260, 0, 480) -- Taille augmentée pour intégrer proprement No Fog et visuels
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

-- Fonction de nettoyage d'urgence (Panic Function)
local function PanicUnload()
    Config.Enabled = false
    Config.FullBright = false
    Config.NoFog = false
    RefreshAllESP()
    if LightingConnection then LightingConnection:Disconnect() end
    
    -- Restauration des lumières d'origine
    Lighting.Ambient = OriginalLighting.Ambient
    Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
    Lighting.Brightness = OriginalLighting.Brightness
    Lighting.ClockTime = OriginalLighting.ClockTime
    Lighting.FogStart = OriginalLighting.FogStart
    Lighting.FogEnd = OriginalLighting.FogEnd
    
    -- Destruction de l'interface graphique
    ScreenGui:Destroy()
end

-- Gestion des touches clavier (Right Shift = Masquer / End = Panique Totale)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed then
        if input.KeyCode == Enum.KeyCode.RightShift then
            MainFrame.Visible = not MainFrame.Visible
        elseif input.KeyCode == Enum.KeyCode.End then
            PanicUnload()
        end
    end
end)

-- Titre
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "🦇 4_6 HUB v4 🦇"
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

-- Boutons de Contrôle
local ToggleESP = CreateButton("ESP : ACTIVÉ", UDim2.new(0, 30, 0, 50), UDim2.new(0, 200, 0, 32), Color3.fromRGB(255, 105, 180), function() end)
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

local ToggleTeam = CreateButton("TEAM CHECK : DÉSACTIVÉ", UDim2.new(0, 30, 0, 90), UDim2.new(0, 200, 0, 32), Color3.fromRGB(50, 40, 45), function() end)
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

local ToggleBright = CreateButton("AMBIANCER : DÉSACTIVÉ", UDim2.new(0, 30, 0, 130), UDim2.new(0, 200, 0, 32), Color3.fromRGB(50, 40, 45), function() end)
ToggleBright.MouseButton1Click:Connect(function()
    Config.FullBright = not Config.FullBright
    if Config.FullBright then
        ToggleBright.Text = "AMBIANCER : MAX LUMENS"
        ToggleBright.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    else
        ToggleBright.Text = "AMBIANCER : DÉSACTIVÉ"
        ToggleBright.BackgroundColor3 = Color3.fromRGB(50, 40, 45)
        Lighting.Ambient = OriginalLighting.Ambient
        Lighting.OutdoorAmbient = OriginalLighting.OutdoorAmbient
        Lighting.Brightness = OriginalLighting.Brightness
        Lighting.ClockTime = OriginalLighting.ClockTime
    end
end)

local ToggleFog = CreateButton("NO FOG : DÉSACTIVÉ", UDim2.new(0, 30, 0, 170), UDim2.new(0, 200, 0, 32), Color3.fromRGB(50, 40, 45), function() end)
ToggleFog.MouseButton1Click:Connect(function()
    Config.NoFog = not Config.NoFog
    if Config.NoFog then
        ToggleFog.Text = "NO FOG : ACTIVÉ"
        ToggleFog.BackgroundColor3 = Color3.fromRGB(0, 180, 150)
    else
        ToggleFog.Text = "NO FOG : DÉSACTIVÉ"
