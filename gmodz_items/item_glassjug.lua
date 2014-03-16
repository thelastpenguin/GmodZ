local item = {};

item.base = 'base';
item.PrintName = 'Glass Bottle'
item.Desc = [[
An empty glass bottle.
Got anything to put inside?
]]
item.Model = 'models/props_junk/glassjug01.mdl'
item.OnUse = function( self, pl )
	pl:Kill( );
end


gmodz.item.register( 'glass_bottle', item );
