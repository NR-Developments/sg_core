# SG Framework

Development integration branch for the resources in this repository. **The complete all-resource rewrite is not finished or production-validated.** The current change migrates gameplay resource names to `sg_*`, implements a shared SG character/economy authority, replaces incomplete ESX/QB adapters, and repairs the default startup configuration.

`sg_core` is derived from ND Core; original authors and individual resource licenses remain applicable. This is not a claim that the upstream work was originally authored by SG Studios.

## Setup

1. Use a separate test server and database. This branch retains the existing `nd_characters`, `nd_vehicles`, banking and MDT table names to preserve existing ND data; it does not import ESX `users` or QB `players` data.
2. Use a current FXServer artifact satisfying the bundled `oxmysql` manifest requirement (server build 12913 or later) and enable OneSync.
The supplied config targets GTA game build **3570**, per the server owner. `sv_stateBagStrictMode` is disabled because this bundled stack writes client-owned state bags. Apply the updated `server.cfg` settings when updating resources.

3. Set the license key and database connection in `server.cfg`. Review admin ACE entries and `sg_core.cfg` settings.
4. Start using `server.cfg`, which loads `sg_core.cfg`, `inventory.cfg`, then `resources.cfg`. Do not additionally ensure the whole `[scripts]` folder or run another core.
5. Core tables are created on first run; banking and MDT retain their own schema initialization. See [integration status](docs/INTEGRATION.md) before enabling optional add-ons.

The default set includes character selection, appearance shops, inventory/target/doors, status, banking, dealership, fuel, casino/blackjack, nitro, MDT, police and ambulance. These still require live gameplay validation. Competing shops, dealerships, and job/mechanic systems are not automatically started together.

Shared upstream libraries keep their established names (`ox_lib`, `oxmysql`, `ox_inventory`, `ox_target`, `ox_doorlock`, `fivem-appearance`, `pma-voice`). The `es_extended` and `qb-core` resources are compatibility entry points backed by SG, not independent player stores. They cover a subset of APIs; arbitrary ESX/QB/Qbox scripts are not guaranteed compatible. No complete Qbox adapter is supplied.

## Checks

```sh
python tools/test_core.py
python tools/test_startup.py
node tools/test_character_ui.js
python tools/audit_resources.py
```

These need Python 3.10+ and the Lua 5.4 shared library. They run mocked core/adapter contracts, inspect manifests and startup ordering, and structurally check declared Lua scripts after normalizing Cfx syntax. They do not launch FiveM, render NUI, connect to MySQL, or prove gameplay equivalence.

Run `sgdoctor` in the server console or as an administrator to inspect the default resource states and core database readiness. Follow [the live test checklist](docs/LIVE_TESTS.md). The committed [manifest audit](docs/resource-audit.json) includes unresolved optional-resource build/asset problems.
