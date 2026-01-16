--[[
    FEINT - Main Server Script
    Initializes the game systems
]]

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Initialize remote events first
local RemoteEventsSetup = require(ReplicatedStorage.RemoteEventsSetup)

-- Wait a moment for events to be created
task.wait(0.5)

-- Initialize game manager
local GameManager = require(ServerScriptService.GameManager)

print("FEINT Arena Game initialized!")
print("Game will start when " .. GameManager.MinPlayers .. " or more players join")
print("Controls:")
print("  Q - Real Parry (precise timing required)")
print("  E - Fake Parry (bluff)")
