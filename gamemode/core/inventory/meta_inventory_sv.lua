local gmodz = gmodz;
gmodz.inventory = {};

-- META TABLE + METHODS
local inv_mt = {};
inv_mt.__index = inv_mt;

--
-- CREATE INVENTORIES
--
local inventories = setmetatable( {}, { __mode = 'v' })
local invid = 0;
function gmodz.inventory.new( )
	local n = setmetatable( {}, inv_mt );
	
	n.id = invid;
	inventories[ invid ] = n;
	invid = invid + 1;
	
	n.stacks = {};
	n.editors = {};
	n.modifiers = {};
	
	return n;
end

function gmodz.inventory.newFromTable( data )
	local n = setmetatable( {}, inv_mt );

	n.id = invid;
	inventories[ invid ] = n;
	invid = invid + 1;

	n.editors = {};
	n.modifiers = {};
	n.stacks = {};
	
	for k,v in pairs( data.s )do
		if not gmodz.item.GetMeta( v.class ) then continue end
		local stack = gmodz.itemstack.newFromTable( v );
		if stack:GetCount() <= 0 then continue end
		n.stacks[k] = stack;
	end
	
	if( data.w and data.h )then
		n:SetSize( data.w, data.h );
	end
	
	return n;
end
function gmodz.inventory.get( invid )
	return inventories[ invid ];
end


-- CACHE NW STRINGS
util.AddNetworkString( 'gmodz_invSetSlot' );
util.AddNetworkString( 'gmodz_syncInv' );
util.AddNetworkString( 'gmodz_delInv' );
util.AddNetworkString( 'gmodz_syncHash' );

function inv_mt:SetSize( w, h )
	self.w, self.h = w, h;
	return self;
end
function inv_mt:GetSize( )
	return self.w, self.h ;
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
		
	self.stacks[ index ] = stack;
	
	self:SyncSlot( index );
	
	return self ;
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

-- 
-- NETWORKING
--
function inv_mt:AddEditor( pl )
	table.insert( self.editors, pl );
	
	-- SYNC WITH EDITOR
	net.Start( 'gmodz_syncInv' );
		net.WriteInt( self.id, 32 );
		net.WriteTable( self:SaveToTable( ) );
	net.Send( pl );
	return self ;
end
function inv_mt:DelEditor( pl )
	for k, v in ipairs( self.editors )do
		if( v == pl )then
			net.Start( 'gmodz_delInv' );
				net.WriteInt( self.id, 32 );
			net.Send( pl );
			table.remove( self.editors, k );
			break ;
		end
	end
	return self ;
end
function inv_mt:GetEditors( )
	return self.editors ;
end
function inv_mt:AddModifier( pl )
	self.modifiers[ pl ] = true ;
end
function inv_mt:DelModifier( pl )
	self.modifiers[ pl ] = nil;
end
function inv_mt:CanModify( pl )
	return self.modifiers[ pl ] or false;	
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

