util.AddNetworkString( 'medit_SendNode' );
local function SendNode( node, pl )
	net.Start( 'medit_SendNode' );
		net.WriteTable( node:SaveToTable() );
	net.Send( pl );
end

util.AddNetworkString( 'medit_NodeInvalidate' );
local function InvalidateNode( node, pl )
	net.Start( 'medit_NodeInvalidate' );
		net.WriteUInt( type( node ) == 'table' and node:GetID() or node, 16 );
	net.Send( pl );
end
	
-- USER COMMANDS.
util.AddNetworkString( 'medit_ui_RequestNodes' );
local editors = {};
net.Receive( 'medit_ui_RequestNodes', function( len, pl )
	if not pl:IsSuperAdmin() then return end
	table.insert( editors, pl );
	
	gmodz.print('[MEDIT-UI] Player '..pl:Name()..' requested nodes.');
	for k,v in pairs( medit.mapnodes )do
		SendNode( v, pl );
	end
end);

util.AddNetworkString( 'medit_ui_CreateNode' );
net.Receive( 'medit_ui_CreateNode', function( len, pl )
	if not pl:IsSuperAdmin() then return end
	gmodz.print('[MEDIT-UI] Player '..pl:Name()..' created a node.');
	
	local n = medit.newNode():LoadFromTable( net.ReadTable() );
	n:AssignID( );
	medit.mapnodes[ n:GetID() ] = n;
	
	SendNode( n, editors );
	
	
end);

util.AddNetworkString( 'medit_ui_DelNode' );
net.Receive( 'medit_ui_DelNode', function( len, pl )
	if not pl:IsSuperAdmin() then return end
	
	local id = net.ReadUInt( 16 );
	gmodz.print('[MEDIT-UI] Player '..pl:Name()..' removed node: '.. id );
	medit.mapnodes[ id ] = nil;
	InvalidateNode( id, editors );
	
end);


util.AddNetworkString( 'medit_ui_ApplyChanges' );
net.Receive( 'medit_ui_ApplyChanges', function( len, pl )
	if not pl:IsSuperAdmin() then return end 
	medit.DeactivateNodes( );
	medit.ClearNPCS( );
	medit.ActivateNodes( );
	
	medit.SaveNodes( )
end);

util.AddNetworkString( 'medit_ui_Unload' );
net.Receive( 'medit_ui_Unload', function( len, pl )
	if not pl:IsSuperAdmin() then return end 
	medit.DeactivateNodes( );
	medit.ClearNPCS( );
end);