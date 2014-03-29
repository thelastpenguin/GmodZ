local src = {};
local basedir = nil ;
local activedir = nil ;
function gmodz.src_start( _basedir )
	table.Empty( src );
	basedir = _basedir ;
end

function gmodz.src_include( path )
	
	local f = file.Read( basedir..'/'..path, 'LUA' ) or file.Read( path, 'LUA' );
	if f then
		src[path] = f;
		include( path );
	else
		print("ERROR COULDN'T LINK FILE: "..basedir..'/'..path );
	end
end

function gmodz.src_output( out, postprocess )
	local final = {};
	final[#final+1] = [[local src = {}; local function include(path) if not src[path] then print("ERROR COULDN'T FIND PACKAGED FILE!!!"..path ) end src[path]() end ]]; 
	for k,v in pairs( src )do
		final[#final+1] = 'src[\''..k..'\'] = function() ';
		
		for _,l in pairs( string.Explode( '\n',v ) )do
			local l = string.gsub( l, '[ \t]+', ' ' );
			if not string.find( l, '[%a]' ) then continue end
			final[#final+1] = l;
		end
		
		final[#final+1] = ' end '
	end
	
	final[#final+1] = [[
		include( 'main_sh.lua' );
	]]
	local output = table.concat( final, '\n' );
	file.Write( out, postprocess( output ) );
end