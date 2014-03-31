if CLIENT then
	gmodz.createSetting( 'viewmode', { defval = 0 } );
	gmodz.createSetting( 'deathmode', { defval = 1 } );
	gmodz.createSetting( 'gui_scale', { defval = 1 } );
	
	gmodz.hook.Add( 'F4', function( )
		gmodz.setVar( 'viewmode', gmodz.getVar( 'viewmode' ) == 0 and 1 or 0 );
		gmodz.saveSettings( );
	end);
elseif SERVER then
	
	
end