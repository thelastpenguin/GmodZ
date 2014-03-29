local gmodz = gmodz;
gmodz.inventory = {};

-- TABLE OF ALL INVENTORIES
local inventories = {};

--
-- INVENTORY META TABLE.
--
local inv_mt = {};
inv_mt.__index = inv_mt;

-- NETWORKING
net.Receive( 'gmodz_syncInv', function( )
	local n = setmetatable( {}, inv_mt );
	
	n.id = net.ReadInt( 32 );
	local data = net.ReadTable( );
	
	inventories[ n.id ] = n;
	
	n.stacks = {};
	
	for k,v in pairs( data.s )do
		if not gmodz.item.GetMeta( v.class ) then continue end
		n.stacks[k] = gmodz.itemstack.newFromTable( v );
	end
	
	if( data.w and data.h )then
		n:SetSize( data.w, data.h );
	end
	
	gmodz.hook.Call( 'ReceivedInventory', n );
	gmodz.print("Synced inventory \""..n.id.."\"");
end);

net.Receive( 'gmodz_invSetSlot', function()
	local id = net.ReadUInt( 32 );
	local index = net.ReadUInt( 8 );
	local data = net.ReadTable( );
	local inv = inventories[ id ];
	if not inv then
		gmodz.print("ATTEMPTED TO SET SLOT ON NON SYNCED INVENTORY: "..id..'.');
		return ;
	end
	inv.stacks[ index ] = table.Count(data)>0 and gmodz.itemstack.newFromTable( data ) or nil;
	gmodz.print( "Inventory "..id.." updated slot at "..index..".");
	
	gmodz.hook.Call( 'UpdatedInventory', inv, index );
end);

net.Receive( 'gmodz_syncHash', function()
	local invid = net.ReadInt( 32 );
	local hash = net.ReadInt( 32 );
	local inv = inventories[ invid ];
	if not inv then gmodz.print('ERROR: Hash check failed. Inventory does not exist or is not synced.' ) return end
	
	if inv:Hash() ~= hash then
		gmodz.print('ERROR: Inventory Hash Codes do not match! Requesting Re-sync', Color(255,0,0));
		gmodz.print( hash .. ' ~= ' .. inv:Hash() );
		net.Start( 'gmodz_requestResync' )
			net.WriteUInt( invid, 32 );
		net.SendToServer( );
	else
		gmodz.print('[INV] Inv Hash '..inv:Hash()..' matches expected '..hash..' for inventory '..invid );
	end
end);

net.Receive( 'gmodz_delInv', function( )
	inventories[ net.ReadInt( 32 ) ] = nil;
	gmodz.hook.Call( 'DeletedInventory', inv );
end);

--
-- META METHODS
--
function inv_mt:SetSize( w, h )
	self.w, self.h = w, h;
	return self;
end
function inv_mt:GetSize( )
	return self.w, self.h ;
end
function inv_mt:GetSlot( x, y )
	local index ;
	if( y )then
		index = y * self.w + x;
	else
		index = x;
	end
	return self.stacks[ index ];
end
function inv_mt:SetSlot( x, y, stack )
	if( type( y ) == 'table' )then
		stack = y;
		y = nil;
	end
	
	local index ;
	if( y ~= nil )then
		index = y * self.w + x;
	else
		index = x;
	end
	
	if index > self.w*self.h then return self end
		
	self.stacks[ index ] = stack;
	
	return self ;
end
function inv_mt:SyncSlot( ) end

-- takes a stack and tells us if we have enough of the item represented by that stack.
function inv_mt:HaveMaterial( stack )
	local meta = stack.meta;
	local count = 0;
	for k,v in pairs( self.stacks )do
		if v.meta == meta then
			count = count + v:GetCount( );
		end
	end
	if count < stack:GetCount( ) then
		return false, count;
	else
		return true, count;
	end
end

function inv_mt:DeductStack( stack )
	local meta = stack.meta;
	local count = 0;
	for k,v in pairs( self.stacks )do
		if v.meta == meta then
			count = count + v:GetCount( );
		end
	end
	if count < stack:GetCount( ) then
		return false;
	else
		local needed = stack:GetCount( );
		for k,v in SortedPairs( self.stacks )do
			if v.meta == meta then
				local size = v:GetCount( );
				if size > needed then
					v:SetCount( size - needed );
				else
					self:SetSlot( k, nil );
				end
				needed = needed - size;
				if needed <= 0 then break end
			end
		end
		return true;
	end
end
function inv_mt:CountItems( selector )
	local c = 0;
	for k,v in pairs( self.stacks )do
		if selector( v ) then
			c = c + v:GetCount( );
		end
	end
	return c;
end

function inv_mt:SaveToTable( )
	local data = {};
	local stacks = {};
	data.s = stacks;
	for k,v in pairs( self.stacks )do
		stacks[k] = v:SaveToTable( );
	end
	
	data.w, data.h = self:GetSize( );
	data.v = 0;
	return data;
end

function inv_mt:Hash( )
	local hashstr = {};
	for k,v in SortedPairs( self.stacks )do
		hashstr[#hashstr+1] = k..','..v.meta.class..','..v:GetCount();
	end
	return util.CRC( table.concat( hashstr, ',' ) )%1073741824;
end


--
-- ENTITIES
--
net.Receive( 'gmodz_ent_invLink', function( )
	local e = net.ReadEntity();
	local strid = net.ReadString( );
	local id = net.ReadInt( 32 );
	
	if not e.invs then e.invs = {} end
	e.invs[ strid ] = id;
	gmodz.print('Linked '..strid..' ('..id..') to entity.');
end);

gmodz.hook.Add( 'OnEntityCreated', function( e )
	net.Start( 'gmodz_ent_getInvLinks' );
		net.WriteEntity( e );
	net.SendToServer( );
end);

local Entity = FindMetaTable( 'Entity' );
function Entity:GetInv( strid )
	if not self.invs then return end
	local invid = self.invs[ strid ];
	return inventories[ invid ];
end

function Entity:GetInventories( )
	return self.invs;
end



--
-- INVENTORY EDITING UTILS
--
function gmodz.InvTransfer( inv1, index1, inv2, index2, qty )
	net.Start('gmodz_inv_moveStack');
		net.WriteUInt(inv1.id, 32);
		net.WriteUInt(index1, 16);
		net.WriteUInt(inv2.id, 32);
		net.WriteUInt(index2, 16);
		net.WriteUInt(qty, 16);
	net.SendToServer( );
end