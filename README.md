# FEINT - Roblox Arena Game

An autonomous blade arena survival game for Roblox where players must use precise timing and strategy to survive against an intelligent, adapting blade.

## 🎮 Game Overview

FEINT is a Roblox Lua arena game where:
- **One autonomous blade** spawns at the center of the arena
- The blade **intelligently selects targets** based on player movement and past behavior
- A **visible line** briefly shows the target before the blade dashes forward
- Players can perform a **real parry** (precise 0.15s timing window) to deflect the blade
- Players can use a **fake parry** animation as a bluff to confuse the blade's AI
- Each successful **deflection or elimination increases blade speed**, raising the tension
- The game continues until **one player remains**

## 🎯 Core Mechanics

### Blade Behavior
- **Autonomous targeting**: The blade analyzes player movement speed, direction changes, and past behavior
- **Scoring system**: More active/evasive players are prioritized as targets
- **Visual warning**: A red line appears showing the target before each dash attack
- **Adaptive difficulty**: Blade speed increases by 5 units with each deflection or elimination
- **Smart retargeting**: On successful parry, the blade immediately selects a new target

### Player Actions

#### Real Parry (Q Key)
- **Timing window**: 0.15 seconds (precise timing required)
- **Effect**: Deflects the blade and forces retargeting
- **Cooldown**: 0.5 seconds
- **Visual**: Blue glowing aura around player
- **Increases blade speed** on success

#### Fake Parry (E Key)
- **Duration**: 0.4 seconds (longer than real parry)
- **Effect**: Visual bluff - looks like real parry but doesn't deflect
- **No cooldown**
- **Visual**: Same blue aura to sell the bluff
- **Purpose**: Psychological warfare - can bait the blade or confuse other players

### Behavior Tracking
The blade tracks for each player:
- Movement speed and changes
- Number of successful dodges
- Number of successful parries
- Current position and patterns

Players who move more erratically or have successfully evaded the blade are weighted more heavily in target selection.

## 📁 Project Structure

```
FEIINT/
├── src/
│   ├── ServerScriptService/
│   │   ├── MainServer.lua          # Main initialization script
│   │   ├── GameManager.lua         # Game state and player management
│   │   └── BladeController.lua     # Blade AI and behavior
│   ├── ReplicatedStorage/
│   │   └── RemoteEventsSetup.lua   # Client-server communication
│   └── StarterPlayer/
│       └── StarterPlayerScripts/
│           ├── ParrySystem.lua     # Parry mechanics (client)
│           └── GameUI.lua          # Player interface
└── README.md
```

## 🚀 Installation

### For Roblox Studio:

1. **Clone or download** this repository
2. Open **Roblox Studio**
3. Create a new **Baseplate** or open your existing place
4. **Copy the scripts** from the `src/` folder to their corresponding locations:
   - `ServerScriptService/MainServer.lua` → ServerScriptService
   - `ServerScriptService/GameManager.lua` → ServerScriptService
   - `ServerScriptService/BladeController.lua` → ServerScriptService
   - `ReplicatedStorage/RemoteEventsSetup.lua` → ReplicatedStorage
   - `StarterPlayer/StarterPlayerScripts/ParrySystem.lua` → StarterPlayer > StarterPlayerScripts
   - `StarterPlayer/StarterPlayerScripts/GameUI.lua` → StarterPlayer > StarterPlayerScripts

5. **Run the game** with at least 2 players (use "Test" > "Players" to simulate multiple players)

### Required Setup:
- The game will automatically create all necessary RemoteEvents
- An arena spawns players in a circle (50 stud radius)
- The blade spawns at (0, 10, 0) - adjust as needed for your map

## 🎮 How to Play

1. **Join the game** - Wait for at least 2 players
2. **Survive the blade** - Dodge or parry incoming attacks
3. **Watch for the red line** - This shows you who the blade is targeting
4. **Time your parry** - Press Q at the exact moment of impact (0.15s window)
5. **Use fake parries strategically** - Press E to bluff and confuse the AI
6. **Be the last one standing** - Win by surviving when all others are eliminated

### Pro Tips:
- **Keep moving** - Stationary players are easier targets
- **Watch the targeting line** - Know when you're in danger
- **Don't spam parry** - The cooldown leaves you vulnerable
- **Mix real and fake parries** - Keep the blade's AI guessing
- **Learn the timing** - The 0.15s window is tight but learnable
- **Blade gets faster** - Early eliminations make late-game harder

## ⚙️ Configuration

Edit these constants in the scripts to customize gameplay:

### BladeController.lua
```lua
local BLADE_SIZE = Vector3.new(1, 0.3, 4)  -- Blade dimensions
local TARGETING_DURATION = 1.5              -- Warning time before dash
local PARRY_WINDOW = 0.15                   -- Parry timing window
local SPEED_INCREMENT = 5                   -- Speed increase per action
BladeController.BaseSpeed = 60              -- Starting speed
```

### GameManager.lua
```lua
GameManager.MinPlayers = 2                  -- Minimum players to start
```

### ParrySystem.lua
```lua
local parryCooldown = 0.5                   -- Cooldown between real parries
```

## 🎨 Customization Ideas

- **Custom blade models**: Replace the Part with a MeshPart or Model
- **Arena design**: Create an interesting map with obstacles
- **Sound effects**: Add audio for targeting, parrying, and hits
- **Animations**: Create custom parry animations
- **Power-ups**: Add temporary abilities or blade slowdowns
- **Multiple blades**: Spawn additional blades at certain thresholds
- **Team mode**: Players work together to survive waves

## 🐛 Troubleshooting

**Game won't start:**
- Ensure at least 2 players are in the server
- Check that all scripts are in the correct locations
- Verify RemoteEvents are created in ReplicatedStorage

**Parry not working:**
- Check that the character has a HumanoidRootPart
- Ensure the IsParrying BoolValue is being created
- Verify the blade's Touched event is connected

**Blade not moving:**
- Check workspace for the "Blade" part
- Verify BodyVelocity and BodyGyro are present
- Check console for error messages

## 📝 Technical Details

### Client-Server Architecture
- **Server authoritative**: All game logic runs on the server
- **Client prediction**: Visual feedback is immediate
- **RemoteEvents**: Used for synchronization and notifications
- **Security**: Server validates all parry attempts

### Performance Considerations
- Efficient targeting algorithm (O(n) where n = player count)
- Minimal network traffic (events only fire when necessary)
- Optimized visual effects (simple parts and tweens)

## 📜 License

This project is provided as-is for educational and entertainment purposes. Feel free to modify and use in your own Roblox games.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to check the issues page or submit pull requests.

## ✨ Credits

Created as a demonstration of advanced Roblox Lua game mechanics including:
- AI-driven NPC behavior
- Client-server synchronization
- Precise timing-based gameplay
- Behavioral analysis and adaptation