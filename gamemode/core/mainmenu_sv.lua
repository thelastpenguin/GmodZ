util.AddNetworkString( 'gmodz_requestspawn' );
net.Receive( 'gmodz_requestspawn', function( len, pl )
	if pl:Team() == TEAM_LOADING then
		pl:SetTeam( TEAM_SURVIVER );
		pl:Spawn( );
	end
end);