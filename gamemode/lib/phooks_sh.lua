gmodz.hook = {};

local hooks = {};

function gmodz.hook.Add( hookid, func )
	if not hooks[ hookid ] then hooks[ hookid ] = {} end
	table.insert( hooks[ hookid ], func );
end

local ipairs = ipairs ;
function gmodz.hook.Call( hookid, ... )
	local chooks = hooks[ hookid ];
	if not chooks then return end
	for _, hook in ipairs( chooks )do
		local a, b, c, d = hook( ... );
		if( a ~= nil or b ~= nil )then
			return a, b, c, d;
		end
	end	
end
function gmodz.hook.DeleteAll( hookid )
	hooks[ hookid ] = nil;
end