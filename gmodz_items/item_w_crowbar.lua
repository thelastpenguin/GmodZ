
local item = {};

item.base = 'base';
item.PrintName = 'Crowbar'
item.StackSize = 1
item.Desc = [[
A trusty metal crowbar. 
Useful for prying open locks or bashing in brains.
]]
item.Model = 'models/weapons/w_crowbar.mdl'
item.Weapon = 'weapon_crowbar'
item.lootBias = 0.3

gmodz.item.register( 'w_crowbar', item );
