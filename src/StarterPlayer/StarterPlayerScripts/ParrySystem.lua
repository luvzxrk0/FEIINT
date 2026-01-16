--[[
    FEINT - Parry System (Client)
    Handles real parries and fake parry bluffs
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Parry state
local isParrying = false
local isFakeParrying = false
local canParry = true
local parryCooldown = 0.5

-- Visual feedback
local parryAura = nil

local function createParryAura()
    if not character:FindFirstChild("HumanoidRootPart") then return end
    
    local aura = Instance.new("Part")
    aura.Name = "ParryAura"
    aura.Size = Vector3.new(6, 6, 6)
    aura.Material = Enum.Material.ForceField
    aura.Color = Color3.fromRGB(100, 200, 255)
    aura.CanCollide = false
    aura.Anchored = true
    aura.Transparency = 0.7
    aura.Shape = Enum.PartType.Ball
    aura.CFrame = character.HumanoidRootPart.CFrame
    
    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(100, 200, 255)
    light.Brightness = 5
    light.Range = 15
    light.Parent = aura
    
    aura.Parent = character
    return aura
end

local function performRealParry()
    if not canParry then
        print("Parry on cooldown!")
        return
    end
    
    if isParrying or isFakeParrying then
        return
    end
    
    print("Real parry activated!")
    isParrying = true
    canParry = false
    
    -- Create parry flag on character
    local parryFlag = Instance.new("BoolValue")
    parryFlag.Name = "IsParrying"
    parryFlag.Value = true
    parryFlag.Parent = character
    
    -- Visual effect
    parryAura = createParryAura()
    
    -- Play parry animation (if exists)
    local animator = humanoid:FindFirstChild("Animator")
    if animator then
        -- You would load a parry animation here
        -- local parryAnim = animator:LoadAnimation(parryAnimation)
        -- parryAnim:Play()
    end
    
    -- Notify server
    local parryEvent = ReplicatedStorage:FindFirstChild("PlayerParry")
    if parryEvent then
        parryEvent:FireServer(true)
    end
    
    -- Parry window (0.15 seconds for precise timing)
    task.wait(0.15)
    
    isParrying = false
    if parryFlag then
        parryFlag:Destroy()
    end
    if parryAura then
        parryAura:Destroy()
    end
    
    -- Cooldown
    task.spawn(function()
        task.wait(parryCooldown)
        canParry = true
    end)
end

local function performFakeParry()
    if isFakeParrying or isParrying then
        return
    end
    
    print("Fake parry (bluff) activated!")
    isFakeParrying = true
    
    -- Visual effect (same as real parry to bluff)
    parryAura = createParryAura()
    
    -- Play same animation to sell the bluff
    local animator = humanoid:FindFirstChild("Animator")
    if animator then
        -- Same animation as real parry
    end
    
    -- Notify server (fake parry)
    local fakeParryEvent = ReplicatedStorage:FindFirstChild("PlayerFakeParry")
    if fakeParryEvent then
        fakeParryEvent:FireServer()
    end
    
    -- Longer duration (not effective for actual defense)
    task.wait(0.4)
    
    isFakeParrying = false
    if parryAura then
        parryAura:Destroy()
    end
end

-- Input handling
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Q key for real parry
    if input.KeyCode == Enum.KeyCode.Q then
        performRealParry()
    end
    
    -- E key for fake parry (bluff)
    if input.KeyCode == Enum.KeyCode.E then
        performFakeParry()
    end
end)

-- Listen for targeting events
local targetingEvent = ReplicatedStorage:FindFirstChild("BladeTargeting")
if targetingEvent then
    targetingEvent.OnClientEvent:Connect(function(target, duration)
        if target == player then
            print("You are being targeted! Prepare to parry!")
            
            -- Visual warning (screen flash or UI indicator)
            local gui = player:FindFirstChild("PlayerGui")
            if gui then
                local screenGui = gui:FindFirstChild("TargetWarning")
                if not screenGui then
                    screenGui = Instance.new("ScreenGui")
                    screenGui.Name = "TargetWarning"
                    screenGui.Parent = gui
                    
                    local frame = Instance.new("Frame")
                    frame.Size = UDim2.new(1, 0, 1, 0)
                    frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                    frame.BackgroundTransparency = 0.9
                    frame.BorderSizePixel = 0
                    frame.Parent = screenGui
                    
                    -- Flash effect
                    local tween = TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true), {
                        BackgroundTransparency = 0.7
                    })
                    tween:Play()
                    
                    -- Remove after duration (async to not block event handler)
                    task.spawn(function()
                        task.wait(duration)
                        tween:Cancel()
                        screenGui:Destroy()
                    end)
                end
            end
        end
    end)
end

-- Listen for parry success
local parrySuccessEvent = ReplicatedStorage:FindFirstChild("BladeParried")
if parrySuccessEvent then
    parrySuccessEvent.OnClientEvent:Connect(function(parrier)
        if parrier == player then
            print("SUCCESSFUL PARRY!")
            -- Add success feedback
        end
    end)
end

-- Listen for blade hits
local hitEvent = ReplicatedStorage:FindFirstChild("BladeHit")
if hitEvent then
    hitEvent.OnClientEvent:Connect(function(victim)
        if victim == player then
            print("You were eliminated!")
        end
    end)
end

-- Reconnect on respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    isParrying = false
    isFakeParrying = false
    canParry = true
end)

print("Parry system initialized! Press Q for real parry, E for fake parry (bluff)")
