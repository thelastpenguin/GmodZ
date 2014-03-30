resource.AddSingleFile( 'resource/fonts/BAD GRUNGE.ttf' );
resource.AddSingleFile( 'resource/fonts/KGAllofMe.ttf' );
resource.AddSingleFile( 'resource/fonts/Michroma.ttf' );
resource.AddSingleFile( 'resource/fonts/Press Style.ttf' );


local function AddDir(dir, str )
	local flist, dlist = file.Find( dir.."/*", 'GAME')
	for _, fdir in pairs(dlist) do
		if fdir != ".svn" then // Don't spam people with useless .svn folders
			gmodz.print('[FILESYS] Adding Dir '..dir..'/'..fdir..'/' );
			AddDir(dir.."/"..fdir)
		end
	end
 	
 	local str = '';
 	for i = 1, string.len( dir..'/' ) do
 		str = str..' ';
 	end
	for k,v in pairs(flist) do
		resource.AddFile(dir.."/"..v)
	end
end
 
AddDir("materials/gmodz");
AddDir("materials/blood");
AddDir("materials/models/warz");

AddDir("models/warz");

AddDir("sound/eating_and_drinking");
AddDir("sound/weapons/melee");