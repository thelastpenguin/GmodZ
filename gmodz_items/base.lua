local gmodz = gmodz ;


local item = {};

-- CORE SETTINGS
item.PrintName = 'Unnamed'
item.Model = 'models/props_c17/oildrum001.mdl'
item.StackSize = 16
item.flags = ITEMFLAG_BASECLASS;

item.lootBias = 1;
item.lootCount = 1;

-- HOOKS
item.OnPickup = function( stack, pl )
	gmodz.print("Player "..pl:Name().." picked up a stack of "..stack.meta.PrintName.." x"..stack:GetCount() );
end

-- UTILS
function item:GetChildren() return self.children end
item.HasFlag = gmodz.item._util_hasflag;

do
	local ITEMFLAG_BASECLASS, ITEMFLAG_LOOTABLE = _G.ITEMFLAG_BASECLASS, _G.ITEMFLAG_LOOTABLE ;
	function item:IsBase( )
		return self:HasFlag( ITEMFLAG_BASECLASS );
	end
	function item:IsLootable( )
		return self:HasFlag( ITEMFLAG_LOOTABLE );
	end
end

function item:CreateDrop( count )
	-- BUILD STACK
	local lootStack = gmodz.itemstack.new( self.class );
	lootStack:SetCount( count );
	
	-- SPAWN IT.
	return gmodz.itemstack.CreateEntity( lootStack );
end

-- LOOTING SYSTEM
function item:CreateLoot( )
	-- CREATE THE ENTITY
	local count = isfunction( self.lootCount ) and self.lootCount() or self.lootCount;
	
	return self:CreateDrop( count );
end


--function item:StackCanMerge( stack, other )
--	return true;
--end

-- LOOT SYSTEM

function item:IsLootable( )
	return self.lootBias and self.lootBias > 0 ;	
end

function item:SelectLootChild( )
	local children = self:FindChildren( );
	local totalbias = 0;
	for k,v in pairs( children )do
		if v:IsLootable() then
			totalbias = totalbias + v.lootBias ;
		end
	end
	
	local lootType = 0 ;
end

item.Weapon = 'weapon_fists';

gmodz.item.register( 'base', item );
