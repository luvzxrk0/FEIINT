--[[
    FEINT - Arena Game Manager
    Manages the game state, player lifecycle, and blade spawning
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local GameManager = {}
GameManager.ActivePlayers = {}
GameManager.GameActive = false
GameManager.MinPlayers = 2

-- Game state
local function setupPlayer(player)
    -- Add player to active players list
    table.insert(GameManager.ActivePlayers, player)
    
    -- Initialize player stats
    if not player:FindFirstChild("PlayerStats") then
        local stats = Instance.new("Folder")
        stats.Name = "PlayerStats"
        stats.Parent = player
        
        local movementScore = Instance.new("NumberValue")
        movementScore.Name = "MovementScore"
        movementScore.Value = 0
        movementScore.Parent = stats
        
        local dodgeCount = Instance.new("NumberValue")
        dodgeCount.Name = "DodgeCount"
        dodgeCount.Value = 0
        dodgeCount.Parent = stats
        
        local parryCount = Instance.new("NumberValue")
        parryCount.Name = "ParryCount"
        parryCount.Value = 0
        parryCount.Parent = stats
        
        local isAlive = Instance.new("BoolValue")
        isAlive.Name = "IsAlive"
        isAlive.Value = true
        isAlive.Parent = stats
    end
    
    -- Set spawn location
    if player.Character then
        local character = player.Character
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            -- Spawn players around the arena perimeter
            local angle = math.random() * math.pi * 2
            local radius = 50
            hrp.CFrame = CFrame.new(
                math.cos(angle) * radius,
                5,
                math.sin(angle) * radius
            )
        end
    end
end

local function removePlayer(player)
    for i, p in ipairs(GameManager.ActivePlayers) do
        if p == player then
            table.remove(GameManager.ActivePlayers, i)
            break
        end
    end
end

local function checkWinCondition()
    local alivePlayers = 0
    local winner = nil
    
    for _, player in ipairs(GameManager.ActivePlayers) do
        local stats = player:FindFirstChild("PlayerStats")
        if stats then
            local isAlive = stats:FindFirstChild("IsAlive")
            if isAlive and isAlive.Value then
                alivePlayers = alivePlayers + 1
                winner = player
            end
        end
    end
    
    if alivePlayers <= 1 and GameManager.GameActive then
        GameManager.GameActive = false
        if winner then
            print(winner.Name .. " wins!")
            -- Fire win event
            local winEvent = ReplicatedStorage:FindFirstChild("GameWin")
            if winEvent then
                winEvent:FireAllClients(winner)
            end
        end
        -- Restart game after delay
        task.wait(5)
        GameManager.startGame()
    end
end

function GameManager.startGame()
    -- Reset game state
    GameManager.GameActive = true
    GameManager.ActivePlayers = {}
    
    -- Setup all current players
    for _, player in ipairs(Players:GetPlayers()) do
        setupPlayer(player)
    end
    
    -- Check if enough players
    if #GameManager.ActivePlayers < GameManager.MinPlayers then
        print("Waiting for more players...")
        GameManager.GameActive = false
        return
    end
    
    print("Game starting with " .. #GameManager.ActivePlayers .. " players!")
    
    -- Notify clients
    local startEvent = ReplicatedStorage:FindFirstChild("GameStart")
    if startEvent then
        startEvent:FireAllClients()
    end
    
    -- Initialize blade
    local BladeController = require(script.Parent.BladeController)
    BladeController.initialize()
end

function GameManager.eliminatePlayer(player)
    local stats = player:FindFirstChild("PlayerStats")
    if stats then
        local isAlive = stats:FindFirstChild("IsAlive")
        if isAlive then
            isAlive.Value = false
            
            -- Eliminate character
            if player.Character then
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Health = 0
                end
            end
            
            print(player.Name .. " eliminated!")
            checkWinCondition()
        end
    end
end

-- Connect player events
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if GameManager.GameActive then
            setupPlayer(player)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    removePlayer(player)
    if GameManager.GameActive then
        checkWinCondition()
    end
end)

-- Start game when enough players join
task.spawn(function()
    while true do
        task.wait(5)
        if not GameManager.GameActive and #Players:GetPlayers() >= GameManager.MinPlayers then
            GameManager.startGame()
        end
    end
end)

return GameManager
