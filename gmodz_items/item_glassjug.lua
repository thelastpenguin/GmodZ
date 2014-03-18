local item = {};

item.base = 'base_genaric';
item.PrintName = 'Glass Bottle'
item.Desc = [[
An empty glass bottle.
Got anything to put inside?
]]
item.Model = 'models/props_junk/glassjug01.mdl'
item.OnUse = function( self, pl )
	pl:Kill( );
end
item.lootBias = 0;

gmodz.item.register( 'glass_bottle', item );
