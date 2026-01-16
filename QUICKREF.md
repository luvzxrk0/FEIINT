# FEINT - Quick Reference Card

## 🎮 Controls

| Key | Action | Effect |
|-----|--------|--------|
| **Q** | Real Parry | 0.15s timing window, deflects blade |
| **E** | Fake Parry | Visual bluff, no defense |
| **WASD** | Move | Navigate arena |
| **Space** | Jump | Standard jump |

## 📊 Game Stats

### Starting Values
- **Blade Speed**: 60 units/second
- **Parry Window**: 0.15 seconds
- **Targeting Duration**: 1.5 seconds
- **Parry Cooldown**: 0.5 seconds
- **Min Players**: 2

### Progression
- **Speed Increase**: +5 per parry/elimination
- **Target Selection**: Based on movement & behavior
- **Win Condition**: Last player alive

## 🎯 Strategy Tips

### For Beginners
1. **Watch for the red line** - shows who's targeted
2. **Keep moving** - stationary = easy target
3. **Practice parry timing** - it's precise!
4. **Don't spam Q** - cooldown leaves you vulnerable
5. **Use E to bluff** - fake parries can confuse the blade

### Advanced Tactics
1. **Movement patterns** - change direction frequently
2. **Bait attacks** - use fake parries strategically
3. **Edge positioning** - use arena boundaries
4. **Timing mastery** - learn the 0.15s window
5. **Risk/reward** - moving more = higher target priority

## 🔴 Visual Indicators

| Color | Meaning |
|-------|---------|
| **Red Blade** | The autonomous blade |
| **Red Line** | Targeting indicator |
| **Red Screen Flash** | You are the target! |
| **Blue Aura** | Parry active (real or fake) |
| **Red Glow** | Blade point light |
| **Trail** | Blade movement history |

## 📈 Player Stats

### Tracked Metrics
- **Parry Count**: Successful deflections
- **Dodge Count**: Times blade missed
- **Movement Score**: Activity level
- **Status**: Alive or Eliminated

### Display Location
- Top-left: Controls & game info
- Below controls: Your personal stats
- Top-right: Current blade speed

## ⚡ Blade Behavior

### Targeting Priority (Highest to Lowest)
1. High parry count (+15 per parry)
2. High dodge count (+10 per dodge)
3. High movement speed (+2 per unit/sec)
4. Frequent direction changes (+5 per change)
5. Random baseline (0-100)

### Attack Cycle
1. Select target (behavior analysis)
2. Show red line (1.5 seconds)
3. Orient and dash (speed-based)
4. Collision detection
5. Speed increase
6. Retarget (0.5s delay)
7. Repeat

## 🏆 Win Conditions

### Victory
- Be the last player alive
- Survive through skill and strategy
- Game announces winner
- Auto-restart after 5 seconds

### Defeat
- Hit by blade without parry
- Health drops to 0
- Status: Eliminated
- Can spectate until restart

## 🎬 Game Flow

```
Start (2+ players)
    ↓
Players spawn in circle
    ↓
Blade appears at center
    ↓
╔═══════════════╗
║ Attack Cycle: ║
║ 1. Target     ║
║ 2. Warn       ║
║ 3. Dash       ║
║ 4. Hit/Parry  ║
║ 5. Speed++    ║
║ 6. Retarget   ║
╚═══════════════╝
    ↓
Repeat until 1 player
    ↓
Announce winner
    ↓
Restart game
```

## 💡 Quick Troubleshooting

| Problem | Solution |
|---------|----------|
| Game won't start | Need 2+ players |
| No UI visible | Check StarterPlayerScripts |
| Parry not working | Verify Q key, check timing |
| Blade not spawning | Check Output for errors |
| No targeting line | Script may have error |
| Stats not updating | Verify PlayerStats folder |

## 🔧 Quick Config Changes

### Make Parry Easier
In `BladeController.lua` line ~17:
```lua
local PARRY_WINDOW = 0.25  -- was 0.15
```

### Slower Blade
In `BladeController.lua` line ~11:
```lua
BladeController.BaseSpeed = 40  -- was 60
```

### More Warning Time
In `BladeController.lua` line ~16:
```lua
local TARGETING_DURATION = 2.5  -- was 1.5
```

### Smaller Arena
In `GameManager.lua` line ~40:
```lua
local radius = 35  -- was 50
```

## 📝 File Locations

```
ServerScriptService/
├── MainServer (Script)
├── GameManager (ModuleScript)
└── BladeController (ModuleScript)

ReplicatedStorage/
└── RemoteEventsSetup (ModuleScript)

StarterPlayer/StarterPlayerScripts/
├── ParrySystem (LocalScript)
└── GameUI (LocalScript)
```

## 🎓 Learning Resources

- **README.md**: Full documentation
- **INSTALLATION.md**: Setup guide
- **FEATURES.md**: Complete feature list
- **TESTING.md**: Testing checklist
- **Code comments**: In-depth explanations

## 🚀 Performance Tips

1. Test with 2-8 players for best experience
2. Simple arena = better performance
3. Avoid heavy decorations near blade
4. Monitor Output for warnings
5. Keep scripts organized

## 🎨 Customization

### Easy Changes
- Blade color (BladeController.lua line ~43)
- UI colors (GameUI.lua various lines)
- Arena size (GameManager.lua line ~40)
- Speed values (BladeController.lua top)

### Medium Changes
- Blade model (replace Part with Model)
- Sound effects (add Sound instances)
- Parry animations (load Animation)
- Custom UI layout (modify GameUI.lua)

### Advanced Changes
- Multiple blades (spawn more instances)
- Power-ups (add pickup system)
- Teams (modify GameManager)
- Rounds (add round counter)

---

**Remember**: FEINT rewards skill, strategy, and quick reflexes. Practice makes perfect! 🎮
