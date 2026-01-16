# FEINT Testing Checklist

Use this checklist when testing the game in Roblox Studio.

## Pre-Test Setup

- [ ] All scripts copied to correct locations in Roblox Studio
- [ ] ServerScriptService contains: MainServer, GameManager, BladeController
- [ ] ReplicatedStorage contains: RemoteEventsSetup
- [ ] StarterPlayerScripts contains: ParrySystem, GameUI
- [ ] Test with at least 2 players (use Test > Players > 2 Players or more)

## 1. Game Initialization Tests

### Server Startup
- [ ] No errors in Output window
- [ ] "Remote events initialized" message appears
- [ ] "FEINT Arena Game initialized!" message appears
- [ ] Game shows waiting message if fewer than 2 players

### Client Startup
- [ ] UI appears in top-left corner showing "FEINT" title
- [ ] Controls displayed: "Q - Real Parry, E - Fake Parry"
- [ ] Stats frame shows "Your Stats" with initial values
- [ ] Blade Speed indicator shows in top-right corner
- [ ] "Game UI initialized" message in output
- [ ] "Parry system initialized!" message in output

## 2. Game Start Tests

### Player Spawning
- [ ] Players spawn in circular pattern around center
- [ ] Each player approximately 50 studs from center
- [ ] Players spawn at Y=5 (above ground)
- [ ] All players receive PlayerStats folder
- [ ] PlayerStats contains: MovementScore, DodgeCount, ParryCount, IsAlive
- [ ] IsAlive value is true for all players

### Game Start Event
- [ ] "Game starting with X players!" appears in output
- [ ] "GAME STARTING!" notification shows on screen
- [ ] Notification disappears after 3 seconds
- [ ] Stats UI updates properly

## 3. Blade Tests

### Blade Spawning
- [ ] Red blade appears at center (0, 10, 0)
- [ ] Blade has correct size (1 x 0.3 x 4)
- [ ] Red point light visible around blade
- [ ] Trail effect follows blade movement
- [ ] "Blade initialized and active!" message appears

### Blade Targeting
- [ ] Blade waits ~3 seconds before first attack
- [ ] Red targeting line appears showing target
- [ ] Line connects blade to target player
- [ ] Targeted player's screen flashes red
- [ ] Target warning UI appears for targeted player
- [ ] Targeting lasts 1.5 seconds
- [ ] Line disappears before dash

### Blade Movement
- [ ] Blade orients toward target
- [ ] Blade dashes forward at appropriate speed
- [ ] Blade rotates to face direction of movement
- [ ] Trail effect is visible during dash
- [ ] Blade speed starts at 60 units/second

## 4. Player Interaction Tests

### Movement Tracking
- [ ] Moving players have updated MovementScore
- [ ] Stationary players have lower movement scores
- [ ] Erratic movement increases targeting priority
- [ ] Player positions are tracked continuously

### Real Parry (Q Key)
- [ ] Pressing Q creates blue aura around player
- [ ] Aura lasts for 0.15 seconds
- [ ] "Real parry activated!" appears in output
- [ ] IsParrying BoolValue created on character
- [ ] Cooldown prevents immediate second parry
- [ ] "Parry on cooldown!" message if spammed
- [ ] Can parry again after 0.5 seconds

### Fake Parry (E Key)
- [ ] Pressing E creates blue aura around player
- [ ] Aura looks identical to real parry
- [ ] "Fake parry (bluff) activated!" appears in output
- [ ] Aura lasts for 0.4 seconds (longer than real)
- [ ] No cooldown - can be used repeatedly
- [ ] Does NOT create IsParrying value
- [ ] Purely visual effect

## 5. Combat Tests

### Successful Parry
- [ ] Blade touches player during parry window (0.15s)
- [ ] Player NOT eliminated
- [ ] "SUCCESSFUL PARRY!" appears for player
- [ ] "[Player] parried the blade!" in output
- [ ] Parry count increases by 1
- [ ] Blade speed increases by 5
- [ ] Blade stops and retargets
- [ ] New target selected after 0.5 second delay

### Failed Parry / Dodge
- [ ] Player moves away before blade arrives
- [ ] Blade misses player
- [ ] Dodge count increases by 1
- [ ] Player remains alive
- [ ] Blade stops after 3 seconds
- [ ] Blade retargets after brief pause

