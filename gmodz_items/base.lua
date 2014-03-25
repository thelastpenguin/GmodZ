local gmodz = gmodz ;


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


function item:CreateDrop( )
	-- CREATE THE ENTITY
	local count = isfunction( self.lootCount ) and self.lootCount() or self.lootCount;
	
	-- BUILD STACK
	local lootStack = gmodz.itemstack.new( self.class );
	lootStack:SetCount( count );
	
	-- SPAWN IT.
	return gmodz.itemstack.CreateEntity( lootStack );
end


function item:StackCanMerge( stack, other )
	return true;
end

function item:FindChildren( )
	if self.children then return self.children end
	self.children = {};
	for k,v in pairs( gmodz.item.GetStored( ) )do
		if v.base == self.class then
			self.children[#self.children+1] = v ;
		end
	end
	return self.children ;
end

function item:IsBase( )
	return #self:FindChildren() > 0 ;
end

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
