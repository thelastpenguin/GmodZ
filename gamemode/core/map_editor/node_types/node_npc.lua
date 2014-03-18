local NODE = {};
NODE.PrintName = 'NPC Node';
NODE.Color = Color( 255, 0, 0 );

NODE.base = 'base';
NODE.hull = Vector(5,5,5);

function NODE:Activate( node )
	local npc_maker = ents.Create( 'npc_maker' );
	node.ent = npc_maker;
	
	local data = node:GetData( );
	
	npc_maker:SetPos( node:GetPos( ) );
	
	npc_maker:SetKeyValue( "NPCType", data.npc_class[math.random(1,#data.npc_class)] )
	npc_maker:SetKeyValue( "MaxLiveChildren", data.max_children )
	npc_maker:SetKeyValue( "MaxNPCCount", 1000000 )
	npc_maker:SetKeyValue( "SpawnFrequency", data.spawn_rate )
	
	npc_maker:Fire( 'Enable', '1', 1 )
end

NODE.settings = {};
NODE.settings['npc_class'] = {
	PrintName = 'NPC Class',
	type = 'BooleanList',
	options = { 'npc_zombie', 'npc_fastzombie', 'npc_poisonzombie', 'npc_headcrab', 'npc_heacrab_poison', 'npc_headcrab_fast' }
}
NODE.settings['max_children'] = {
	PrintName = 'Max Children',
	type = 'Float',
	min = 1,
	max = 5,
	default = 1
}
NODE.settings['spawn_rate'] = {
	PrintName = 'Spawn rate',
	type = 'Float',
	min = 20,
	max = 600,
	default = 90
}

medit.nodetype.register( 'node_npc', NODE );