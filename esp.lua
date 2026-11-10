-- ESP HUB "Pink Edition" pour Solara (2026)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- Configuration des couleurs (Thème Rose / Violet)
local Config = {
    Enabled = true,
    TeamCheck = false, -- Désactivé par défaut pour tout voir en rose !
    EnemyColor = Color3.fromRGB(255, 105, 180), -- Rose Flash (Hot Pink)
    AllyColor = Color3.fromRGB(186, 85, 211)    -- Violet Doux (Medium Orchid)
}

-- Liste des couleurs si elle veut changer
local ColorsTable = {
    Color3.fromRGB(255, 105, 180), -- Rose
    Color3.fromRGB(186, 85, 211), -- Violet
    Color3.fromRGB(255, 192, 203), -- Rose Pastel
    Color3.fromRGB(0, 255, 200),   -- Cyan
    Color3.fromRGB(255, 255, 255)  -- Blanc
}
local enemyColorIndex = 1
local allyColorIndex = 2

-- Gestion de l'ESP (Highlights de Roblox, parfait pour Solara)
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
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Borde Blanco
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = character
        end

        local function RefreshColor()
            if not highlight or not highlight.Parent or not player or not LocalPlayer then return end
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

-- INTERFACE GRAPHIQUE (UI) - THÈME CHIC ROSE & NOIR
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SolaraPinkHub"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Fenêtre Principale
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 280)
MainFrame.Position = UDim2.new(0.1, 0, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 20) -- Noir avec une touche de violet
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Petite barre décorative rose en haut
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 4)
TopBar.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame
local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

-- Système de Drag simple et sécurisé pour Solara
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

-- Titre du Menu
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "🌸 PINK ESP HUB 🌸"
Title.TextColor3 = Color3.fromRGB(255, 105, 180)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Fonction pour créer de jolis boutons arrondis
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

-- Bouton d'activation globale
local ToggleESP = CreateButton("ESP : ACTIVÉ", UDim2.new(0, 20, 0, 55), UDim2.new(0, 200, 0, 35), Color3.fromRGB(255, 105, 180), function() end)
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

-- Bouton Team Check
local ToggleTeam = CreateButton("TEAM CHECK : DÉSACTIVÉ", UDim2.new(0, 20, 0, 105), UDim2.new(0, 200, 0, 35), Color3.fromRGB(50, 40, 45), function() end)
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

-- Changement couleur Ennemi
local EnemyColorBtn = CreateButton("Changer Couleur principale", UDim2.new(0, 20, 0, 165), UDim2.new(0, 200, 0, 35), Color3.fromRGB(35, 30, 35), function()
    enemyColorIndex = enemyColorIndex % #ColorsTable + 1
    Config.EnemyColor = ColorsTable[enemyColorIndex]
    RefreshAllESP()
end)

-- Changement couleur Allié
local AllyColorBtn = CreateButton("Changer Couleur alliés", UDim2.new(0, 20, 0, 215), UDim2.new(0, 200, 0, 35), Color3.fromRGB(35, 30, 35), function()
    allyColorIndex = allyColorIndex % #ColorsTable + 1
    Config.AllyColor = ColorsTable[allyColorIndex]
    RefreshAllESP()
end)

RefreshAllESP()
