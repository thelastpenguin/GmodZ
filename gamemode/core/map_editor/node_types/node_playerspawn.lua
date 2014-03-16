local NODE = {};
NODE.PrintName = 'Player Spawn';
NODE.Color = Color( 255, 0, 255 );

NODE.hull = Vector(5,5,5);
function NODE:Activate( node )
	local spawn = ents.Create( 'info_player_start' );
	node.ent = spawn;
	spawn:SetPos( node:GetPos( ) );
	spawn:Spawn( );
	spawn.gmodz = true;
	
	for k,v in pairs( ents.FindByClass( 'info_player_start' ) )do
		if v.gmodz then continue end
		v:Remove( );
	end
end

NODE.base = 'base';

NODE.settings = {};

medit.nodetype.register( 'node_player_spawn', NODE );
