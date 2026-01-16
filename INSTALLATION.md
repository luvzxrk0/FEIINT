# FEINT Installation Guide

This guide will help you install FEINT into your Roblox game.

## Quick Setup (5 minutes)

### Step 1: Prepare Roblox Studio
1. Open **Roblox Studio**
2. Create a new **Baseplate** game or open your existing place
3. Make sure you have the Explorer and Properties windows visible

### Step 2: Create Folder Structure
In the Explorer window, you'll be copying scripts to these locations:

```
ServerScriptService/
├── MainServer (Script)
├── GameManager (ModuleScript)
└── BladeController (ModuleScript)

ReplicatedStorage/
└── RemoteEventsSetup (ModuleScript)

StarterPlayer/
└── StarterPlayerScripts/
    ├── ParrySystem (LocalScript)
    └── GameUI (LocalScript)
```

### Step 3: Add Server Scripts

1. **In ServerScriptService**, create a **Script** named `MainServer`
   - Copy the contents of `src/ServerScriptService/MainServer.lua`
   - Paste into the script

2. **In ServerScriptService**, create a **ModuleScript** named `GameManager`
   - Copy the contents of `src/ServerScriptService/GameManager.lua`
   - Paste into the module

3. **In ServerScriptService**, create a **ModuleScript** named `BladeController`
   - Copy the contents of `src/ServerScriptService/BladeController.lua`
   - Paste into the module

### Step 4: Add ReplicatedStorage Script

1. **In ReplicatedStorage**, create a **ModuleScript** named `RemoteEventsSetup`
   - Copy the contents of `src/ReplicatedStorage/RemoteEventsSetup.lua`
   - Paste into the module

### Step 5: Add Client Scripts

1. Navigate to **StarterPlayer** → **StarterPlayerScripts**

2. Create a **LocalScript** named `ParrySystem`
   - Copy the contents of `src/StarterPlayer/StarterPlayerScripts/ParrySystem.lua`
   - Paste into the script

3. Create a **LocalScript** named `GameUI`
   - Copy the contents of `src/StarterPlayer/StarterPlayerScripts/GameUI.lua`
   - Paste into the script

### Step 6: Test the Game

1. Click **Play** in Roblox Studio
2. In the Home tab, click the dropdown arrow next to Play
3. Select **2 Players** or more to test multiplayer
4. The game should automatically start when players join!

## Controls

- **Q** - Real Parry (0.15s timing window)
- **E** - Fake Parry (bluff)
- **WASD** - Move around
- **Space** - Jump

## What Should Happen

1. **Game Starts**: After 2+ players join, you'll see "Game starting!" message
2. **Blade Spawns**: A red blade appears at the center of the arena
3. **Targeting**: The blade shows a red line to its target
4. **Attack**: After 1.5 seconds, the blade dashes toward the target
5. **Parry/Dodge**: Players must parry (Q) or dodge the blade
6. **Speed Increases**: Each deflection or elimination makes the blade faster
7. **Win Condition**: Last player standing wins

## Customization

### Change Arena Size
In `GameManager.lua`, find this line (around line 40):
```lua
local radius = 50
```
Increase/decrease the radius to change the arena size.

### Adjust Blade Speed
In `BladeController.lua`, find:
```lua
BladeController.BaseSpeed = 60
local SPEED_INCREMENT = 5
```
- `BaseSpeed`: Starting speed of the blade
- `SPEED_INCREMENT`: How much faster it gets per action

### Change Parry Window
In `BladeController.lua`, find:
```lua
local PARRY_WINDOW = 0.15
```
Increase to make parrying easier, decrease for more difficulty.

### Minimum Players
In `GameManager.lua`, find:
```lua
GameManager.MinPlayers = 2
```
Change to require more players before starting.

## Troubleshooting

### "Attempt to index nil" errors
- Make sure all ModuleScripts are named correctly
- Verify scripts are in the correct locations
- Check that you copied the entire script content

### Game doesn't start
- Test with at least 2 players
- Check the Output window for error messages
- Ensure MainServer script is enabled

### Blade doesn't appear
- Check workspace for the "Blade" part
- Look in Output for initialization messages
- Verify BladeController module has no errors

### Parry not working
- Make sure your character has loaded
- Check that the LocalScripts are running
- Verify RemoteEvents were created in ReplicatedStorage

### Players spawn in wrong location
- The game spawns players in a circle around (0, 0, 0)
- Adjust the spawn code in `GameManager.lua` if needed
- Make sure your spawn location isn't interfering

## Advanced Setup

### Adding Custom Blade Model

1. Create or import a blade model in workspace
2. In `BladeController.lua`, modify the `createBlade()` function
3. Replace the Part creation with your model
4. Ensure your model has a PrimaryPart set

### Adding Sounds

1. Upload sound files to Roblox
2. Add sound objects to the blade or character
3. Play sounds in response to events:
   - Blade targeting
   - Successful parry
   - Player elimination
   - Blade dash

Example:
```lua
local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://YOUR_SOUND_ID"
sound.Parent = blade
sound:Play()
```

### Creating a Lobby

1. Create a separate spawn area away from the arena
2. Add a teleport system to move players to the arena
3. Modify `GameManager.lua` to teleport players on game start

## Need Help?

- Check the main README.md for detailed documentation
- Review the code comments in each script
- Test in Studio's Output window to see error messages
- Make sure all scripts are enabled and not disabled

## Next Steps

- Design a custom arena map
- Add obstacles and cover
- Create custom blade models
- Add sound effects and music
- Implement spectator mode for eliminated players
- Add a lobby system
- Create leaderboards and stats tracking

Happy developing! 🎮
