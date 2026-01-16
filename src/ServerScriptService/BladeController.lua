--[[
    FEINT - Blade Controller
    Controls the autonomous blade that targets and attacks players
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local BladeController = {}
BladeController.Blade = nil
BladeController.CurrentTarget = nil
BladeController.BaseSpeed = 60
BladeController.CurrentSpeed = 60
BladeController.IsAttacking = false
BladeController.TargetingLine = nil
BladeController.PlayerBehaviorData = {}

-- Constants
local BLADE_SIZE = Vector3.new(1, 0.3, 4)
local TARGETING_DURATION = 1.5
local PARRY_WINDOW = 0.15
local SPEED_INCREMENT = 5

local function createBlade()
    -- Create blade model
    local blade = Instance.new("Part")
    blade.Name = "Blade"
    blade.Size = BLADE_SIZE
    blade.Material = Enum.Material.SmoothPlastic
    blade.Color = Color3.fromRGB(200, 0, 0)
    blade.CanCollide = false
    blade.Anchored = false
    blade.CFrame = CFrame.new(0, 10, 0)
    
    -- Add blade glow effect
    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(255, 0, 0)
    light.Brightness = 2
    light.Range = 15
    light.Parent = blade
    
    -- Add trail effect
    local attachment0 = Instance.new("Attachment")
    attachment0.Position = Vector3.new(0, 0, -2)
    attachment0.Parent = blade
    
    local attachment1 = Instance.new("Attachment")
    attachment1.Position = Vector3.new(0, 0, 2)
    attachment1.Parent = blade
    
    local trail = Instance.new("Trail")
    trail.Attachment0 = attachment0
    trail.Attachment1 = attachment1
    trail.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
    trail.Lifetime = 0.3
    trail.MinLength = 0
    trail.Parent = blade
    
    -- Body velocity for movement
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
    bodyVelocity.P = 10000
    bodyVelocity.Parent = blade
    
    -- Body gyro for orientation
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(0, 0, 0)
    bodyGyro.P = 10000
    bodyGyro.D = 500
    bodyGyro.Parent = blade
    
    blade.Parent = workspace
    return blade
end

local function createTargetingLine()
    local line = Instance.new("Part")
    line.Name = "TargetLine"
    line.Size = Vector3.new(0.2, 0.2, 1)
    line.Material = Enum.Material.Neon
    line.Color = Color3.fromRGB(255, 100, 100)
    line.CanCollide = false
    line.Anchored = true
    line.Transparency = 0.3
    line.Parent = workspace
    return line
end

local function updatePlayerBehavior(player)
    if not BladeController.PlayerBehaviorData[player.UserId] then
        BladeController.PlayerBehaviorData[player.UserId] = {
            lastPosition = nil,
            movementSpeed = 0,
            movementChanges = 0,
            lastUpdateTime = tick()
        }
    end
    
    local data = BladeController.PlayerBehaviorData[player.UserId]
    local character = player.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local currentTime = tick()
    local deltaTime = currentTime - data.lastUpdateTime
    
    if data.lastPosition and deltaTime > 0 then
        local distance = (hrp.Position - data.lastPosition).Magnitude
        local speed = distance / deltaTime
        
        -- Track movement changes (erratic movement)
        if math.abs(speed - data.movementSpeed) > 5 then
            data.movementChanges = data.movementChanges + 1
        end
        
        data.movementSpeed = speed
    end
    
    data.lastPosition = hrp.Position
    data.lastUpdateTime = currentTime
end

local function selectTarget()
    -- Get all alive players
    local alivePlayers = {}
    for _, player in ipairs(Players:GetPlayers()) do
        local stats = player:FindFirstChild("PlayerStats")
        if stats and stats:FindFirstChild("IsAlive") and stats.IsAlive.Value then
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(alivePlayers, player)
            end
        end
    end
    
    if #alivePlayers == 0 then
        return nil
    end
    
    -- Scoring system based on movement and behavior
    local scores = {}
    for _, player in ipairs(alivePlayers) do
        updatePlayerBehavior(player)
        
        local data = BladeController.PlayerBehaviorData[player.UserId]
        local stats = player:FindFirstChild("PlayerStats")
        
        -- Base score
        local score = math.random(0, 100)
        
        -- Prefer moving players
        if data then
            score = score + (data.movementSpeed * 2)
            score = score + (data.movementChanges * 5)
        end
        
        -- Factor in past behavior
        if stats then
            local dodgeCount = stats:FindFirstChild("DodgeCount")
            local parryCount = stats:FindFirstChild("ParryCount")
            
            if dodgeCount then
                score = score + (dodgeCount.Value * 10)
            end
            if parryCount then
                score = score + (parryCount.Value * 15)
            end
        end
        
        scores[player] = score
    end
    
    -- Select highest scoring target
    local bestTarget = nil
    local bestScore = -1
    for player, score in pairs(scores) do
        if score > bestScore then
            bestScore = score
            bestTarget = player
        end
    end
    
    return bestTarget
end

local function showTargetingLine(targetPosition)
    if not BladeController.Blade then return end
    if not BladeController.TargetingLine then
        BladeController.TargetingLine = createTargetingLine()
    end
    
    local line = BladeController.TargetingLine
    local bladePos = BladeController.Blade.Position
    local direction = (targetPosition - bladePos)
    local distance = direction.Magnitude
    
    line.Size = Vector3.new(0.2, 0.2, distance)
    line.CFrame = CFrame.new(bladePos, targetPosition) * CFrame.new(0, 0, -distance/2)
    line.Transparency = 0.3
end

local function hideTargetingLine()
    if BladeController.TargetingLine then
        BladeController.TargetingLine.Transparency = 1
    end
end

local function dashToTarget(targetPosition)
    if not BladeController.Blade then return end
    
    local blade = BladeController.Blade
    local bodyVelocity = blade:FindFirstChild("BodyVelocity")
    local bodyGyro = blade:FindFirstChild("BodyGyro")
    
    if not bodyVelocity or not bodyGyro then return end
    
    -- Calculate direction
    local direction = (targetPosition - blade.Position).Unit
    
    -- Orient blade toward target
    bodyGyro.MaxTorque = Vector3.new(4000, 4000, 4000)
    bodyGyro.CFrame = CFrame.new(blade.Position, targetPosition) * CFrame.Angles(0, 0, math.rad(90))
    
    -- Apply velocity
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = direction * BladeController.CurrentSpeed
    
    BladeController.IsAttacking = true
end

local function stopBlade()
    if not BladeController.Blade then return end
    
    local bodyVelocity = BladeController.Blade:FindFirstChild("BodyVelocity")
    local bodyGyro = BladeController.Blade:FindFirstChild("BodyGyro")
    
    if bodyVelocity then
        bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
    
    if bodyGyro then
        bodyGyro.MaxTorque = Vector3.new(0, 0, 0)
    end
    
    BladeController.IsAttacking = false
end

local function handleBladeCollision(hit)
    if not BladeController.IsAttacking then return end
    if not BladeController.CurrentTarget then return end
    
    local character = hit.Parent
    local player = Players:GetPlayerFromCharacter(character)
    
    if player and player == BladeController.CurrentTarget then
        local humanoid = character:FindFirstChild("Humanoid")
        if not humanoid then return end
        
        -- Check if player is parrying
        local isParrying = character:FindFirstChild("IsParrying")
        if isParrying and isParrying.Value then
            -- Successful parry!
            local stats = player:FindFirstChild("PlayerStats")
            if stats then
                local parryCount = stats:FindFirstChild("ParryCount")
                if parryCount then
                    parryCount.Value = parryCount.Value + 1
                end
            end
            
            -- Increase blade speed
            BladeController.CurrentSpeed = BladeController.CurrentSpeed + SPEED_INCREMENT
            
            print(player.Name .. " parried the blade!")
            
            -- Fire parry event to client
            local parryEvent = ReplicatedStorage:FindFirstChild("BladeParried")
            if parryEvent then
                parryEvent:FireAllClients(player)
            end
            
            -- Stop and retarget
            stopBlade()
            BladeController.CurrentTarget = nil
            wait(0.5)
            BladeController.attackCycle()
        else
            -- Player hit - eliminate
            print(player.Name .. " was hit by the blade!")
            
            local GameManager = require(script.Parent.GameManager)
            GameManager.eliminatePlayer(player)
            
            -- Increase blade speed
            BladeController.CurrentSpeed = BladeController.CurrentSpeed + SPEED_INCREMENT
            
            -- Fire hit event
            local hitEvent = ReplicatedStorage:FindFirstChild("BladeHit")
            if hitEvent then
                hitEvent:FireAllClients(player)
            end
            
            -- Stop and retarget
            stopBlade()
            BladeController.CurrentTarget = nil
            wait(0.5)
            BladeController.attackCycle()
        end
    end
end

function BladeController.attackCycle()
    if not BladeController.Blade then return end
    
    -- Select target
    local target = selectTarget()
    if not target then
        print("No valid targets available")
        wait(2)
        return
    end
    
    BladeController.CurrentTarget = target
    
    local character = target.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local targetPosition = hrp.Position
    
    -- Show targeting line
    showTargetingLine(targetPosition)
    
    -- Fire targeting event to clients
    local targetEvent = ReplicatedStorage:FindFirstChild("BladeTargeting")
    if targetEvent then
        targetEvent:FireAllClients(target, TARGETING_DURATION)
    end
    
    -- Wait for targeting duration
    wait(TARGETING_DURATION)
    
    -- Hide line and dash
    hideTargetingLine()
    
    -- Update target position (player might have moved)
    if character and character:FindFirstChild("HumanoidRootPart") then
        targetPosition = character.HumanoidRootPart.Position
    end
    
    dashToTarget(targetPosition)
    
    -- Wait for dash to complete or collision
    wait(3)
    
    -- If still attacking (no collision), stop and retry
    if BladeController.IsAttacking then
        stopBlade()
        
        -- Track dodge
        local stats = target:FindFirstChild("PlayerStats")
        if stats then
            local dodgeCount = stats:FindFirstChild("DodgeCount")
            if dodgeCount then
                dodgeCount.Value = dodgeCount.Value + 1
            end
        end
    end
    
    BladeController.CurrentTarget = nil
    wait(0.5)
    
    -- Continue cycle
    BladeController.attackCycle()
end

function BladeController.initialize()
    -- Create blade
    if BladeController.Blade then
        BladeController.Blade:Destroy()
    end
    
    BladeController.Blade = createBlade()
    BladeController.CurrentSpeed = BladeController.BaseSpeed
    BladeController.CurrentTarget = nil
    BladeController.IsAttacking = false
    
    -- Connect collision
    BladeController.Blade.Touched:Connect(handleBladeCollision)
    
    -- Start attack cycle
    wait(3) -- Initial delay
    spawn(function()
        BladeController.attackCycle()
    end)
    
    print("Blade initialized and active!")
end

return BladeController
