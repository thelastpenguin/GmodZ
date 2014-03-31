gmodz.cfg.models = {}

local mdls = {};
local function addModel( name, path )
	gmodz.cfg.models[ name ] = string.lower( path );
	mdls[#mdls+1] = string.lower( path );
end

gmodz.cfg.modelRandom = function()
	return mdls[math.random(1,#mdls)];
end


addModel( 'Group03-Female_01', "models/player/Group03/Female_01.mdl" );
addModel( 'Group03-Female_02', "models/player/Group03/Female_02.mdl" );
addModel( 'Group03-Female_03', "models/player/Group03/Female_03.mdl" );
addModel( 'Group03-Female_04', "models/player/Group03/Female_04.mdl" );
addModel( 'Group03-Female_06', "models/player/Group03/Female_06.mdl" );
addModel( 'group03-male_01', "models/player/group03/male_01.mdl" );
addModel( 'Group03-Male_02', "models/player/Group03/Male_02.mdl" );
addModel( 'Group03-male_03', "models/player/Group03/male_03.mdl" );
addModel( 'Group03-Male_04', "models/player/Group03/Male_04.mdl" );
addModel( 'Group03-Male_05', "models/player/Group03/Male_05.mdl" );
addModel( 'Group03-Male_06', "models/player/Group03/Male_06.mdl" );
addModel( 'Group03-Male_07', "models/player/Group03/Male_07.mdl" );
addModel( 'Group03-Male_08', "models/player/Group03/Male_08.mdl" );
addModel( 'Group03-Male_09', "models/player/Group03/Male_09.mdl" );

addModel( 'Group01-Female_01', "models/player/Group01/Female_01.mdl" );
addModel( 'Group01-Female_02', "models/player/Group01/Female_02.mdl" );
addModel( 'Group01-Female_03', "models/player/Group01/Female_03.mdl" );
addModel( 'Group01-Female_04', "models/player/Group01/Female_04.mdl" );
addModel( 'Group01-Female_06', "models/player/Group01/Female_06.mdl" );
addModel( 'group01-male_01', "models/player/group01/male_01.mdl" );
addModel( 'Group01-Male_02', "models/player/Group01/Male_02.mdl" );
addModel( 'Group01-male_03', "models/player/Group01/male_03.mdl" );
addModel( 'Group01-Male_04', "models/player/Group01/Male_04.mdl" );
addModel( 'Group01-Male_05', "models/player/Group01/Male_05.mdl" );
addModel( 'Group01-Male_06', "models/player/Group01/Male_06.mdl" );
addModel( 'Group01-Male_07', "models/player/Group01/Male_07.mdl" );
addModel( 'Group01-Male_08', "models/player/Group01/Male_08.mdl" );
addModel( 'Group01-Male_09', "models/player/Group01/Male_09.mdl" );