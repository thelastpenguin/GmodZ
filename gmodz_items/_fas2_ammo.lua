
local item = {};
item.base = 'base';
item.PrintName = 'Base Ammo'
item.StackSize = 128
item.Desc = [[
Ammo Base
]]
item.Model = 'models/Items/BoxMRounds.mdl'
item.ammo_type = 'none'
item.lootBias = 0.8
item.flags = ITEMFLAG_BASECLASS;
gmodz.item.register( 'base_ammo', item );




local item = {};
item.base = 'base_ammo';
item.PrintName = '5.56mm Ammo'
item.StackSize = 256
item.Desc = [[
Some 5.56mm Ammo cartons.
Dented but otherwise fine.
]]
item.Model = "models/Items/BoxMRounds.mdl"
item.ammo_type = '5.56mm'
item.lootCount = function() return math.random( 20, 30 ); end
item.lootBias = 6
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'ammo_5.56', item );



local item = {};
item.base = 'base_ammo';
item.PrintName = '7.62mm Ammo'
item.StackSize = 256
item.Desc = [[
Some 7.62mm Ammo cartons.
Dented but otherwise fine.
]]
item.ammo_type = '7.62mm'
item.Model = 'models/Items/BoxMRounds.mdl'
item.lootCount = function() return math.random( 20, 30 ); end
item.lootBias = 4
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'ammo_7.62', item );



local item = {};
item.base = 'base_ammo';
item.PrintName = '9mm Ammo'
item.StackSize = 256
item.Desc = [[
Some 9mm Ammo cartons.
Dented but otherwise fine.
]]
item.Model = 'models/Items/BoxSRounds.mdl'
item.ammo_type = '9mm'
item.lootCount = function() return math.random( 20, 30 ) end
item.lootBias = 8
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'ammo_9mm', item );



local item = {};
item.base = 'base_ammo';
item.PrintName = 'Buckshot'
item.StackSize = 128
item.Desc = [[
Some Buckshot Ammo cartons.
Bit wet but otherwise fine.
]]
item.Model = 'models/Items/BoxBuckshot.mdl'
item.ammo_type = 'Buckshot'
item.lootCount = function() return math.random( 10, 20 ) end
item.lootBias = 7
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'ammo_Buckshot', item );



local item = {};
item.base = 'base_ammo';
item.PrintName = '.50 Cal'
item.StackSize = 128
item.Desc = [[
Some .50 Cal cartons.
]]
item.Model = 'models/Items/357ammo.mdl'
item.ammo_type = '.50 Cal'
item.lootCount = function() return math.random( 15, 25 ); end
item.lootBias = 4
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'ammo_50cal', item );



local item = {};
item.base = 'base_ammo';
item.PrintName = 'Bandages'
item.StackSize = 16
item.Desc = [[
Bandages for firstaid kit.
]]
item.Model = 'models/Items/HealthKit.mdl'
item.ammo_type = 'Bandages'
item.lootCount = function() return math.random( 1, 2 ); end
item.lootBias = 1;
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'ammo_Bandages', item );


local item = {};
item.base = 'base_ammo';
item.PrintName = 'Quikclots'
item.StackSize = 16
item.Desc = [[
Quickclots to stem the flow of blood.
]]
item.Model = 'models/Items/HealthKit.mdl'
item.ammo_type = 'Quikclots'
item.lootCount = function() return math.random( 1, 2 ); end
item.lootBias = 1;
gmodz.item.register( 'ammo_Quikclots', item );

local item = {};
item.base = 'base_ammo';
item.PrintName = 'Hemostats'
item.StackSize = 16
item.Desc = [[
Hemostats.
]]
item.Model = 'models/Items/HealthKit.mdl'
item.ammo_type = 'Hemostats'
item.lootCount = function() return math.random( 1, 2 ); end
item.lootBias = 1;
item.flags = ITEMFLAG_LOOTABLE;
gmodz.item.register( 'ammo_Hemostats', item );


/*
	own:GiveAmmo(4, "Bandages")
	own:GiveAmmo(3, "Quikclots")
	own:GiveAmmo(2, "Hemostats")
*/