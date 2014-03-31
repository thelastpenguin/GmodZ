local NODE = {};
NODE.PrintName = 'Crafting Table';
NODE.Color = Color( 0, 255, 0 );

NODE.base = 'base';
NODE.hull = Vector(5,5,5);

function NODE:Activate( node )
	local ctable = ents.Create( 'gmodz_craftingtable' );
	node.ent = ctable;
	
	local data = node:GetData( );
	
	ctable:SetPos( node:GetPos( ) );
	ctable:SetAngles( Angle( 0, data.rotation, 0 ) );
	ctable:Initialize( );
	ctable:Spawn( );
	ctable:SetMoveType( MOVETYPE_NONE );
end

NODE.settings = {};
NODE.settings['rotation'] = {
	PrintName = 'Rotation',
	type = 'Float',
	min = -180,
	max = 180,
	default = 1000
}

medit.nodetype.register( 'node_craftingtable', NODE );

-- SEE MODULE lootmanager_sv.lua
gmodz.hook.Add('medit_Cleanup',function()
	for k,v in pairs( ents.FindByClass( 'gmodz_craftingtable' ) )do
		v:Remove( );
	end
end);