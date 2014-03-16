gmodz.hook.Add( 'OnEntityCreated', function( e )
	if( e:IsPlayer() and not e.udata )then
		e.udata = {};
	end
end);

net.Receive( 'gmodz_udata_sync', function()
	local ent = net.ReadEntity( );
	local dat = net.ReadTable( );
	ent.udata[ dat[1] ] = dat[2];
	gmodz.print("[UDATA] updated field '"..dat[1].."' to value '".. (dat[2] or 'nil') .."'" );
end);


local Player = FindMetaTable( 'Player' )
function Player:GetUData( var )
	return self.udata[var];
end