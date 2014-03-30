medit.mapnodes = {};

--
-- SAVE NODES TO FILE.
--
file.CreateDir( 'gmodz/nodegraphs' )
function medit.SaveNodes( )
	gmodz.print('[MAPEDIT] Saving Nodes.');
	
	local nodes = medit.mapnodes;
	local output = {};
	for k,v in pairs( nodes )do
		output[ k ] = v:SaveToTable( );
	end
	
	file.Write( 'gmodz/nodegraphs/'..game.GetMap()..'.txt', gmodz.pon.encode( output ) );
	gmodz.print('[MAPEDIT] Saved nodes.');
end


--
-- LOAD NODES FROM FILE.
--
function medit.LoadNodes( )
	gmodz.print('[MEDIT] Loading nodes from file: '..game.GetMap() );
	
	local read = file.Read( 'gmodz/nodegraphs/'..game.GetMap()..'.txt', 'DATA' );
	local succ, data = pcall( gmodz.pon.decode, read );
	if not succ then
		gmodz.print('[ERROR] FAILED TO LOAD MAP NODES!', Color(255,0,0));
		return ;
	end
	
	medit.LoadNodesFromTable( data );
	
	gmodz.print('[MEDIT] Loaded nodes from file.');
end

--
-- LOAD NODES FROM TABLE
--
function medit.LoadNodesFromTable( data )
	gmodz.print('[MEDIT] Converting node table to meta structure.');
	
	local mapnodes = {};
	medit.mapnodes = mapnodes;
	for k,v in pairs( data )do
		local n = medit.newNode():LoadFromTable( v );
		mapnodes[ n:GetID() ] = n;
	end
	
	gmodz.print('[MEDIT] Created '..#data..' meta nodes from data struct.');
end

--
-- ACTIVATE NODES
--
function medit.ActivateNodes( )
	gmodz.print('[MEDIT] Activating nodes. ('..#medit.mapnodes..' nodes)');
	gmodz.hook.Call('medit_Cleanup' );
	gmodz.print(' * pre processing * ');
	gmodz.hook.Call('PreMapLoaded');
	gmodz.print(' * activating nodes * ' );
	for k,v in pairs( medit.mapnodes )do
		local mt =  v.meta;
		if not mt then continue end
		print('   - node: '..mt.class );
		mt:Activate( v );
		gmodz.hook.Call( 'ActivatedNode', v );
	end
	gmodz.print(' * calling hooks *' );
	gmodz.hook.Call( 'PostMapLoaded' );
	gmodz.print( '* activation complete *' );
	gmodz.print('[MEDIT] Nodes are activated.' );
end

do
	
	local garbage = {};
	function medit.EntityAddCleanup( ent )
		table.insert( garbage, ent );
	end
	
	function medit.DeactivateNodes( )
		gmodz.print('[MEDIT] Deactivating nodes.');
		gmodz.print(' * calling cleanup metamethod *' );
		local c = 0;
		for k,v in pairs( medit.mapnodes )do
			local mt =  v.meta;
			if not mt then continue end
			print('   - node: '..mt.class );
			mt:Cleanup( v );
			c = c + 1;
		end
		gmodz.print('    CLEARED: '..c );
		gmodz.print(' * clearing cleanup tables *' );
		local c = 0;
		for k,v in pairs( garbage )do
			if IsValid( v ) then
				v:Remove( );
				c = c + 1;
			end
		end
		gmodz.print('    CLEARED: '..c );
		gmodz.print('[MEDIT] Nodes deacitivated.');
	end
	function medit.ClearNPCS( )
		for k,v in pairs( ents.FindByClass( 'npc_*' ))do v:Remove() end
	end
end


--
-- LOAD EVERYTHING
--
timer.Simple( 1, function()
	medit.DeactivateNodes( )
	medit.LoadNodes( );
	medit.ActivateNodes( );
end);