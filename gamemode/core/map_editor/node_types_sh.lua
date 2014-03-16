medit.nodetype = {};

local nodetypes = {};
function medit.nodetype.GetStored( )
	return nodetypes;	
end

function medit.nodetype.GetMeta( class )
	return nodetypes[ class ];
end

function medit.nodetype.register( class, table )
	table.class = class;
	nodetypes[ class ] = table;
end

do
	local noCopy = {
		baseLinked = true,
		base = true,
		class = true	
	}
	local function linkNType( ntype )
		if( ntype.baseLinked )then return end
		
		ntype.baseLinked = true;
		
		if( ntype.base and nodetypes[ ntype.base ] )then
			local base = nodetypes[ ntype.base ];
			for k,v in pairs( base )do
				if not ntype[ k ] and not noCopy[ k ] then
					ntype[ k ] = v;
				end
			end
			
			linkNType( base );
		end
	end
	
	function medit.runLinker( )
		for _, ntype in pairs( nodetypes )do 
			linkNType( ntype );
		end
		
		for _, ntype in pairs( nodetypes )do
			ntype.baseLinked = nil;
		end
	end
	
end


-- LOAD NODE TYPES
local fol = GM.FolderName .. '/gamemode/core/map_editor/node_types/';
local files = file.Find( fol .. "*.lua", "LUA");
for _, f in SortedPairs( files, true )do
	local p = fol .. f;
	gmodz.include_sh( p );
end

medit.runLinker( );