# Required live validation

Use an isolated server/database first. A passing Python check is not a successful FiveM playtest.

1. Boot with `server.cfg`. Confirm database, core, aliases, inventory and each default resource start without errors. Run `sgdoctor`; inspect the server and F8 logs. Repeat with the core tables already existing.
2. Connect two players. Create characters with different identities; save appearance, relog and reconnect. Verify nobody can choose/delete another account's character or exceed their slot limit. Confirm the UI closes and the world becomes visible after each operation.
3. Give both players known cash/bank values. Deposit, withdraw, transfer and pay invoices. Verify invalid/negative/fractional values and overdrafts fail without changing balances. Repeat through a known ESX and QB integration; check the balances match native SG. Test concurrent transfers/invoices before approving economy use.
4. Move/drop/give physical money through inventory. Confirm the native account and inventory count stay equal; groups remain tables and the native account identifier remains the license. Reconnect and restart to verify persistence.
5. Set police/ambulance jobs and ranks. Verify identical grade mapping, target access, doors, off-duty behavior, MDT search, dispatch, cuff/escort and treatment/revive. Check job changes and relogs revoke access.
6. Buy a vehicle at the SG dealership. Test drive, ownership, keys, locks, storage, trunk/glovebox, impound, transfer, relog and server restart. Confirm inventory ownership does not use another character's data.
7. Exercise clothing shops, fuel, status/consumables, casino games and nitro. Verify server-side payments/rewards, cleanup and UI focus. Investigate inherited event validation issues before exposing them to the public.
8. Enable an optional add-on only after its `INTEGRATION.md` row is resolved. Validate its complete workflow and persistence and check for duplicate markers/menus/commands with the default set.
9. Perform a full server-event permission/rate-limit/amount audit and load test. Record tested FXServer/MySQL versions, resources enabled, test outcomes and error logs before describing the stack as production-ready.
