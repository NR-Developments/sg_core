-- SG Framework: full resource-owned database schema
-- Import into the database selected in server.cfg before starting resources.
-- Target: MySQL 8.0.13+ or MariaDB 10.6+. UTF-8 (utf8mb4), InnoDB.
-- This is a schema, not a dump of player records or server data.
-- Re-import creates missing tables only; it does not migrate existing columns.
-- Existing nd_* and renzu_* names are retained because runtime queries use them.
-- Includes native default stack plus storage owned by bundled optional add-ons.
-- Does not fabricate ESX/QB users/players/owned_vehicles/player_vehicles authorities,
-- their jobs/items/licensing/society tables, or absent external housing resources.
-- Optional scripts with unresolved legacy dependencies remain disabled; see database/README.md.
-- Door/map-specific seeds and example shop stock are not installed automatically.
-- Original resource authors and licenses remain applicable; sources are identified below.

SET NAMES utf8mb4;

-- Source: resources/[scripts]/sg_core/database/characters.sql
CREATE TABLE IF NOT EXISTS `nd_characters` (
    `charid` INT(10) NOT NULL AUTO_INCREMENT,
    `identifier` VARCHAR(200) NOT NULL DEFAULT '0',
    `name` VARCHAR(50) DEFAULT NULL,
    `firstname` VARCHAR(50) DEFAULT NULL,
    `lastname` VARCHAR(50) DEFAULT NULL,
    `dob` VARCHAR(50) DEFAULT NULL,
    `gender` VARCHAR(50) DEFAULT NULL,
    `cash` INT(10) DEFAULT '0',
    `bank` INT(10) DEFAULT '0',
    `phonenumber` VARCHAR(20) DEFAULT NULL,
    `groups` LONGTEXT DEFAULT ('[]'),
    `metadata` LONGTEXT DEFAULT ('[]'),
    `inventory` LONGTEXT DEFAULT ('[]'),
    PRIMARY KEY (`charid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_core/database/vehicles.sql
CREATE TABLE IF NOT EXISTS `nd_vehicles` (
    `id` INT(11) NOT NULL AUTO_INCREMENT,
    `owner` INT(11) DEFAULT NULL,
    `plate` VARCHAR(255) DEFAULT NULL,
    `glovebox` LONGTEXT DEFAULT ('[]'),
    `trunk` LONGTEXT DEFAULT ('[]'),
    `properties` LONGTEXT DEFAULT ('[]'),
    `stored` INT(11) DEFAULT '1',
    `impounded` INT(11) DEFAULT '0',
    `stolen` INT(11) DEFAULT '0',
    `metadata` LONGTEXT DEFAULT ('[]'),
    PRIMARY KEY (`id`) USING BTREE,
    INDEX `owner` (`owner`) USING BTREE,
    CONSTRAINT `vehowner` FOREIGN KEY (`owner`) REFERENCES `nd_characters` (`charid`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_banking/database/accounts.sql
CREATE TABLE IF NOT EXISTS `nd_banking_accounts` (
    `owner` INT(11) DEFAULT NULL,
    `account_number` VARCHAR(50) DEFAULT NULL,
    `history` LONGTEXT DEFAULT ('[]'),
    INDEX `owner` (`owner`) USING BTREE,
    CONSTRAINT `accountowner` FOREIGN KEY (`owner`) REFERENCES `nd_characters` (`charid`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_banking/database/invoices.sql
CREATE TABLE IF NOT EXISTS `nd_banking_invoices` (
    `invoice_id` INT(11) AUTO_INCREMENT,
    `sender_name` VARCHAR(50) DEFAULT NULL,
    `receiver_name` VARCHAR(50) DEFAULT NULL,
    `sender_account` VARCHAR(50) DEFAULT NULL,
    `receiver_account` VARCHAR(50) DEFAULT NULL,
    `amount` INT(11) DEFAULT NULL,
    `created` VARCHAR(50) DEFAULT NULL,
    `due_in` VARCHAR(50) DEFAULT NULL,
    `status` VARCHAR(50) DEFAULT NULL,
    PRIMARY KEY (`invoice_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_mdt/bridge/nd/database/bolos.sql
CREATE TABLE IF NOT EXISTS `nd_mdt_bolos` (
	`id` INT(11) AUTO_INCREMENT,
	`type` VARCHAR(50) DEFAULT NULL,
	`data` LONGTEXT DEFAULT ('[]'),
	`timestamp` INT(11) DEFAULT (unix_timestamp()),
	PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_mdt/bridge/nd/database/records.sql
CREATE TABLE IF NOT EXISTS `nd_mdt_records` (
	`character` INT(11) DEFAULT NULL,
	`records` LONGTEXT DEFAULT ('[]'),
	INDEX `character` (`character`) USING BTREE,
	CONSTRAINT `FK_nd_mdt_characters` FOREIGN KEY (`character`) REFERENCES `nd_characters` (`charid`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_mdt/bridge/nd/database/reports.sql
CREATE TABLE IF NOT EXISTS `nd_mdt_reports` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`type` VARCHAR(50) DEFAULT NULL,
	`data` LONGTEXT DEFAULT ('[]'),
	`timestamp` INT(11) DEFAULT (unix_timestamp()),
	PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_mdt/bridge/nd/database/weapons.sql
CREATE TABLE IF NOT EXISTS `nd_mdt_weapons` (
	`character` INT(11) DEFAULT NULL,
	`weapon` VARCHAR(50) DEFAULT NULL,
	`serial` VARCHAR(50) DEFAULT NULL,
	`owner_name` VARCHAR(100) DEFAULT NULL,
	`stolen` INT(1) DEFAULT '0',
	INDEX `FK_nd_mdt_weapons_characters` (`character`) USING BTREE,
	CONSTRAINT `FK_nd_mdt_weapons_characters` FOREIGN KEY (`character`) REFERENCES `nd_characters` (`charid`) ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/ox_inventory/modules/mysql/server.lua
CREATE TABLE IF NOT EXISTS `ox_inventory` (
			`owner` varchar(60) DEFAULT NULL,
			`name` varchar(100) NOT NULL,
			`data` longtext DEFAULT NULL,
			`lastupdated` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
			UNIQUE KEY `owner` (`owner`,`name`)
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[dependencies]/ox_doorlock/sql/ox_doorlock.sql
CREATE TABLE IF NOT EXISTS `ox_doorlock` (
        `id` int (11) unsigned NOT NULL AUTO_INCREMENT,
        `name` varchar(50) NOT NULL,
        `data` longtext NOT NULL,
        PRIMARY KEY (`id`)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_phone/ef-phone.sql
CREATE TABLE IF NOT EXISTS `player_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `name` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `iban` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_phone/ef-phone.sql
CREATE TABLE IF NOT EXISTS `phone_invoices` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `amount` int(11) NOT NULL DEFAULT 0,
  `society` tinytext DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `sendercitizenid` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_phone/ef-phone.sql
CREATE TABLE IF NOT EXISTS `phone_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `number` varchar(50) DEFAULT NULL,
  `messages` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`),
  KEY `number` (`number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_phone/ef-phone.sql
CREATE TABLE IF NOT EXISTS `player_mails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `sender` varchar(50) DEFAULT NULL,
  `subject` varchar(50) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `read` tinyint(4) DEFAULT 0,
  `mailid` int(11) DEFAULT NULL,
  `date` timestamp NULL DEFAULT current_timestamp(),
  `button` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_phone/ef-phone.sql
CREATE TABLE IF NOT EXISTS `crypto_transactions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `title` varchar(50) DEFAULT NULL,
  `message` varchar(50) DEFAULT NULL,
  `date` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_phone/ef-phone.sql
CREATE TABLE IF NOT EXISTS `phone_gallery` (
   `citizenid` VARCHAR(255) NOT NULL , 
   `image` VARCHAR(255) NOT NULL ,
   `date` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_phone/ef-phone.sql
CREATE TABLE IF NOT EXISTS `phone_tweets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `citizenid` varchar(50) DEFAULT NULL,
  `firstName` varchar(25) DEFAULT NULL,
  `lastName` varchar(25) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `date` datetime DEFAULT current_timestamp(),
  `url` text DEFAULT NULL,
  `picture` text DEFAULT ('./img/default.png'),
  `tweetId` varchar(25) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `citizenid` (`citizenid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_customs/customs_mysql8.0below.sql
CREATE TABLE IF NOT EXISTS `sg_customs` (
	`shop` VARCHAR(64) NOT NULL COLLATE 'utf8mb4_general_ci',
	`inventory` LONGTEXT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`shop`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_projectcars/projectcars.sql
CREATE TABLE IF NOT EXISTS `sg_projectcars` (
  `plate` varchar(64) NOT NULL DEFAULT '',
  `identifier` varchar(64) NOT NULL DEFAULT '',
  `paint` varchar(128) NULL,
  `coord` varchar(255) NULL,
  `model` varchar(64) NULL,
  `status` longtext NULL,
  PRIMARY KEY (`plate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_projectcars/projectcars.sql
CREATE TABLE IF NOT EXISTS `sg_projectcars_items` (
  `identifier` varchar(64) NOT NULL DEFAULT '',
  `items` longtext NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_stancer/server.lua
CREATE TABLE IF NOT EXISTS `sg_stancer` (
			`plate` varchar(128) NOT NULL,
			`setting` longtext DEFAULT NULL
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_tuners/server/sql.lua
CREATE TABLE IF NOT EXISTS `renzu_tuner` (
			`id` int NOT NULL AUTO_INCREMENT KEY,
			`plate` varchar(60) DEFAULT NULL,
			`mileages` int DEFAULT 0,
			`vehiclestats` longtext DEFAULT NULL,
			`defaulthandling` longtext DEFAULT NULL,
			`vehicleupgrades` longtext DEFAULT NULL,
			`vehicletires` longtext DEFAULT NULL,
			`drivetrain` varchar(60) DEFAULT NULL,
			`advancedflags` longtext DEFAULT NULL,
			`ecu` longtext DEFAULT NULL,
			`nodegrade` int DEFAULT 0,
			`currentengine` varchar(60) DEFAULT NULL
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_motels/server/sql.lua
CREATE TABLE IF NOT EXISTS `sg_motels` (
			`id` int NOT NULL AUTO_INCREMENT KEY,
			`motel` varchar(64) DEFAULT NULL,
			`hour_rate` int DEFAULT 0,
			`revenue` int DEFAULT 0,
			`employees` longtext DEFAULT NULL,
			`rooms` longtext DEFAULT NULL,
			`owned` varchar(64) DEFAULT NULL
		) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_shops/server/db/sql.lua
CREATE TABLE IF NOT EXISTS `renzu_stores` (
		`id` int NOT NULL AUTO_INCREMENT KEY,
		`shop` varchar(60) DEFAULT NULL,
		`owner` varchar(64) DEFAULT NULL,
		`money` longtext DEFAULT NULL,
		`items` longtext DEFAULT NULL,
		`employee` longtext DEFAULT NULL,
		`cashier` longtext DEFAULT NULL,
		`customitems` longtext DEFAULT NULL,
		`job` varchar(64) DEFAULT NULL
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_shops/server/db/sql.lua
CREATE TABLE IF NOT EXISTS `movableshops` (
		`identifier` varchar(100) DEFAULT NULL,
		`owner` varchar(64) DEFAULT NULL,
		`money` longtext DEFAULT NULL,
		`items` longtext DEFAULT NULL,
		`plate` varchar(64) DEFAULT NULL,
		`type` varchar(64) DEFAULT NULL,
		`shopname` varchar(64) DEFAULT NULL,
		UNIQUE KEY `identifier` (`identifier`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_shops/server/db/sql.lua
CREATE TABLE IF NOT EXISTS `financedata` (
		`identifier` varchar(64) DEFAULT NULL,
		`max` INT(64) DEFAULT NULL,
		`financed` longtext DEFAULT NULL,
		UNIQUE KEY `identifier` (`identifier`)
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Source: resources/[scripts]/sg_simpleshop/esx_shops.sql
CREATE TABLE IF NOT EXISTS `shops1` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`store` varchar(100) NOT NULL,
	`item` varchar(100) NOT NULL,
	`price` int(11) NOT NULL,

	PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
