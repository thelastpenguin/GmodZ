if( SERVER )then
	function gmodz.print( msg, color )
		MsgC( Color(0,0,255), '[GmodZ] ' );
		MsgC( color or color_white, msg..'\n' );
		
	end
	
	util.AddNetworkString( 'gmodz_adminconlog' );
	function gmodz.adminLog( msg, color )
		color = color or color_white;
		
		gmodz.print( '[LOG] '.. msg, color );
		local recipiants = {};
		for _, pl in pairs( player.GetAll() )do
			if( pl:IsAdmin() or pl:IsListenServerHost() )then
				table.insert( recipiants, pl );
			end
		end
		
		net.Start( 'gmodz_adminconlog' );
			net.WriteVector( Vector( color.r, color.g, color.b ))
			net.WriteString( msg );
		net.Send( recipiants );
	end
elseif( CLIENT )then
	function gmodz.print( msg, color )
		MsgC( Color(255,155,0), '[GmodZ] ' );
		MsgC( color or color_white, msg..'\n' );
	end
	
	net.Receive( 'gmodz_adminconlog', function( )
		local vecCol = net.ReadVector( );
		local color = Color( vecCol.x, vecCol.y, vecCol.z );
		local msg = net.ReadString( );
		gmodz.print( '[LOG] '.. msg, color );
	end);
end