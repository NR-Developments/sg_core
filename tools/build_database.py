"""Build the importable SG resource-owned schema from the checked-in source definitions."""
from pathlib import Path
import re,sys
ROOT=Path(__file__).resolve().parents[1]
# Foreign-key parents precede children. ESX/QB player/vehicle authorities are deliberately excluded.
SOURCES=[
 ('resources/[scripts]/sg_core/database/characters.sql',None),
 ('resources/[scripts]/sg_core/database/vehicles.sql',None),
 ('resources/[scripts]/sg_banking/database/accounts.sql',None),
 ('resources/[scripts]/sg_banking/database/invoices.sql',None),
 *[(f'resources/[scripts]/sg_mdt/bridge/nd/database/{x}.sql',None) for x in ['bolos','records','reports','weapons']],
 ('resources/[scripts]/ox_inventory/modules/mysql/server.lua',{'ox_inventory'}),
 ('resources/[dependencies]/ox_doorlock/sql/ox_doorlock.sql',None),
 ('resources/[scripts]/sg_phone/ef-phone.sql',{'player_contacts','phone_invoices','phone_messages','player_mails','crypto_transactions','phone_gallery','phone_tweets'}),
 ('resources/[scripts]/sg_customs/customs_mysql8.0below.sql',None),
 ('resources/[scripts]/sg_projectcars/projectcars.sql',{'sg_projectcars','sg_projectcars_items'}),
 ('resources/[scripts]/sg_stancer/server.lua',{'sg_stancer'}),
 ('resources/[scripts]/sg_tuners/server/sql.lua',{'renzu_tuner'}),
 ('resources/[scripts]/sg_motels/server/sql.lua',{'sg_motels'}),
 ('resources/[scripts]/sg_shops/server/db/sql.lua',{'renzu_stores','movableshops','financedata'}),
 ('resources/[scripts]/sg_simpleshop/esx_shops.sql',{'shops1'}),
]
HEADER='''-- SG Framework: full resource-owned database schema
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

'''
def normalize(statement):
    statement=statement.strip().rstrip(';')
    statement=re.sub(r'CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?','CREATE TABLE IF NOT EXISTS ',statement,count=1,flags=re.I)
    statement=re.sub(r"(\b(?:LONGTEXT|MEDIUMTEXT|TEXT|BLOB)\b[^,\n]*?\bDEFAULT\s+)('(?:[^']|'')*')",r'\1(\2)',statement,flags=re.I)
    statement=re.sub(r'DEFAULT\s+unix_timestamp\(\)', 'DEFAULT (unix_timestamp())',statement,flags=re.I)
    if 'CREATE TABLE IF NOT EXISTS `movableshops`' in statement:statement=statement.replace('`identifier` varchar(64)','`identifier` varchar(100)')
    # Sources with table options are normalized so the database default cannot choose a non-FK engine.
    end=statement.rfind(')')
    statement=statement[:end+1]+' ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;'
    return statement

def build():
    sections=[];seen=set()
    for name,allowed in SOURCES:
        source=(ROOT/name).read_text()
        if name.endswith('.lua'):
            definitions=re.findall(r'\[\[\s*(CREATE\s+TABLE\b.*?\))\s*\]\]',source,re.S|re.I)
        else:definitions=re.findall(r'CREATE\s+TABLE\b[^;]+;',source,re.S|re.I)
        selected=set()
        for ddl in definitions:
            table=re.search(r'CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?`?(\w+)',ddl,re.I)[1]
            if allowed is not None and table not in allowed:continue
            if table in seen:raise ValueError('Duplicate table: '+table)
            seen.add(table);selected.add(table)
            sections.append('-- Source: '+name+'\n'+normalize(ddl)+'\n')
        if allowed is not None and selected!=allowed:raise ValueError(f'Missing source definitions in {name}: {allowed-selected}')
    return HEADER+'\n'.join(sections),seen
if __name__=='__main__':
    sql,tables=build();target=ROOT/'database/SG_Framework.sql'
    if '--check' in sys.argv:
        if not target.exists() or target.read_text()!=sql:raise SystemExit('SG_Framework.sql is stale; run python tools/build_database.py')
        print(f'PASS: consolidated schema matches {len(tables)} source table definitions')
    else:
        target.parent.mkdir(exist_ok=True);target.write_text(sql);print(f'Created {target.relative_to(ROOT)}: {len(tables)} tables')
