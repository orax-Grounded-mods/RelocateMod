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
]] --
Mod.Relocate.Key = Key.NUM_ONE
Mod.Relocate.ModifierKey = ModifierKey.ALT
