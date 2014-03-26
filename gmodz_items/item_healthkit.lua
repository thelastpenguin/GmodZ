-- fas2_glock20
local item = {};

item.base = 'base_fas2';
item.PrintName = "First Aid Kit"
item.StackSize = 1
item.Desc = [[
An Infantry Firstaid Kit left by the military. Use it to heal yourself or your comrads.
]]
item.Model = "models/weapons/w_ifak.mdl"
item.SVModel = "models/Items/HealthKit.mdl"
item.Weapon = 'fas2_ifak'
item.lootBias = 3
item.flags = ITEMFLAG_LOOTABLE;

gmodz.item.register( 'healthkit', item );