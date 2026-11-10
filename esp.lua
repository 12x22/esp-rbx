local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

-- Configuration de base
local Config = {
    Enabled = true,
    TeamCheck = true,
    EnemyColor = Color3.fromRGB(255, 0, 50),
    AllyColor = Color3.fromRGB(0, 150, 255)
}

-- Liste des couleurs disponibles (Rouge, Bleu, Vert, Jaune, Violet)
local ColorsTable = {
    Color3.fromRGB(255, 0, 50),
    Color3.fromRGB(0, 150, 255),
    Color3.fromRGB(0, 255, 100),
    Color3.fromRGB(255, 230, 0),
    Color3.fromRGB(180, 0, 255)
}
local enemyColorIndex = 1
local allyColorIndex = 2

-- Gestion de l'ESP
local function UpdateESP(player)
    if player == LocalPlayer then return end
    
    local function SetupHighlight(character)
        local highlight = character:FindFirstChild("Hub_ESP")
        if not Config.Enabled then
            if highlight then highlight:Destroy() end
            return
        end
        
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "Hub_ESP"
            highlight.Parent = character
            highlight.FillTransparency = 0.4
            highlight.OutlineTransparency = 0
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = character
        end

        local function RefreshColor()
            if not highlight or not highlight.Parent then return end
            if Config.TeamCheck and player.Team == LocalPlayer.Team and player.Team ~= nil then
                highlight.FillColor = Config.AllyColor
            else
                highlight.FillColor = Config.EnemyColor
            end
        end

        RefreshColor()
        player:GetPropertyChangedSignal("Team"):Connect(RefreshColor)
        LocalPlayer:GetPropertyChangedSignal("Team"):Connect(RefreshColor)
    end

    if player.Character then SetupHighlight(player.Character) end
    player.CharacterAdded:Connect(SetupHighlight)
end

local function RefreshAllESP()
    for _, p in ipairs(Players:GetPlayers()) do
        UpdateESP(p)
        if p.Character and not Config.Enabled then
            local hl = p.Character:FindFirstChild("Hub_ESP")
            if hl then hl:Destroy() end
        end
    end
end

Players.PlayerAdded:Connect(UpdateESP)

-- CRÉATION DE L'INTERFACE GRAPHIQUE (UI)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WallhackHub"
ScreenGui.ResetOnSpawn = false
-- Protection anti-détection basique pour CoreGui
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Fenêtre Principale
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 250, 0, 300)
MainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Titre
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "ESP WALLHACK HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Fonction pour créer des boutons stylisés
local function CreateButton(text, position, size, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = size
    Btn.Position = position
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Text = text
    Btn.Font = Enum.Font.Gotham
    Btn.TextSize = 13
    Btn.BorderSizePixel = 0
    Btn.Parent = MainFrame
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Btn
    
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

-- 1. Bouton Activer / Désactiver l'ESP
local ToggleESP = CreateButton("ESP : ACTIVÉ", UDim2.new(0, 25, 0, 60), UDim2.new(0, 200, 0, 40), function() end)
ToggleESP.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
ToggleESP.MouseButton1Click:Connect(function()
    Config.Enabled = not Config.Enabled
    if Config.Enabled then
        ToggleESP.Text = "ESP : ACTIVÉ"
        ToggleESP.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
    else
        ToggleESP.Text = "ESP : DÉSACTIVÉ"
        ToggleESP.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    end
    RefreshAllESP()
end)

-- 2. Bouton Team Check
local ToggleTeam = CreateButton("TEAM CHECK : ACTIVÉ", UDim2.new(0, 25, 0, 115), UDim2.new(0, 200, 0, 40), function() end)
ToggleTeam.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
ToggleTeam.MouseButton1Click:Connect(function()
    Config.TeamCheck = not Config.TeamCheck
    if Config.TeamCheck then
        ToggleTeam.Text = "TEAM CHECK : ACTIVÉ"
        ToggleTeam.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    else
        ToggleTeam.Text = "TEAM CHECK : DÉSACTIVÉ"
        ToggleTeam.BackgroundColor3 = Color3.fromRGB(100, 100, 110)
    end
    RefreshAllESP()
end)

-- 3. Changement couleur Ennemis
local EnemyColorBtn = CreateButton("Couleur Ennemi", UDim2.new(0, 25, 0, 175), UDim2.new(0, 200, 0, 40), function()
    enemyColorIndex = enemyColorIndex % #ColorsTable + 1
    Config.EnemyColor = ColorsTable[enemyColorIndex]
    RefreshAllESP()
end)

-- 4. Changement couleur Alliés
local AllyColorBtn = CreateButton("Couleur Allié", UDim2.new(0, 25, 0, 230), UDim2.new(0, 200, 0, 40), function()
    allyColorIndex = allyColorIndex % #ColorsTable + 1
    Config.AllyColor = ColorsTable[allyColorIndex]
    RefreshAllESP()
end)

-- Lancement initial
RefreshAllESP()
