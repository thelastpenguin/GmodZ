/*
 * This file is subject to the terms and conditions defined in
 * file 'LICENSE.html', which is part of this source code package.
 * removing or modifying this header is a violation of the terms 
 * and conditions defined in 'LICENSE.txt'
 */


gmodz = {}; -- core table.

if (SERVER )then
	AddCSLuaFile( 'lib/source_compiler_sh.lua' );
end
include( 'lib/source_compiler_sh.lua' );

--gmodz.src_start( GM.FolderName..'/gamemode' );
--local include = gmodz.src_include ;

if( SERVER )then
	gmodz.include_cl = AddCSLuaFile ;
	gmodz.include_sv = include ;
	gmodz.include_sh = function( ... ) include( ... ) AddCSLuaFile( ... ) end ;
elseif( CLIENT )then
	gmodz.include_cl = include ;
	gmodz.include_sv = function( ) end -- dfgaf.
	gmodz.include_sh = include ;
end

--
-- SETUP GAMEMODE AND DERIVATION
--
MsgC( SERVER and Color( 0, 155, 255 ) or Color( 255, 0, 0 ),   '\n\n====================================\n= ' );
MsgC( SERVER and Color( 0, 255, 255 ) or Color( 255, 155, 0 ), 'Loading GmodZ by thelastpenguin™')
MsgC( SERVER and Color( 0, 155, 255 ) or Color( 255, 0, 0 ),   ' =\n====================================\n' );


GM.VersionNUMARIC = {1,0,0};
GM.Version = table.concat( GM.VersionNUMARIC, '.' );
GM.Name = "GmodZ"
GM.Author = "TheLastPenguin"

DeriveGamemode("base")

--
-- SETUP DIRECTORY STRUCTURES
--
file.CreateDir( 'gmodz' );
if( SERVER )then
	file.CreateDir( 'gmodz/sv' );
else
	file.CreateDir( 'gmodz/cl' );
end

-- DEFAULT TEAMS
TEAM_LOADING = 1; team.SetUp( TEAM_LOADING, 'Loading', Color( 200, 200, 200 ), false );
TEAM_SURVIVER = 2; team.SetUp( TEAM_SURVIVER, 'Survivers', Color( 100, 200, 100 ), true );

--
-- INCLUDE STUFF
--
gmodz.include_sh '_config_sh.lua' ;
gmodz.include_sh '_config_models_sh.lua' ;
gmodz.include_cl 'fonts_cl.lua' ;

-- LOAD CORE LIBS
gmodz.include_sh 'lib/string_sh.lua' ;
gmodz.include_sh 'lib/fancyprint_sh.lua' ;
gmodz.include_sh 'lib/phooks_sh.lua' ;
gmodz.include_sh 'lib/pon_sh.lua' ;
gmodz.include_sv 'lib/mysql_sv.lua' ;
gmodz.include_sh 'lib/functionutils_sh.lua' ;
gmodz.include_cl 'lib/draw_cl.lua' ;


gmodz.include_sv 'resource_sv.lua' ;

-- OTHER LIBS
gmodz.include_sh 'lib/settings_sh.lua' ;
gmodz.include_sh 'd_options_sh.lua' ;

-- UTILITY FUNCTIONS
gmodz.include_sv 'util/data_sv.lua' ;
gmodz.include_sv 'util/pdata_sv.lua' ;
gmodz.include_cl 'util/pdata_cl.lua' ;
gmodz.include_sh 'util/player_sh.lua' ;
gmodz.include_cl 'util/entity_cl.lua' ;
gmodz.include_cl 'util/3dmenuSys_cl.lua' ;
--gmodz.include_cl 'util/escmenu_cl.lua' ;


-- GENERAL CLIENTSIDE GRAPHICS
gmodz.include_cl 'core/hud_cl.lua' ;
gmodz.include_cl 'core/rendereffects_cl.lua' ;
gmodz.include_cl 'core/scoreboard_cl.lua' ;
gmodz.include_cl 'core/mainmenu_cl.lua' ;
gmodz.include_sv 'core/mainmenu_sv.lua' ;

-- LOAD THE ITEM SYSTEM
gmodz.include_sh 'core/items_load_sh.lua' ;

gmodz.include_sh 'core/inventory/meta_stack_sh.lua' ;
gmodz.include_sv 'core/inventory/meta_inventory_sv.lua' ;
gmodz.include_cl 'core/inventory/meta_inventory_cl.lua' ;

gmodz.include_sv 'core/inventory/itemstacks_sv.lua' ;

gmodz.include_sv 'core/concommands_sv.lua' ;

gmodz.include_sv 'core/inventory/invmenu_sv.lua' ;
gmodz.include_cl 'core/inventory/invmenu_cl.lua' ;

gmodz.include_sv 'core/inventory/hotbar_sv.lua' ;
gmodz.include_cl 'core/inventory/hotbar_cl.lua' ;

-- CHAT SYSTEM
gmodz.include_sh 'core/chat_sh.lua' ;

-- MAP EDITING SYSTEM
if medit and medit.DeactivateNodes then medit.DeactivateNodes( ) end
_G.medit = {};
gmodz.include_sv 'core/map_editor/nodemanager_sv.lua' ;
gmodz.include_sv 'core/map_editor/mapeditor_sv.lua' ;
gmodz.include_cl 'core/map_editor/mapeditor_cl.lua' ;

gmodz.include_sh 'core/map_editor/meta_node_sh.lua' ;
gmodz.include_sh 'core/map_editor/node_types_sh.lua' ;


gmodz.include_cl 'core/map_editor/preview_cl.lua' ;

-- HOOK SYSTEM
gmodz.include_sv 'core/hooks_sv.lua' ;
gmodz.include_cl 'core/hooks_cl.lua' ;



-- LOAD VGUI.
local function include_folder( path )
	local fol = GM.FolderName .. path ;
	local files = file.Find( fol .. "*.lua", 'LUA' )
	for k,v in pairs( files )do
		local p = fol .. v ;
		gmodz.print('[LOAD] Included file '..p );
		if p:find( '_sv' )then
			gmodz.include_sv( p );
		elseif p:find( '_cl' )then
			gmodz.include_cl( p );
		elseif p:find( '_sh' )then
			gmodz.include_sh( p );
		end
	end
end


gmodz.print(' = LOADING VGUI = ' );
include_folder( '/gamemode/vgui/' );

gmodz.print(' = LOADING MODULES = ' );
include_folder( '/gamemode/modules/' );



gmodz.hook.Call( 'LoadComplete' );
gmodz.hook.DeleteAll( 'LoadComplete' ); 


/*gmodz.src_output( 'gmodz/'..( SERVER and 'src_server.txt' or 'src_client.txt' ), function( out )
	return SERVER and [[AddCSLuaFile( 'init_cl.lua' ); ]]..out or out ; 
end );*/