CREATE TABLE IF NOT EXISTS gmodz_users ( 
			`steamid` VARCHAR( 30 ) NOT NULL,
			`mdl` VARCHAR( 50 ), 
			`inventory` TEXT,
			`bank` TEXT,
			`dHealth` TINYINT UNSIGNED,
			`dFood` TINYINT UNSIGNED,
			`dWater` TINYINT UNSIGNED,
			`dTimePlayed` INT UNSIGNED,
			`dDeaths` INT UNSIGNED,
			`dKilledZombies` INT UNSIGNED,
			`dKilledCivilians` INT UNSIGNED,
			`dKilledBandits` INT UNSIGNED,
			`karma` TINYINT,
			`posx` INT,
			`posy` INT,
			`posz` INT,
			UNIQUE( `steamid` ) );

CREATE TABLE IF NOT EXISTS gmodz_shop (
			`steamid` VARCHAR( 30 ) NOT NULL,
			`itemid` VARCHAR( 30 ) NOT NULL,
			`data` TEXT,
			UNIQUE( `steamid`, `itemid` ) );

CREATE TABLE IF NOT EXISTS gmodz_factions ( 
			`factionid` VARCHAR( 30 ) NOT NULL,
			`name` VARCHAR( 255) NOT NULL,
			`color_r` TINYINT UNSIGNED NOT NULL,
			`color_g` TINYINT UNSIGNED NOT NULL,
			`color_b` TINYINT UNSIGNED NOT NULL,
			`maxplayers` INT UNSIGNED NOT NULL,
			UNIQUE( `id` ) );

CREATE TABLE IF NOT EXISTS gmodz_faction_members ( 
			`steamid` VARCHAR( 30 ) NOT NULL,
			`factionid` VARCHAR( 30 ) NOT NULL 
			)