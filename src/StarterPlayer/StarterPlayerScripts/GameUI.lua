--[[
    FEINT - Game UI
    Displays game information and status to players
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create main UI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GameUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Title/Info Frame
local infoFrame = Instance.new("Frame")
infoFrame.Name = "InfoFrame"
infoFrame.Size = UDim2.new(0, 300, 0, 120)
infoFrame.Position = UDim2.new(0, 10, 0, 10)
infoFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
infoFrame.BackgroundTransparency = 0.3
infoFrame.BorderSizePixel = 2
infoFrame.BorderColor3 = Color3.fromRGB(200, 0, 0)
infoFrame.Parent = screenGui

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "FEINT"
titleLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = infoFrame

local controlsLabel = Instance.new("TextLabel")
controlsLabel.Name = "Controls"
controlsLabel.Size = UDim2.new(1, -10, 0, 80)
controlsLabel.Position = UDim2.new(0, 5, 0, 35)
controlsLabel.BackgroundTransparency = 1
controlsLabel.Text = "Q - Real Parry\nE - Fake Parry (Bluff)\n\nSurvive the blade!"
controlsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
controlsLabel.TextSize = 14
controlsLabel.Font = Enum.Font.Gotham
controlsLabel.TextXAlignment = Enum.TextXAlignment.Left
controlsLabel.TextYAlignment = Enum.TextYAlignment.Top
controlsLabel.Parent = infoFrame

-- Stats Frame
local statsFrame = Instance.new("Frame")
statsFrame.Name = "StatsFrame"
statsFrame.Size = UDim2.new(0, 200, 0, 100)
statsFrame.Position = UDim2.new(0, 10, 0, 140)
statsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
statsFrame.BackgroundTransparency = 0.3
statsFrame.BorderSizePixel = 2
statsFrame.BorderColor3 = Color3.fromRGB(100, 100, 100)
statsFrame.Parent = screenGui

local statsTitle = Instance.new("TextLabel")
statsTitle.Name = "StatsTitle"
statsTitle.Size = UDim2.new(1, 0, 0, 25)
statsTitle.BackgroundTransparency = 1
statsTitle.Text = "Your Stats"
statsTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
statsTitle.TextSize = 16
statsTitle.Font = Enum.Font.GothamBold
statsTitle.Parent = statsFrame

local statsText = Instance.new("TextLabel")
statsText.Name = "StatsText"
statsText.Size = UDim2.new(1, -10, 1, -30)
statsText.Position = UDim2.new(0, 5, 0, 25)
statsText.BackgroundTransparency = 1
statsText.Text = "Parries: 0\nDodges: 0\nStatus: Alive"
statsText.TextColor3 = Color3.fromRGB(255, 255, 255)
statsText.TextSize = 14
statsText.Font = Enum.Font.Gotham
statsText.TextXAlignment = Enum.TextXAlignment.Left
statsText.TextYAlignment = Enum.TextYAlignment.Top
statsText.Parent = statsFrame

-- Blade Speed Indicator
local speedFrame = Instance.new("Frame")
speedFrame.Name = "SpeedFrame"
speedFrame.Size = UDim2.new(0, 200, 0, 50)
speedFrame.Position = UDim2.new(1, -210, 0, 10)
speedFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
speedFrame.BackgroundTransparency = 0.3
speedFrame.BorderSizePixel = 2
speedFrame.BorderColor3 = Color3.fromRGB(200, 0, 0)
speedFrame.Parent = screenGui

local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Size = UDim2.new(1, 0, 1, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Blade Speed: 60"
speedLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
speedLabel.TextSize = 16
speedLabel.Font = Enum.Font.GothamBold
speedLabel.Parent = speedFrame

-- Update stats periodically
spawn(function()
    while wait(0.5) do
        local stats = player:FindFirstChild("PlayerStats")
        if stats then
            local parries = stats:FindFirstChild("ParryCount")
            local dodges = stats:FindFirstChild("DodgeCount")
            local isAlive = stats:FindFirstChild("IsAlive")
            
            local parryCount = parries and parries.Value or 0
            local dodgeCount = dodges and dodges.Value or 0
            local status = (isAlive and isAlive.Value) and "Alive" or "Eliminated"
            
            statsText.Text = string.format("Parries: %d\nDodges: %d\nStatus: %s", 
                parryCount, dodgeCount, status)
            
            -- Change color based on status
            if status == "Eliminated" then
                statsText.TextColor3 = Color3.fromRGB(200, 100, 100)
            else
                statsText.TextColor3 = Color3.fromRGB(100, 255, 100)
            end
        end
    end
end)

-- Listen for game events
local gameStartEvent = ReplicatedStorage:FindFirstChild("GameStart")
if gameStartEvent then
    gameStartEvent.OnClientEvent:Connect(function()
        -- Show game start notification
        local notification = Instance.new("TextLabel")
        notification.Size = UDim2.new(0, 400, 0, 60)
        notification.Position = UDim2.new(0.5, -200, 0.5, -30)
        notification.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        notification.BackgroundTransparency = 0.3
        notification.BorderSizePixel = 3
        notification.BorderColor3 = Color3.fromRGB(255, 255, 255)
        notification.Text = "GAME STARTING!"
        notification.TextColor3 = Color3.fromRGB(255, 255, 255)
        notification.TextSize = 32
        notification.Font = Enum.Font.GothamBold
        notification.Parent = screenGui
        
        wait(3)
        notification:Destroy()
    end)
end

local gameWinEvent = ReplicatedStorage:FindFirstChild("GameWin")
if gameWinEvent then
    gameWinEvent.OnClientEvent:Connect(function(winner)
        -- Show winner notification
        local notification = Instance.new("TextLabel")
        notification.Size = UDim2.new(0, 500, 0, 80)
        notification.Position = UDim2.new(0.5, -250, 0.5, -40)
        notification.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        notification.BackgroundTransparency = 0.3
        notification.BorderSizePixel = 3
        notification.BorderColor3 = Color3.fromRGB(255, 255, 255)
        
        if winner == player then
            notification.Text = "YOU WIN!"
            notification.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            notification.Text = winner.Name .. " WINS!"
            notification.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
        end
        
        notification.TextColor3 = Color3.fromRGB(255, 255, 255)
        notification.TextSize = 36
        notification.Font = Enum.Font.GothamBold
        notification.Parent = screenGui
        
        wait(5)
        notification:Destroy()
    end)
end

print("Game UI initialized")
