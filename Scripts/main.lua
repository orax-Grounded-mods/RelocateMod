Mod = {}
Mod.Relocate = {}

Mod.Name = "RelocateMod"
print(Mod.Name .. " init\n")

---@enum EInteractionState
EInteractionState = {
  Hidden = 0,
  Disabled = 1,
  Enabled = 2,
  Indeterminate = 3,
  EInteractionState_MAX = 4
}

dofile("ue4ss/Mods/RelocateMod/options.lua")

Mod.Relocate.IsEnabled = false

local preId, postId

local function ToogleRelocate()
  if Mod.Relocate.IsEnabled then
    UnregisterHook("/Script/Maine.Placeable:GetRelocationEnabledState", preId, postId)
  else
    preId, postId = RegisterHook("/Script/Maine.Placeable:GetRelocationEnabledState", function()
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
