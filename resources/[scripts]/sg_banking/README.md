### Dependencies:

* [**ND Core**](https://github.com/ND-Framework/ND_Core/releases)

* [**ox_lib**](https://github.com/overextended/ox_lib/releases)

### Need Support?
[![Discord](https://discordapp.com/api/guilds/857672921912836116/widget.png?style=banner3)](https://discord.gg/Z9Mxu72zZ6)

# Preview

**ATM:**

![image](https://user-images.githubusercontent.com/86536434/215471458-c065a3a3-b7cc-4913-ad5a-26ce10dee16e.png)

**Bank - home:**

![image](https://user-images.githubusercontent.com/86536434/215471727-9a2a801a-72ca-4d9c-a690-f4b4ad11df8b.png)

**Bank - invoices:**

![image](https://user-images.githubusercontent.com/86536434/215471844-6ff6db72-97f3-4ec0-9103-f65777f657b9.png)

**Bank - transfer:**

![image](https://user-images.githubusercontent.com/86536434/215471971-49b36967-c29e-45b9-aa05-53f50f85f317.png)

## Native society banking

Business accounts persist in `sg_banking_societies`, with character ownership in
`sg_banking_society_owners` and an append-only transaction history table.
Import the updated `database/SG_Framework.sql`, or let sg_banking create its missing
society tables on startup. Existing personal accounts are unchanged.

Assign owners from the **server console** (use the SG character ID, not the temporary player/server ID):

```
societyowner add mechanic 12 Benny's Workshop
societyowner remove mechanic 12
```

Adding the first owner creates the account at $0. Several owners can be assigned.
Removing an owner preserves business funds and history. Boss ranks and employee
jobs do not grant ownership. Only registered owners can list accounts, review the
latest 50 transactions, or deposit/withdraw. Each request checks ownership on the
server; ownership revocation takes effect on the next request.

Owners use `/societybank` to review their accounts and transfer funds between their
personal bank balance and the selected business. SG HUD shows an owned account,
preferring one matching the owner's current job name. It hides the society balance
when the character owns no account. No job or boss status is required for ownership.

Server-only integration API:

```lua
exports.sg_banking:getOwnedSocieties(source) -- only that character's accounts
exports.sg_banking:isSocietyOwner(source, 'mechanic')
exports.sg_banking:getSocietyBalance(source, 'mechanic') -- nil unless owner
exports.sg_banking:addSocietyMoney('mechanic', 100, 'Repair payment')
exports.sg_banking:removeSocietyMoney('mechanic', 100, 'Parts purchase')
```

Financial write exports are disabled for callers by default. Enable specific trusted
server resources in `config.societyResources`; never proxy these exports through
unchecked client events. These exports support automated business income/expenses;
player-facing access remains owner-only. They do not create accounts automatically.

Amounts must be positive whole dollars (maximum $1 billion per transfer). Society
debits reject insufficient funds. Balance changes and ledger entries share a SQL
transaction. Player transfers are serialized per source, failed deposits are refunded,
and the personal bank is saved after success. SG personal balances remain in memory:
a process crash between the society commit and personal save is not an atomic
cross-account transfer and requires ledger reconciliation. Live FiveM/database
integration testing is still required before using this development branch in production.
