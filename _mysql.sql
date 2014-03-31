DROP TABLE IF EXISTS gmodz_users ;
DROP TABLE IF EXISTS gmodz_shop ;
DROP TABLE IF EXISTS gmodz_nodes ;
CREATE TABLE gmodz_users ( 
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
			UNIQUE( `steamid` ) );

CREATE TABLE gmodz_shop (
			`steamid` VARCHAR( 30 ) NOT NULL,
			`itemid` VARCHAR( 30 ) NOT NULL,
			`data` TEXT,
			UNIQUE( `steamid`, `itemid` ) );