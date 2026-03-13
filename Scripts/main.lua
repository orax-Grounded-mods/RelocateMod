---@class FOutputDevice
---@field Log function
---@field IsValid function

Mod = {}
Mod.Relocate = {}
Mod.CopyActorUnderCursor = {}

Mod.Name = "RelocateMod"
print(Mod.Name .. " init\n")

local UEHelpers = require("UEHelpers")
local lower = string.lower

---@type EInteractionState
local EInteractionState = {
  Hidden = 0,
  Disabled = 1,
  Enabled = 2,
  Indeterminate = 3,
  EInteractionState_MAX = 4
}

---Check if a string exists in a table by converting all values to lower-case.
---@param t table The array-like table to search through.
---@param str string The string value to look for.
---@return boolean found True if the string is found using lower-case comparison.
local function includesIgnoreCase(t, str)
  str = lower(str)

  for _, value in ipairs(t) do
    if lower(value) == str then
      return true
    end
  end

  return false
end

---@param sourceActor UObject
local function spawnActor(sourceActor)
  local survivalPlayerCharacter = FindFirstOf("SurvivalPlayerCharacter")
  if not survivalPlayerCharacter:IsValid() then
    return
  end
  ---@cast survivalPlayerCharacter ASurvivalPlayerCharacter

  if not sourceActor:IsValid() or not survivalPlayerCharacter:IsValid() then
    if not sourceActor:IsValid() then
      print("Error: Source actor not found.")
    end
    if not survivalPlayerCharacter:IsValid() then
      print("Error: Player character not found.")
    end

    return
  end

  local world = UEHelpers.GetWorld()
  local actorClass = sourceActor:GetClass()

  -- Retrieve player's spatial data.
  local playerLocation = survivalPlayerCharacter:K2_GetActorLocation()
  local playerRotation = survivalPlayerCharacter:K2_GetActorRotation()
  local forwardVector = survivalPlayerCharacter:GetActorForwardVector()

  -- Calculate a spawn position 250 units in front of the player.
  -- Offset the Z axis slightly to prevent clipping into the ground.
  local spawnLocation = {
    X = playerLocation.X + (forwardVector.X * 250.0),
    Y = playerLocation.Y + (forwardVector.Y * 250.0),
    Z = playerLocation.Z + 50.0
  }

  -- Spawn the duplicate actor.
  -- https://dev.epicgames.com/documentation/en-us/unreal-engine/spawning-actors-in-unreal-engine
  ---@diagnostic disable-next-line: undefined-field
  local newActor = world:SpawnActor(actorClass, spawnLocation, playerRotation, 1)

  if newActor:IsValid() then
    print("Success: Object duplicated and placed near player.")
  else
    print("Error: Failed to spawn the actor instance.")
  end
end

---Generate a lookup table where each alias maps back to its parent key.
---@param sourceTable table The Mod.Types table containing classes and aliases.
---@return table lookupTable A flattened table for quick alias-to-key resolution.
local function createLookupTable(sourceTable)
  local lookup = {}

  -- Iterate through each entry in the source configuration.
  for mainKey, data in pairs(sourceTable) do
    -- Check if the entry has an aliases table.
    if data.aliases and type(data.aliases) == "table" then
      for _, alias in ipairs(data.aliases) do
        -- Map the alias (as a key) to the main identifier (as the value).
        lookup[lower(alias)] = mainKey
      end
    end
  end

  return lookup
end

local function isValidEntry(entry)
  return type(entry) == "table" and
      type(entry.aliases) == "table" and
      #entry.aliases and
      type(entry.class) == "string" and
      #entry.class
end

---Generate a help message displaying command syntax and all available actor aliases.
---@return string helpMessage The formatted string containing usage instructions and object list.
local function generateHelpMessage()
  -- Define the command syntax and the case-insensitivity rule.
  local syntax = string.format("Usage: %s <alias>", Mod.SpawnActorCommandName)
  local example = "Example: spawn ASL"
  local caseNote = "Note: Aliases are case-insensitive (e.g., ASL = asl)."

  local helpLines = {
    syntax,
    example,
    caseNote,
    "\nAvailable objects:"
  }

  -- Iterate through the configuration to list each object.
  for typeName, typeInfo in pairs(Mod.Types) do
    -- Format: - Name : Description (Aliases: a, b, c).
    local line = string.format("- %s : %s (Aliases: %s)",
      typeName,
      typeInfo.description or "No description",
      table.concat(typeInfo.aliases, ", "))
    table.insert(helpLines, line)
  end

  -- Join all lines with a newline for the console output.
  return table.concat(helpLines, "\n")
end

dofile("ue4ss/Mods/RelocateMod/options.lua")

Mod.Relocate.IsEnabled = false
local aliasLookup = createLookupTable(Mod.Types)

local preId, postId

local function ToogleRelocate()
  if Mod.Relocate.IsEnabled then
    UnregisterHook("/Script/Maine.Placeable:GetRelocationEnabledState", preId, postId)
  else
    preId, postId = RegisterHook("/Script/Maine.Placeable:GetRelocationEnabledState", function()
      ---@diagnostic disable-next-line: redundant-return-value
      return EInteractionState.Enabled
    end)
  end

  Mod.Relocate.IsEnabled = not Mod.Relocate.IsEnabled
end

if Mod.Relocate.Key ~= nil then
  if Mod.Relocate.ModifierKey ~= nil then
    RegisterKeyBind(Mod.Relocate.Key, { Mod.Relocate.ModifierKey }, ToogleRelocate)
  else
    RegisterKeyBind(Mod.Relocate.Key, ToogleRelocate)
  end
end

RegisterConsoleCommandHandler(Mod.SpawnActorCommandName,
  ---@param fullCommand string
  ---@param args table
  ---@param outputDevice FOutputDevice
  ---@return boolean
  function(fullCommand, args, outputDevice)
    if #args == 0 then
      local msg = generateHelpMessage()
      outputDevice:Log(msg)
      return true
    end

    local entryName = aliasLookup[lower(args[1])]
    if not entryName then
      outputDevice:Log("Alias not found.")
      return true
    end

    local entry = Mod.Types[entryName]

    if isValidEntry(entry) then
      outputDevice:Log("Spawn actor: " .. entry.class)
      spawnActor(FindFirstOf(entry.class))
    else
      local msg = "Mod.Types." .. entryName .. " is not valid in the options file."
      outputDevice:Log(msg)
      error(msg)
      return
    end

    return true
  end)

-- Initialize ConsoleEnablerMod manually via F10 to prevent crashes during early game boot.
RegisterKeyBind(Key.F10, function()
  local Engine = UEHelpers.GetEngine()
  if not Engine:IsValid() then
    print("[ConsoleEnabler] Was unable to find an instance of UEngine\n")
    return
  end

  local console = FindFirstOf(Engine.ConsoleClass:GetFName():ToString())
  if not console:IsValid() then
    dofile("ue4ss/Mods/ConsoleEnablerMod/Scripts/main.lua")
  end
end)
