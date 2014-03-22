resource.AddSingleFile( 'materials/gmodz/gui/concrete/background.png' );
resource.AddSingleFile( 'materials/gmodz/gui/concrete/border.png' );
resource.AddSingleFile( 'materials/gmodz/gui/concrete/borderselected.png' );
resource.AddSingleFile( 'materials/gmodz/gui/concrete/tile.png' );
resource.AddSingleFile( 'materials/gmodz/gui/concrete/256x512.png' );
resource.AddSingleFile( 'materials/gmodz/gui/concrete/512x128.png' );

resource.AddSingleFile( 'resource/fonts/BAD GRUNGE.ttf' );
resource.AddSingleFile( 'resource/fonts/KGAllofMe.ttf' );
resource.AddSingleFile( 'resource/fonts/Michroma.ttf' );


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
 
AddDir("materials/gmodz")
AddDir("materials/blood");
AddDir("materials/models/warz")

AddDir("models/warz")

AddDir("sound/eating_and_drinking");