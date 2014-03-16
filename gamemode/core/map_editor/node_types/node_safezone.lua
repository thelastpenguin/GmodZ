local NODE = {};
NODE.PrintName = 'Safe Zone';
NODE.Color = Color( 0, 255, 0 );

NODE.base = 'base';
NODE.hull = Vector(5,5,5);

function NODE:Activate( node )
	local safezone = ents.Create( 'node_safezone' );
	node.ent = safezone;
	
	local data = node:GetData( );
	
	safezone:SetPos( node:GetPos( ) );
	safezone:SetRadius( math.Round( data.radius ) );
	safezone:Spawn( );
end

NODE.settings = {};
NODE.settings['radius'] = {
	PrintName = 'Radius',
	type = 'Float',
	min = 100,
	max = 4000,
	default = 1000
}

medit.nodetype.register( 'node_safezone', NODE );