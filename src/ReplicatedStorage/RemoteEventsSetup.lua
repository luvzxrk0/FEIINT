--[[
    FEINT - Remote Events Setup
    Creates all necessary RemoteEvents for client-server communication
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create remote events folder
local remoteEventsFolder = ReplicatedStorage:FindFirstChild("RemoteEvents")
if not remoteEventsFolder then
    remoteEventsFolder = Instance.new("Folder")
    remoteEventsFolder.Name = "RemoteEvents"
    remoteEventsFolder.Parent = ReplicatedStorage
end

-- Function to create or get remote event
local function createRemoteEvent(name)
    local existing = ReplicatedStorage:FindFirstChild(name)
    if existing and existing:IsA("RemoteEvent") then
        return existing
    end
    
    local remoteEvent = Instance.new("RemoteEvent")
    remoteEvent.Name = name
    remoteEvent.Parent = ReplicatedStorage
    return remoteEvent
end

-- Create all remote events
local remoteEvents = {
    "GameStart",        -- Fired when game starts
    "GameWin",          -- Fired when a player wins
    "BladeTargeting",   -- Fired when blade targets a player
    "BladeHit",         -- Fired when blade hits a player
    "BladeParried",     -- Fired when blade is parried
    "PlayerParry",      -- Client -> Server: player performs real parry
    "PlayerFakeParry",  -- Client -> Server: player performs fake parry
}

for _, eventName in ipairs(remoteEvents) do
    createRemoteEvent(eventName)
end

print("Remote events initialized")

-- Handle server-side parry events
local playerParryEvent = ReplicatedStorage:FindFirstChild("PlayerParry")
if playerParryEvent then
    playerParryEvent.OnServerEvent:Connect(function(player, isRealParry)
        -- Server validates parry
        print(player.Name .. " performed a parry")
    end)
end

local fakeParryEvent = ReplicatedStorage:FindFirstChild("PlayerFakeParry")
if fakeParryEvent then
    fakeParryEvent.OnServerEvent:Connect(function(player)
        -- Server notes fake parry (for behavior tracking)
        print(player.Name .. " performed a fake parry (bluff)")
    end)
end
