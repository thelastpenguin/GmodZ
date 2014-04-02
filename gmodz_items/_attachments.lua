local item = {};

item.base = 'base';
item.PrintName = 'Attachment Base'
item.StackSize = 1
item.Desc = [[
Base Class for all attachments.
]]

item.Material = "VGUI/fas2atts/compm4"--'models/weapons/w_crowbar.mdl'
item.Model = 'models/Items/BoxMRounds.mdl'
item.lootBias = 0.2
item.lootCount = 1
item.flags = ITEMFLAG_BASECLASS ;

gmodz.item.register( 'base_attch', item );

local item = {};
item.base = 'base_attch'
item.PrintName = 'CompM4'
item.Desc = "Provides a bright red reticle to ease aiming."
item.attch = 'compm4'
item.Material = 'VGUI/fas2atts/compm4';
item.flags = ITEMFLAG_LOOTABLE ;
gmodz.item.register( 'fas2attch_compm4', item );


local item = {};
item.base = 'base_attch'
item.PrintName = 'EoTech 553'
item.Desc = "Provides a bright red sphere-like reticle to ease aiming."
item.attch = 'eotech'
item.Material = 'VGUI/fas2atts/eotech553';
item.flags = ITEMFLAG_LOOTABLE ;
gmodz.item.register( 'fas2attch_EoTech', item );


local item = {};
item.base = 'base_attch'
item.PrintName = 'Tritium'
item.Desc = "Provides illuminating sights in the dark."
item.attch = 'tritiumsights'
item.Material = 'VGUI/fas2atts/tritiumsights';
item.flags = ITEMFLAG_LOOTABLE ;
gmodz.item.register( 'fas2attch_Tritium', item );


local item = {};
item.base = 'base_attch'
item.PrintName = 'Suppress'
item.Desc = "Decreases firing noise."
item.attch = 'suppressor'
item.Material = 'VGUI/fas2atts/suppressor';
item.flags = ITEMFLAG_LOOTABLE ;
gmodz.item.register( 'fas2attch_Suppress', item );


local item = {};
item.base = 'base_attch'
item.PrintName = "PSO-1"
item.Desc = "Provides 4x magnification."
item.attch = 'pso1'
item.Material = 'VGUI/fas2atts/pso1';
item.flags = ITEMFLAG_LOOTABLE ;
gmodz.item.register( 'fas2attch_pso1', item );


local item = {};
item.base = 'base_attch'
item.PrintName = "MK4"
item.Desc = "Provides 8x magnification."
item.attch = 'leupold'
item.Material = 'VGUI/fas2atts/mk4';
item.flags = ITEMFLAG_LOOTABLE ;
gmodz.item.register( 'fas2attch_leupold', item );


local item = {};
item.base = 'base_attch'
item.PrintName = "ACOG 4x"
item.Desc = "Provides 4x magnification."
item.attch = 'acog'
item.Material = 'VGUI/fas2atts/acog';
item.flags = ITEMFLAG_LOOTABLE ;
gmodz.item.register( 'fas2attch_acog', item );


local item = {};
item.base = 'base_attch'
item.PrintName = "ELCAN C79"
item.Desc = "Provides 3.4x magnification."
item.attch = 'c79'
item.Material = 'VGUI/fas2atts/c79';
item.flags = ITEMFLAG_LOOTABLE ;
gmodz.item.register( 'fas2attch_c79', item );


local item = {};
item.base = 'base_attch'
item.PrintName = "ELCAN C79"
item.Desc = "Provides 3.4x magnification."
item.attch = 'c79'
item.Material = 'VGUI/fas2atts/c79';
item.flags = ITEMFLAG_LOOTABLE ;
gmodz.item.register( 'fas2attch_c79', item );

local item = {};
item.base = 'base_attch'
item.PrintName = "Foregrip"
item.Desc = "Decreases recoil by 20%"
item.attch = 'foregrip'
item.Material = 'VGUI/fas2atts/foregrip';
item.flags = ITEMFLAG_LOOTABLE ;
gmodz.item.register( 'fas2attch_foregrip', item );
