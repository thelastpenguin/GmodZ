local NODE = {};
NODE.PrintName = 'Loot Node';
NODE.Color = Color( 0, 255, 0 );

NODE.base = 'base';

function NODE:Activate( node )

	local n = ents.Create( 'node_loot' );
	node.ent = n;
	
	
	n:SetPos( node:GetPos() );
	n:SetAngles( node:GetAngles( ) );
	
	n:SetConfig( node:GetData( ) );
	
	n:Initialize( );
	n:Spawn( );

end

NODE.settings = {};

local lootTypes = {};
gmodz.hook.Add( 'LoadComplete', function()
	for k,v in pairs( gmodz.item.GetStored( ) )do
		lootTypes[#lootTypes + 1 ] = k;
	end
	table.sort( lootTypes );
end);
NODE.settings['loot_types'] = {
	PrintName = 'Loot Type',
	type = 'BooleanList',
	options = lootTypes
}
NODE.settings['rate_mult'] = {
	PrintName = 'Rate Mult',
	default = 1,
	max = 5,
	min = 0.1
}

medit.nodetype.register( 'node_loot', NODE );

-- SEE MODULE lootmanager_sv.lua