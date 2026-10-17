# SG Framework database

Import **SG_Framework.sql** into the database named by `mysql_connection_string` in `server.cfg`, using HeidiSQL, phpMyAdmin or the MySQL/MariaDB client, before starting the server. Select your database first: the file deliberately contains no hardcoded `USE`, database creation, accounts, passwords, or player data.

The schema targets MySQL 8.0.13+ and MariaDB 10.6+. It creates **27 tables** with InnoDB and utf8mb4, with parent tables before their foreign-key children. Table names such as `nd_characters`, `nd_vehicles`, `nd_banking_*`, `nd_mdt_*`, `renzu_tuner` and `renzu_stores` match the current runtime queries and are intentional.

| Coverage | Tables |
| --- | --- |
| Native character and vehicle persistence | `nd_characters`, `nd_vehicles` |
| Banking | `nd_banking_accounts`, `nd_banking_invoices` |
| MDT | `nd_mdt_bolos`, `nd_mdt_records`, `nd_mdt_reports`, `nd_mdt_weapons` |
| Shared inventory and doors | `ox_inventory`, `ox_doorlock` |
| Phone-owned storage | `player_contacts`, `phone_invoices`, `phone_messages`, `player_mails`, `crypto_transactions`, `phone_gallery`, `phone_tweets` |
| Optional vehicle customization/projects | `sg_customs`, `sg_projectcars`, `sg_projectcars_items`, `sg_stancer`, `renzu_tuner` |
| Optional motels and shops | `sg_motels`, `renzu_stores`, `movableshops`, `financedata`, `shops1` |

Every table uses `CREATE TABLE IF NOT EXISTS`. Re-importing creates missing tables without deleting saved records. **It does not upgrade or repair columns in existing tables.** Back up an existing database before changing its schema. The individual resource schema files and automatic first-run creation remain available.

This file contains the full schemas defined by the bundled resources for their own storage. It does not make unfinished integrations work: optional scripts still referencing external ESX/QB `users`, `players`, `owned_vehicles`, `player_vehicles`, `jobs`, `job_grades`, `items`, licenses or society schemas need the ports in [INTEGRATION.md](../docs/INTEGRATION.md). Creating independent copies of these authorities would split SG player/vehicle data, so the consolidated import does not do that. The optional ND housing table is not included because its resource is absent. Door/map-specific inserts and example shop stock are also excluded; select those only for maps/items you actually use.

## Maintaining and testing the schema

The file is generated from resource SQL and Lua first-run DDL. Source comments identify each definition. The generator normalizes engines/charset and expression defaults, incorporates the movable-shop identifier width, and excludes duplicate legacy framework tables and broken legacy ALTER/example seed statements.

```sh
python tools/build_database.py
python tools/build_database.py --check
```

CI imports the schema twice into fresh MySQL 8.0 and MariaDB 10.11 databases, checks table coverage and data preservation, and exercises foreign-key rejection/cascades with test records. These database tests are separate from live FiveM gameplay testing.

Native SG society accounts, explicit character owners, and transaction history are included in the consolidated import. Use the server-console `societyowner` command documented in sg_banking to assign owners; boss ranks alone do not grant account access.
