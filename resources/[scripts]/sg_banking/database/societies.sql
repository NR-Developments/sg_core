CREATE TABLE IF NOT EXISTS `sg_banking_societies` (
    `name` VARCHAR(64) NOT NULL PRIMARY KEY,
    `label` VARCHAR(100) NOT NULL,
    `balance` BIGINT UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS `sg_banking_society_owners` (
    `society` VARCHAR(64) NOT NULL,
    `character_id` INT(11) NOT NULL,
    PRIMARY KEY (`society`, `character_id`),
    FOREIGN KEY (`society`) REFERENCES `sg_banking_societies` (`name`) ON DELETE CASCADE,
    FOREIGN KEY (`character_id`) REFERENCES `nd_characters` (`charid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS `sg_banking_society_history` (
    `id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `society` VARCHAR(64) NOT NULL,
    `actor` VARCHAR(100) NOT NULL,
    `amount` BIGINT NOT NULL,
    `reason` VARCHAR(255) NOT NULL,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX (`society`, `id`),
    FOREIGN KEY (`society`) REFERENCES `sg_banking_societies` (`name`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
