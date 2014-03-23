local item = {};

item.StackSize = 10000000
item.base = 'base';
item.PrintName = 'Dollar'
item.Desc = [[
Some money, trade and purchase supplies.
]]
item.Model = "models/props/cs_assault/money.mdl"
item.lootBias = 0

gmodz.item.register( 'money', item );


function gmodz.SpawnMoney( amount )
	local stack = gmodz.itemstack.new( 'money' ):SetCount( amount );
	local ent   = gmodz.itemstack.CreateEntity( stack );
	return ent ;
end