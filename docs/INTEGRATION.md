# Integration status

This is a reviewable development migration, not the completed full framework requested. Resource source, configuration, UI and streamed assets are retained wherever supplied. Most add-on gameplay logic was migrated by name rather than rewritten; the substantive implementation work is in the SG core, compatibility views, character persistence, inventory projection, and startup integration.

## Implemented

- `sg_hud` replaces the visible status/voice overlays using the uploaded Trew HUD layout, renderer, images and sounds. Native SG player/status data and PMA voice feed the existing UI; `sg_status` remains the gameplay backend with its overlay disabled. Society balance requires a real server-side provider; SG Banking does not currently have society accounts. See the resource README for controls, exports and scope.

- The core import returns its proxy table for `require("@sg_core.init")`, including ambulance bridges.
- Character and spawn NUI callback origins use `GetParentResourceName()`; other migrated add-on UIs use the same rule. Character slot IDs are one-based throughout UI actions, including sparse/contiguous serialized character lists.
- Selector initialization uses the manifest's ox_lib import rather than anonymously reloading it. Registration accepts an optional background story and persists nationality/background in SG metadata; failed registration reopens the form.
- Server config targets game build 3570 and disables state-bag strict mode to support the bundled client-owned state writes. Police shields work without the optional ND_GunAnims aiming override.

- Gameplay resources use `sg_*`; native core global/import/API is `SGCore` / `@sg_core/init.lua` / `exports.sg_core`.
- Core, banking, dealerships, MDT, police, ambulance, appearance and status references point to SG resource names and the SG native event namespace.
- Native SG always takes precedence over ESX/QB compatibility when selecting police/casino/MDT/target/door bridges. This avoids non-deterministic bridge selection when all compatibility entry points are started.
- ESX and QB player adapters create views, leaving the native job string, groups, identifier and methods intact. They share the SG ID and balances. Callback, usable-item, inventory, basic job and notification APIs are supplied.
- The inventory bridge projects a detached inventory player record instead of overwriting native character identity/groups. Cash changes continue through the SG inventory bridge.
- Character selection uses SG persistence and server-validated slots/ownership. The legacy unrestricted generic callback dispatcher and server character-creation events have been removed. Relog, appearance saving, configured slot counts, creation and deletion use SG.
- First-run core DDL is awaited in order, after exports exist. Add-on schema loads wait for core readiness. Periodic character saves supplement unload saves.
- Money methods reject NaN, infinity, negative/zero or fractional changes and insufficient balances. ESX `money` maps to cash rather than bank. SQL per-field saves use a column allowlist.
- Startup no longer references the absent `ND_Characters`/`npwd`, duplicate scoreboard variants or an absent anti-cheat import. A single scoreboard resource is retained; the alternate original variant is archived outside the resources folder.

## Remaining work before a full release

| Resources | Remaining integration/validation |
| --- | --- |
| Default set in `resources.cfg` | Real FXServer + MySQL startup; NUI focus/spawn/cameras; two-client character, money, inventory, job and vehicle persistence; police/ambulance/MDT/casino gameplay and server-event security audit. Static checks cannot establish this. |
| `sg_phone` | Port direct `players`, `player_vehicles`, apartments and banking SQL to SG; port optional racing/trucking/banking exports; prepare phone schema migrations; verify all apps and invoice security. Removing the missing apartments import alone does not complete this port. |
| `sg_vehicleshop`, `sg_customs`, `sg_projectcars`, `sg_tuners` | Port direct ESX/QB owned vehicle/society/storage accesses to the SG vehicle ownership model. Resolve duplicated dealerships and mechanic functionality by configuration. |
| `sg_motels`, `sg_shops`, `sg_simpleshop` | Port remaining SQL/licensing/society/optional clothes/job integrations; install compatible item definitions; verify ownership, stock and payment validation. |
| `sg_engine`, `sg_turbo`, `sg_stancer` | Validate item registration, native SG vehicle metadata/ownership, modifications and save/reload behavior. |
| `sg_bag`, `sg_itemback` | Upstream archive lacks several manifest-declared UI/component files. Reconstruct only the assets actually used, then validate bags/attachments and metadata. |
| `sg_hygiene`, `sg_illness` | Replace ESX status assumptions with SG status contracts and validate treatment, illness and persistence. The hygiene manifest also names a missing streamed file. |
| `sg_evidence`, `sg_dispatch` | Select one authoritative evidence/dispatch flow alongside SG police/MDT; port inventory/job assumptions and validate access controls. |
| `sg_civilianjobs` | Replace absent input/menu integrations or provide SG/ox menus; port payouts and delivery/vehicle ownership; validate each job. |
| `sg_scoreboard` | Replace ESX `users`/queue assumptions with SG online player data; validate permissions and counts. |
| `sg_airport`, `sg_mp3`, `sg_progressbar`, `sg_weather` | Validate native usage, external media, UI, optional assets and interactions with spawn/ambulance/weather control. No full gameplay rewrite was done. |
| `screenshot-basic` | Missing built `dist/*`, `yarn` and `webpack` resources. Supply/build the actual upstream artifacts before enabling camera/screenshot features. |
| External scripts | Complete API-by-API contracts, actual resources/imports and database migrations are needed. ESX/QB adapters do not imply compatibility with scripts that access original SQL tables or unsupported APIs. Qbox support is not implemented. |

## Behavior and migration details

The compatibility resources do not run ESX/QBCore themselves. ESX and QB character identifiers are SG's persisted numeric character ID represented as a string. Native SG keeps the account license identifier separately. Existing external integrations expecting ESX `charN:license` or QB citizen IDs must be migrated explicitly.

Group ranks are one-based natively; ESX/QB grade views are zero-based. ESX illicit accounts (`black_money`) and unsupported account names are rejected, rather than silently using bank/cash. No independent illicit-account economy has been added.

Legacy ND v1 `backwards` compatibility is disabled. Native `GetCoreObject`, lower-case exports and `@sg_core/init.lua` are the supported SG entry points. Existing ND third-party resources must be ported; old event/resource aliases are not provided.

The character selector no longer permits a client to teleport to any supplied vehicle network ID during preview. Last-vehicle re-entry requires an ownership-validated SG implementation before it can be restored. Custom identity integrations must supply a server-validated slot through `RegisterComplete`; the default registration UI is the supported configured path. Starter cash and bank are configured server-side; the previous ESX starter-item list is not automatically granted. Persistent extra selector states from the old resource KVP namespace are not migrated.

Database table names intentionally retain `nd_*` to avoid destructive renames and preserve installed data. SQL files remain with their resources as schema/backup sources. No destructive database conversion runs automatically.

Original license files, author fields and upstream URLs are retained. Runtime resource names and SG-facing references have changed; this does not transfer upstream copyright or imply endorsement.
