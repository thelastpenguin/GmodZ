local item = {};

item.base = 'base';
item.PrintName = 'Melee Base'
item.StackSize = 1
item.Desc = [[
A trusty metal crowbar. 
Useful for prying open locks or bashing in brains.
]]
item.Model = 'models/weapons/w_crowbar.mdl'
item.Weapon = 'weapon_crowbar'
item.lootBias = 1.3
item.flags = ITEMFLAG_BASECLASS ;

gmodz.item.register( 'base_melee', item );

--
-- FIRE AXE
--
local item = {};

item.base = 'base_melee';
item.PrintName = 'Axe'
item.Desc = [[
An old fire axe, brutal but effective.
]]
item.Model = "models/warz/melee/fireaxe.mdl"
item.Weapon = 'gmodz_axe'
item.lootBias = 0.6
item.flags = ITEMFLAG_LOOTABLE;

gmodz.item.register( 'melee_fireaxe', item );


--
-- BASE BALL BAT
--
local item = {};

item.base = 'base_melee';
item.PrintName = 'Base Ball Bat'
item.Desc = [[
Base Ball anyone? Zombies don't make great  pitchers.
]]
item.Model = "models/warz/melee/baseballbat.mdl"
item.Weapon = 'gmodz_baseballbat'
item.lootBias = 3
item.flags = ITEMFLAG_LOOTABLE;

gmodz.item.register( 'melee_bballBat', item );


--
-- SPIKED BASE BALL BAT
--
local item = {};

item.base = 'base_melee';
item.PrintName = 'Spiked Bat'
item.Desc = [[
These nails should do the trick.
]]
item.Model = "models/warz/melee/baseballbat_spike.mdl"
item.Weapon = 'gmodz_baseballbat_spike'
item.lootBias = false ;
item.flags = ITEMFLAG_LOOTABLE;

gmodz.item.register( 'melee_bballBat_spiked', item );


--
-- BUTTERFLY KNIFE
--
local item = {};

item.base = 'base_melee';
item.PrintName = 'Butterfly Knife'
item.Desc = [[
These nails should do the trick.
]]
item.Model = "models/warz/melee/butterflyknife.mdl"
item.Weapon = 'gmodz_butterflyknife'
item.lootBias = 1
item.flags = ITEMFLAG_LOOTABLE;

gmodz.item.register( 'melee_bflyknife', item );


--
-- BASE BALL BAT
--
local item = {};

item.base = 'base_melee';
item.PrintName = 'Cricket Bat'
item.Desc = [[
A cricketbat... Once these were used for sports.
]]
item.Model = "models/warz/melee/cricketbat.mdl"
item.Weapon = 'gmodz_cricketbat'
item.lootBias = 1.3
item.flags = ITEMFLAG_LOOTABLE;

gmodz.item.register( 'melee_cricketbat', item );


--
-- BASE BALL BAT
--
local item = {};

item.base = 'base_melee';
item.PrintName = 'Crowbar'
item.Desc = [[
Trusty old crowbar
]]
item.Model = "models/warz/melee/crowbar.mdl"
item.Weapon = 'gmodz_crowbar'
item.lootBias = 2
item.flags = ITEMFLAG_LOOTABLE;

gmodz.item.register( 'melee_crowbar', item );


--
-- FRYING PAN
--
local item = {};

item.base = 'base_melee';
item.PrintName = 'Frying Pan'
item.Desc = [[
An old frying skillet.
]]
item.Model = "models/warz/melee/fryingpan.mdl"
item.Weapon = 'gmodz_fryingpan'
item.lootBias = 2.3
item.flags = ITEMFLAG_LOOTABLE;

gmodz.item.register( 'melee_fryingpan', item );

--
-- GOLF CLUB
--
local item = {};

item.base = 'base_melee';
item.PrintName = 'Golf Club'
item.Desc = [[
An old golf club... grass hasn't been cut in a while.
]]
item.Model = "models/warz/melee/golfclub.mdl"
item.Weapon = 'gmodz_golfclub'
item.lootBias = 1.3
item.flags = ITEMFLAG_LOOTABLE;

gmodz.item.register( 'melee_golfclub', item );

--
-- GOLF CLUB
--
local item = {};

item.base = 'base_melee';
item.PrintName = 'Hammer'
item.Desc = [[
Pounding in zombie skulls and pounding in brains... remarkably similar.
]]
item.Model = "models/warz/melee/hammer.mdl"
item.Weapon = 'gmodz_hammer'
item.lootBias = 1
item.flags = ITEMFLAG_LOOTABLE;

gmodz.item.register( 'melee_hammer', item );


--
-- HATCHET
--
local item = {};

item.base = 'base_melee';
item.PrintName = 'Hatchet'
item.Desc = [[
Hack and slash with this hatchet.
]]
item.Model = "models/warz/melee/hatchet.mdl"
item.Weapon = 'gmodz_hatchet'
item.lootBias = 0.4
item.flags = ITEMFLAG_LOOTABLE;

gmodz.item.register( 'melee_hatchet', item );


--
-- KATANA SWORD
--
local item = {};

item.base = 'base_melee';
item.PrintName = 'Katana'
item.Desc = [[
Slash through the undead like butter.
]]
item.Model = "models/warz/melee/katana1.mdl"
item.Weapon = 'gmodz_katana'
item.lootBias = 0.05
item.flags = ITEMFLAG_LOOTABLE;

gmodz.item.register( 'melee_katana', item );


--
-- MACHETE
--
local item = {};

item.base = 'base_melee';
item.PrintName = 'Machete'
item.Desc = [[
Clearing a path... through zombies.
]]
item.Model = "models/warz/melee/machete.mdl"
item.Weapon = 'gmodz_machete'
item.lootBias = 0.4
item.flags = ITEMFLAG_LOOTABLE;

gmodz.item.register( 'melee_machete', item );

--
-- PICKAXE
--
local item = {};

item.base = 'base_melee';
item.PrintName = 'Pick Axe'
item.Desc = [[
No need to dig down to hell when you can find it right at the surface.
]]
item.Model = "models/warz/melee/pickaxe.mdl"
item.Weapon = 'gmodz_pickaxe'
item.lootBias = 0.8
item.flags = ITEMFLAG_LOOTABLE;

gmodz.item.register( 'melee_pickaxe', item );
