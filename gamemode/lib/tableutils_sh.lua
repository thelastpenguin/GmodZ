local istable = _G.istable ;

-- WIP FINISH
local function merge( tbl1, out )
	for k,v in ipairs( tbl1 )do
		table.insert( out, v );
	end
end
function table.flatten( tbl )
	local output = {};
	for k,v in ipairs( tbl )do
		if istable( v ) then
			merge( v, out );
		end
	end
end