local gmodz = gmodz;
gmodz.itemstack = {};

local stack_mt = {};
stack_mt.__index = stack_mt;

function gmodz.itemstack.new( class )
	local n = {};
	setmetatable( n, stack_mt );
	
	n:Init( class );
	
	return n;
end
function gmodz.itemstack.newFromTable( data )
	local n = {};
	setmetatable( n, stack_mt );
	
	n:Init( data.class );
	n:LoadFromTable( data );
	
	return n;
end

function stack_mt:Init( class )
	self.meta = gmodz.item.GetMeta( class );	
end
function stack_mt:LoadFromTable( tbl )
	self:SetCount( tbl.c );
	if( tbl.data )then
		self:SetData( tbl.data );
	end
	return self;
end
function stack_mt:SaveToTable( tbl )
	tbl.cl = self:GetClass();
	tbl.c = self:GetCount( );
	tbl.d = self:GetData() or nil;
	return d;
end

function stack_mt:GetMeta( )
	return self.meta;
end

function stack_mt:GetClass( )
	return self.meta.class;
end

function stack_mt:SetCount( num )
	self.count = num;
	return self;
end
function stack_mt:GetCount()
	return self.count;
end

function stack_mt:SetData( tbl )
	self.data = tbl;
	return self;
end
function stack_mt:GetData( tbl )
	return self.data;
end

function stack_mt:Remove( )
	table.Empty( self );
	self.removed = true;
end

function stack_mt.__eq( self, other )
	local eq = self.meta.equals;
	if( eq )then
		return eq( self, other );
	end
	return false;
end
function stack_mt:Clone( )
	local n = setmetatable( table.Copy( self ), stack_mt );
	return n;
end

function StackIsValid( item )
	if( item and not item.removed )then return true else return false end	
end