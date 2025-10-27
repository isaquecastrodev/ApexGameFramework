# ApexGameFramework

A modular Lua/Roblox game framework demonstrating player data, inventory, quests, combat, and event-driven architecture.  
Designed as a foundation for building gameplay systems with maintainable and testable code.

## Features
- Player data saving/loading (DataStore)
- Modular quest system with progress & reward events
- Inventory & item usage system
- Combat (damage/heal) with events
- EventBus for decoupled communication
- Entity registry for game objects

## Installation
1. Copy `ModuleScripts` to `ReplicatedStorage.ApexGameFramework.ModuleScripts`.
2. Place `ServerInit.lua` & `DataSaveLoop.lua` in `ServerScriptService.ApexGameFramework`.
3. Place `ClientInit.local.lua` in `StarterPlayer > StarterPlayerScripts`.
4. Create `RemoteEvent` instances under `ReplicatedStorage.ApexGameFramework.Remotes`:
   - `ReqAddItem`, `ReqUseItem`, `PlayerDataResponse`
5. Open Roblox Studio and test in multiplayer to verify saving & events.

## How to extend
- Add more quest definitions in `ServerInit.lua` or separate module.
- Create GUI in `StarterGui` that reads `PlayerDataResponse` to show inventory/quests.
- Add item effect handlers by listening to `QuestReward` or hooking `ReqAddItem` on server.

## License
MIT
