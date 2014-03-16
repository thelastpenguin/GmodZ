
local item = {};

-- CORE SETTINGS
item.PrintName = 'Unnamed'
item.Model = 'models/props_c17/oildrum001.mdl'
item.StackSize = 16

-- GENARIC FUNCTIONS
item.DoDrop = function( stack, pl )
	local ent = ents.Create( 'gmodz_itemstack' );
end

item.OnPickup = function( stack, pl )
	
end

-- LOOT
item.lootBias = 1;
item.lootCount = 1;

item.equals = function( stack, other )
	if( stack.class == other.class )then
		return true;
	else
		return false;
	end
end


function item:StackCanMerge( stack, other )
	return true;
end

item.Weapon = 'weapon_fists';

gmodz.item.register( 'base', item );