### Player Hit (Elimination)
- [ ] Blade touches player without parry
- [ ] "[Player] was hit by the blade!" in output
- [ ] Player's health drops to 0
- [ ] Player's character dies
- [ ] IsAlive value changes to false
- [ ] Stats UI shows "Status: Eliminated"
- [ ] Stats text turns reddish
- [ ] Blade speed increases by 5
- [ ] Blade retargets immediately

## 6. Difficulty Scaling Tests

### Speed Increases
- [ ] Initial blade speed: 60 units/second
- [ ] Speed increases by 5 on first parry/elimination
- [ ] Speed continues to increase each action
- [ ] Blade Speed UI updates correctly
- [ ] Later attacks noticeably faster than early ones
- [ ] Speed increase makes game progressively harder

## 7. Win Condition Tests

### Last Player Standing
- [ ] Game continues until only 1 player alive
- [ ] "[Winner] wins!" appears in output
- [ ] Winner sees "YOU WIN!" on screen
- [ ] Other players see "[Winner] WINS!" on screen
- [ ] Win notification is large and centered
- [ ] Win notification has green background for winner
- [ ] Win notification has orange background for others
- [ ] Notification lasts 5 seconds

### Game Restart
- [ ] After 5 seconds, game automatically restarts
- [ ] "Game starting with X players!" appears again
- [ ] Blade respawns at center
- [ ] Blade speed resets to 60
- [ ] Player stats reset
- [ ] All players marked as alive
- [ ] Players respawn in new positions

## 8. Edge Case Tests

### Single Player
- [ ] Game doesn't start with only 1 player
- [ ] "Waiting for more players..." message appears
- [ ] Game starts when second player joins

### Player Disconnect Mid-Game
- [ ] Player leaving is removed from active list
- [ ] Win condition checked immediately
- [ ] If only 1 player left, game ends
- [ ] If 2+ players left, game continues

### Player Join Mid-Game
- [ ] New player spawns in arena
- [ ] New player gets PlayerStats
- [ ] New player can be targeted by blade
- [ ] Game continues normally

### Multiple Rapid Parries
- [ ] Only first parry in window succeeds
- [ ] Cooldown prevents stacking
- [ ] Each successful parry increases speed once

## 9. UI Tests

### Stats Display
- [ ] Parry count updates in real-time
- [ ] Dodge count updates in real-time
- [ ] Status shows "Alive" or "Eliminated"
- [ ] Text color changes based on status (green/red)
- [ ] All values display correctly

### Visual Feedback
- [ ] Target warning flashes red correctly
- [ ] Parry aura appears and disappears on time
- [ ] Blade glow is visible
- [ ] Trail follows blade
- [ ] Targeting line is clearly visible
- [ ] All UI elements positioned correctly

## 10. Performance Tests

### Smooth Operation
- [ ] No lag with 2 players
- [ ] No lag with 4+ players
- [ ] Blade movement is smooth
- [ ] Effects don't cause frame drops
- [ ] Input response is immediate
- [ ] No memory leaks over time

### Error Handling
- [ ] No errors in Output window during normal play
- [ ] Game recovers from missing components gracefully
- [ ] No infinite loops or crashes

## 11. Behavior AI Tests

### Target Selection
- [ ] Moving players targeted more than stationary
- [ ] Players with high dodge count targeted more
- [ ] Players with high parry count targeted more
- [ ] Selection appears intelligent, not random
- [ ] Different players get targeted over time

### Adaptation
- [ ] Blade "learns" from player behavior
- [ ] Active players become priority targets
- [ ] Pattern changes based on player actions

## Known Limitations (Expected Behavior)

- Game requires 2+ players to start
- No animations (would need to import separately)
- No sound effects (would need to add audio files)
- Basic arena (no map decoration)
- Players spawn in simple circle pattern

## Bug Reporting Template

If you find issues, report using this format:

```
**Issue**: [Brief description]
**Steps to Reproduce**:
1. [Step 1]
2. [Step 2]
3. [etc.]
**Expected**: [What should happen]
**Actual**: [What actually happens]
**Output Errors**: [Any error messages]
**Player Count**: [Number of players in test]
```

## Testing Complete?

Once all checkboxes are marked:
- ✅ Game is ready for production
- ✅ All core mechanics working
- ✅ Win condition functions
- ✅ UI displays correctly
- ✅ No critical bugs found

## Next Steps After Testing

1. **Fine-tune balance** (adjust timing windows, speeds)
2. **Add custom content** (sounds, animations, models)
3. **Design arena map** (obstacles, cover, aesthetics)
4. **Playtesting** with real players for feedback
5. **Polish** visuals and effects
6. **Publish** to Roblox!

---

Happy testing! 🎮
