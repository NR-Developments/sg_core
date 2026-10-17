"""Integration test for a disposable *_test database; run by CI against MySQL/MariaDB."""
import os,shutil,subprocess
from pathlib import Path
from build_database import ROOT,build

def main():
    db=os.environ.get('SG_DATABASE_TEST_NAME','sg_schema_test')
    if not db.endswith('_test') or os.environ.get('SG_DATABASE_TEST_ALLOW_WRITE')!='1':
        raise SystemExit('Use a disposable *_test database and set SG_DATABASE_TEST_ALLOW_WRITE=1')
    cli=shutil.which('mysql') or shutil.which('mariadb')
    if not cli:raise SystemExit('MySQL/MariaDB client is required')
    command=[cli,'--host='+os.environ.get('SG_DATABASE_TEST_HOST','127.0.0.1'),
        '--port='+os.environ.get('SG_DATABASE_TEST_PORT','3306'),
        '--user='+os.environ.get('SG_DATABASE_TEST_USER','root'),'--database='+db,'--batch','--skip-column-names']
    def run(sql,valid=True):
        result=subprocess.run(command,input=sql,text=True,capture_output=True)
        if valid and result.returncode:raise AssertionError(result.stderr)
        if not valid and not result.returncode:raise AssertionError('Database accepted an invalid foreign-key owner')
        return result.stdout.strip()
    sql,tables=build()
    assert (ROOT/'database/SG_Framework.sql').read_text()==sql,'Consolidated schema is stale'
    run(sql)
    assert set(run('SHOW TABLES;').splitlines())==tables,'Missing or unexpected tables in fresh test database'
    run("INSERT INTO nd_characters (charid,identifier,firstname,lastname,bank) VALUES (2147483000,'sg_schema_test','Schema','Test',12345);")
    run("INSERT INTO nd_vehicles (owner,plate) VALUES (2147483000,'SGSQLTEST');")
    run("INSERT INTO nd_banking_accounts (owner,account_number) VALUES (2147483000,'SGSQLTEST');")
    run(sql)
    assert run('SELECT bank FROM nd_characters WHERE charid=2147483000;')=='12345','Re-import changed character data'
    assert run("SELECT COUNT(*) FROM nd_vehicles WHERE plate='SGSQLTEST';")=='1','Re-import changed vehicle data'
    run("INSERT INTO nd_vehicles (owner,plate) VALUES (2147483001,'INVALID');",valid=False)
    run('DELETE FROM nd_characters WHERE charid=2147483000;')
    assert run("SELECT COUNT(*) FROM nd_vehicles WHERE plate='SGSQLTEST';")=='0','Vehicle FK cascade failed'
    assert run("SELECT COUNT(*) FROM nd_banking_accounts WHERE account_number='SGSQLTEST';")=='0','Account FK cascade failed'
    print(f'PASS: {len(tables)} tables, two imports, preserved data and foreign-key enforcement/cascades')
if __name__=='__main__':main()
