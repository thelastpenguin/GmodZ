
local item = {};

item.base = 'base';
item.PrintName = 'Physics Gun'
item.StackSize = 1
item.Desc = [[
A powerful physics gun allowing you to shape the world around you.
]]
item.Model = "models/weapons/w_m14.mdl"
item.SVModel = 'models/weapons/w_smg1.mdl'
item.Weapon = 'weapon_physgun'

gmodz.item.register( 'admin_physgun', item );
