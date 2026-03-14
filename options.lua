--[[
    KEYBINDINGS HELP

    Key table:         https://docs.ue4ss.com/lua-api/table-definitions/key.html
    ModifierKey table: https://docs.ue4ss.com/lua-api/table-definitions/modifierkey.html

    The Key table contains Microsoft virtual key-code strings.
    examples:
        ExampleKey = LEFT_MOUSE_BUTTON
        ExampleKey = A
        ExampleKey = NUM_ZERO

    The ModifierKey table contains Microsoft virtual key-code strings that are meant to be modifier keys such as CONTROL and ALT.
    examples:
        ExampleModifierKeys = {ModifierKey.CONTROL} -- CONTROL key
        ExampleModifierKeys = {ModifierKey.SHIFT}   -- SHIFT key
        ExampleModifierKeys = {ModifierKey.CONTROL, ModifierKey.SHIFT, ModifierKey.ALT} -- CONTROL + SHIFT + ALT keys
]]

Mod.Relocate.Key = Key.NUM_ONE
Mod.Relocate.ModifierKey = ModifierKey.ALT

-- COMMAND: spawn
--
-- Change the value below to rename the main console command (e.g., "create" instead of "spawn").
Mod.SpawnActorCommandName = "spawn"

-- HOW TO OPEN THE CONSOLE
-- Press F10 in-game (twice) to enable and open the console.

-- OBJECT TYPES CONFIGURATION
-- Each entry defines a spawnable object.
-- description : What appears in the help menu.
-- class       : The internal Unreal Engine class name (Do not change unless you know what you are doing).
-- aliases     : Short names you can type. Note: These are case-insensitive (RA is the same as ra).
--
-- USAGE EXAMPLES (Type these in the game console; press F10 in-game (twice)):
--   spawn                   -> Shows the help menu with all available objects.
--   spawn ASL               -> Spawns an ASL Terminal.
--   spawn ra                -> Spawns a Resource Analyzer (aliases are case-insensitive).
--   spawn ResourceSurveyor  -> Spawns a Resource Surveyor using the full name.
Mod.Types = {
    -- ASL Terminal
    ASLTerminal = {
        description = "Spawn an ASL Terminal.",
        class = "BP_BurgleStation_C",
        aliases = { "ASL", "terminal", "term" }
    },

    -- Resource Analyzer
    ResourceAnalyzer = {
        description = "Spawn a Resource Analyzer.",
        class = "BP_ResourceAnalyzer_C",
        aliases = { "ResourceAnalyzer", "RA" }
    },

    -- Resource Surveyor
    ResourceSurveyor = {
        description = "Spawn a Resource Surveyor.",
        class = "BP_ResourceSurveyor_C",
        aliases = { "ResourceSurveyor", "RS" }
    }
}

-- COMMAND: canrecycle
--
-- Enables the "RECYCLE" shortcut prompt for all buildings.
-- This shortcut appears on the screen when hovering over a building.
-- Note: This change is not persistent. To revert the effect, simply
-- restart the game or reload your save.
--
-- Warning: Recycled buildings are permanently destroyed and cannot be
-- recovered.
--
-- Change the value below to rename the canrecycle console command
-- (e.g., "demolish" or "recycle" instead of "canrecycle").
--
-- USAGE EXAMPLE (Type these in the game console; press F10 in-game (twice)):
--   canrecycle
Mod.CanRecycleCommandName = "canrecycle"