function inv_mt:SyncSlot( index )
	local stack = self:GetSlot( index );
	if( #self.editors > 0 )then
		net.Start( 'gmodz_invSetSlot' );
			net.WriteUInt( self.id, 32 );
			net.WriteUInt( index, 8 );
			net.WriteTable( stack and stack:SaveToTable( ) or {} );
		net.Send( self.editors );
	end
end

function inv_mt:SyncHash( )
	net.Start( 'gmodz_syncHash' );
		net.WriteInt( self.id, 32 );
		net.WriteInt( self:Hash(), 32 );
	net.Send( self.editors );
end

--
-- INVENTORY UTILITIES
--
function inv_mt:AddStack( stack )
	stack = stack:Copy( );
	
	local StackSize = stack.meta.StackSize;
	if StackSize > 1 then
		-- find any stacks with the same item type...
		for k,v in pairs( self.stacks )do
			if v.meta == stack.meta then
				local oc = v:GetCount();
				if oc >= StackSize then continue end
				local room = math.Clamp( StackSize - oc, 0, stack:GetCount() );
				if room > 0 then
					v:SetCount( oc + room );
					stack:SetCount( stack:GetCount() - room );
					self:SyncSlot( k );
				end
				if stack:GetCount() == 0 then
					return 0;
				end
			end
		end
	end
	for i = 0, self.w*self.h-1 do
		local slot = self:GetSlot( i );
		if not slot then
			self:SetSlot( i, stack );
			return 0;
		end
	end
	return stack:GetCount( );
end
function inv_mt:DeductStack( stack )
	local meta = stack.meta;
	local count = 0;
	for k,v in pairs( self.stacks )do
		if v.meta == meta then
			count = count + v:GetCount( );
		end
	end
	print( count, stack:GetCount() );
	if count < stack:GetCount( ) then
		return false;
	else
		local needed = stack:GetCount( );
		for k,v in pairs( self.stacks )do
			if v.meta == meta then
				local size = v:GetCount( );
				if size > needed then
					v:SetCount( size - needed );
					self:SyncSlot( k );
				else
					self:SetSlot( k, nil );
					self:SyncSlot( k );
				end
				needed = needed - size;
				if needed <= 0 then break end
			end
		end
		return true;
	end
end

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
function inv_mt:CountItems( selector )
	local c = 0;
	for k,v in pairs( self.stacks )do
		if selector( v ) then
			c = c + v:GetCount( );
		end
	end
	return c;
end


function inv_mt:Hash( )
	local hashstr = {};
	for k,v in SortedPairs( self.stacks )do
		hashstr[#hashstr+1] = k..','..v.meta.class..','..v:GetCount();
	end
	return util.CRC( table.concat( hashstr, ',' ) )%1073741824;
end



-- 
-- ENTITY INVENTORIES
--
util.AddNetworkString('gmodz_ent_invLink');
util.AddNetworkString('gmodz_ent_getInvLinks');

-- LINK INVENTORY
net.Receive( 'gmodz_ent_getInvLinks', function( len, pl )
	local e = net.ReadEntity();
	local invs = e:GetInventories();
	if not invs then return end
	
	for strid,inv in pairs( invs )do
		net.Start( 'gmodz_ent_invLink' );
			net.WriteEntity( e );
			net.WriteString( strid );
			net.WriteInt( inv.id, 32 );
		net.Send( player.GetAll() );
	end
end);

-- clean up after ourselves.
gmodz.hook.Add( 'EntityRemoved', function( ent )
	local invs = ent:GetInventories( );
	if( invs )then
		-- LET INVENTORY EDITORS KNOW THE INVENTORY IS GONE.
		for _, v in pairs( invs )do
			local editors = v:GetEditors( );
			for _, pl in pairs( editors )do
				if not IsValid( pl ) or pl == ent then continue end
				net.Start( 'gmodz_delInv' );
					net.WriteInt( v.id, 32 );
				net.Send( pl );
			end
		end
	end
end);
--
-- ADD ENTITY META METHODS
--
local Entity = FindMetaTable( 'Entity' );
function Entity:AssignInv( strid, inv )
	if not self.invs then self.invs = {} end
	self.invs[ strid ] = inv;
	gmodz.print('Assigned inventory "'..strid..'" with id '..inv.id );
	
	net.Start( 'gmodz_ent_invLink' );
		net.WriteEntity( self );
		net.WriteString( strid );
		net.WriteInt( inv.id, 32 );
	net.Send( player.GetAll() );
end

function Entity:GetInventories( )
	return self.invs;
end

function Entity:GetInv( strid )
	return self.invs and self.invs[ strid ] or nil ;
end

function Entity:InvAddEditor( strid, pl, canModify )
	local inv = self:GetInv( strid );
	if not inv then return end
	
	gmodz.print("Player "..pl:Name().." subscribed to inventory ".. strid );
	inv:AddEditor( pl );
	
	if canModify then
		inv:AddModifier( pl );
	end
end

function Entity:InvDelEditor( strid, pl )
	local inv = self:GetInv( strid );
	if not inv then return end
	
	inv:DelEditor( pl );
	inv:DelModifier( pl );
end



--
-- EDITING UTILITIES
--

util.AddNetworkString('gmodz_inv_moveStack');
net.Receive( 'gmodz_inv_moveStack', function( len, pl )
	
	local invid1 = net.ReadUInt(32);
	local sIndex1 = net.ReadUInt(16);
	local invid2 = net.ReadUInt(32);
	local sIndex2 = net.ReadUInt(16);
	local qty = net.ReadUInt(16);
	
	local invSource = inventories[ invid1 ];
	local invDest = inventories[ invid2 ];
	if not invSource or not invDest then
		pl:ChatPrint('[ERROR] Can not move items between nonexistant inventories.');
		return ;
	end
	
	if not invSource:CanModify( pl ) and ( not invDest or invDest:CanModify( pl ) ) then
		pl:ChatPrint('[ERROR] Access denied.');
		return ;
	end
	
	local stackSource = invSource:GetSlot( sIndex1 );
	local stackDest   = invDest:GetSlot( sIndex2 );
	
	if not stackSource then
		pl:ChatPrint('[ERROR] Source slot is empty! Could not complete transfer.' );
		invSource:SyncSlot( sIndex1 );
		invDest:SyncSlot( sIndex2 );
		return ;
	end
	
	if qty > stackSource:GetCount() then
		pl:ChatPrint(string.format('[ERROR] Transfer quantity %d excedes source stack size of %d! Can not complete transfer.', qty, stackSource:GetCount() ) );
		invSource:SyncSlot( sIndex1 );
		invDest:SyncSlot( sIndex2 );
		return ;
	end
	
	if stackDest then
		-- merge into the existing stack...
		local destMeta = stackDest.meta;
		if destMeta ~= stackSource.meta then
			pl:ChatPrint(string.format('[ERROR] Can not merge stacks of type "%s" and "%s".', destMeta.PrintName or destMeta.class, stackSource.meta.PrintName or stackSource.meta.class ) );
			invSource:SyncSlot( sIndex1 );
			invDest:SyncSlot( sIndex2 );
			return ;
		end
		
		-- check the total size.
		local totalSize = stackDest:GetCount() + qty;
		if totalSize > destMeta.StackSize then
			pl:ChatPrint( string.format('[ERROR] %d excedes max StackSize of %d', totalSize, destMeta.StackSize ));
			invSource:SyncSlot( sIndex1 );
			invDest:SyncSlot( sIndex2 );
			return ;
		end
		
		-- actually merge them and send back the result.
		stackSource:SetCount( stackSource:GetCount() - qty );
		stackDest:SetCount( stackDest:GetCount() + qty );
		invDest:SyncSlot( sIndex2 );
		if( stackSource:GetCount() == 0 )then
			invSource:SetSlot( sIndex1, nil, nil );
		else
			invSource:SyncSlot( sIndex1 );
		end
	else
		local sourceMeta = stackSource.meta;
		if qty > sourceMeta.StackSize then
			pl:ChatPrint(string.format('[ERROR] %d excedes max StackSize of %d', qty, sourceMeta.StackSize ) );
			invSource:SyncSlot( sIndex1 );
			invDest:SyncSlot( sIndex2 );
		end
		
		local ns = stackSource:Copy();
		ns:SetCount( qty );
		invDest:SetSlot( sIndex2, ns );
		
		stackSource:SetCount( stackSource:GetCount() - qty );
		if stackSource:GetCount() == 0 then
			invSource:SetSlot( sIndex1, nil, nil );
		else
			invSource:SyncSlot( sIndex1 );
		end
	end
	
	invDest:SyncHash( );
	invSource:SyncHash( );
end);

--
-- REQUEST RESYNC
--
util.AddNetworkString('gmodz_requestResync')
net.Receive( 'gmodz_requestResync', function( len, pl )
	local invid = net.ReadUInt( 32 );
	local inv = inventories[ invid ];
	if not inv then
		pl:ChatPrint("[ERROR] No inventory with given id: "..invid );
		return ;
	end
	if not table.HasValue( inv.editors, pl )then
		pl:ChatPrint("[ERROR] You don't have perms to view this inventory!");
		return ;
	end
	
	net.Start( 'gmodz_syncInv' );
		net.WriteInt( inv.id, 32 );
		net.WriteTable( inv:SaveToTable( ) );
	net.Send( pl );
	
	pl:ChatPrint('Error corrected. Inventory re-synced with server.');
end);