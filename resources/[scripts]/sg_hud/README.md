# SG HUD

Native SG Framework integration of the supplied Trew HUD UI. Original HTML layout, CSS, JavaScript renderer, images, sounds and configuration display switches are retained. The HTML title and a nonvisual NUI readiness handshake are the only changes to the original UI document; a generic icon is added for unknown weapons. Original license and upstream documentation are included.

`resources.cfg` starts `sg_hud` after `sg_status`. `sg_status` remains enabled for needs, consumables, stamina and alcohol effects, with its own overlay disabled in `sg_status/config.lua`. `server.cfg` disables PMA's separate voice overlay. Apply these configuration changes and restart the server when installing this HUD. No new SQL tables are needed.

## Data connections

- Native SG cash, bank and job/rank update on load, character/job changes, money events and polling. The HUD hides in character selection and the pause menu and restores after a HUD restart/NUI reload.
- Hunger, thirst and custom stamina use `exports.sg_status:getStatus()`. Health/armor use GTA natives. Status percentages are normalized for Trew's existing renderer.
- PMA Voice remains responsible for voice distance. Both its normal keybind and this HUD's configured range key update the same indicator. This HUD never changes the talker proximity directly.
- Vehicle fuel uses the GTA fuel value maintained by `sg_fuel`; speed (KMH/MPH), gears, lights, sirens, seatbelt/ejection, cruise, indicators, weapons/ammo, location, date and custom status exports retain their original functions.
- Black-money display reads the optional inventory item named by `Config.BlackMoneyItem`; it displays zero when absent. This does not create a second SG currency account.
- Society money reads the native SG Banking ledger for explicitly registered character owners. Boss ranks alone grant no access. With several owned businesses, the HUD shows the current job’s business or the first owned account.

All balance providers are read-only. Indicator relays validate the driver's vehicle and accepted signal states on the server. Remote players outside streaming range are ignored.

## Original default controls

| Function | Default |
| --- | --- |
| Toggle money/job information | `/toggleui` |
| Cycle PMA voice range | `~` (plus PMA's own configured key) |
| Seatbelt | `K` |
| Cruise control, driver only | `Caps Lock` |
| Left/right indicators | Left/right arrows |
| Hazards | Down arrow |

Keys, locale, logo, speed units and visibility switches remain in `config.lua`. The default locale/logo/fonts follow the uploaded resource. Its remote font/icon/style/script/logo dependencies still require network access. The original K binding overlaps the inventory's configured secondary key; change either config if needed.

Custom indicators keep the original exports under the new resource name:

```lua
exports.sg_hud:createStatus({status='stress',color='#ff0000',icon='fas fa-brain'})
exports.sg_hud:setStatus({name='stress',value=25})
```

Mocked tests verify payloads, job/money/status updates, voice-mode mapping, lifecycle visibility, server balance permissions and signal validation. Manifest checks and UI-file comparisons cover packaging and visual asset preservation. Live FiveM driving, sounds, visual layout and multiplayer playtesting still need verification on the server.
