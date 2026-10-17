"""Inspect manifest-declared runtime files, imports, dependency ordering and collisions."""
import ctypes,json,re,sys
from pathlib import Path
from check_lua import lib,check
lib.luaL_openlibs.argtypes=[ctypes.c_void_p]
lib.lua_pcallk.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_int,ctypes.c_int,ctypes.c_longlong,ctypes.c_void_p]
ROOT=Path(__file__).resolve().parents[1]
def manifest(path):
    text=path.read_text(errors='replace')
    body='''local entries={}
local function capture(key,value)
    if type(value)=='table' then for _,v in ipairs(value) do if type(v)=='string' then entries[#entries+1]=key..'\\t'..v end end
    elseif type(value)=='string' then entries[#entries+1]=key..'\\t'..value end
    return function() end
end
local env=setmetatable({}, {__index=function(_,key) return function(value) return capture(key,value) end end})
assert(load([====[PAYLOAD]====], 'manifest', 't', env))()
return table.concat(entries,'\\n')'''.replace('PAYLOAD',text)
    encoded=body.encode();s=lib.luaL_newstate();lib.luaL_openlibs(s)
    status=lib.luaL_loadbufferx(s,encoded,len(encoded),b'manifest-audit',None)
    if not status: status=lib.lua_pcallk(s,0,1,0,0,None)
    out=lib.lua_tolstring(s,-1,None).decode();lib.lua_close(s)
    if status:raise RuntimeError(str(path)+': '+out)
    fields={}
    for line in out.splitlines():
        k,v=line.split('\t',1);fields.setdefault(k,[]).append(v)
    return fields

def audit():
    manifests=list((ROOT/'resources').rglob('fxmanifest.lua'))+list((ROOT/'resources').rglob('__resource.lua'))
    resources={};duplicates=[]
    for p in manifests:
        if p.parent.name in resources:duplicates.append(p.parent.name)
        resources[p.parent.name]=(p,manifest(p))
    startup=[]
    for line in (ROOT/'resources.cfg').read_text().splitlines():
        m=re.match(r'\s*(?:ensure|start)\s+(\S+)',line)
        if m:startup.append(m[1])
    missing_imports=[];missing_files=[];syntax=[];runtime=set();missing_deps=[];order=[]
    for name,(p,fields) in resources.items():
        for key in ('client_script','client_scripts','server_script','server_scripts','shared_script','shared_scripts','file','files','ui_page'):
            for entry in fields.get(key,[]):
                if entry.startswith('https://') or entry.startswith('http://'):continue
                if entry.startswith('@'):
                    dep,sub=entry[1:].split('/',1)
                    if dep not in resources or not (resources[dep][0].parent/sub).is_file():missing_imports.append({'resource':name,'import':entry})
                    continue
                matches=list(p.parent.glob(entry))
                if not matches:missing_files.append({'resource':name,'entry':entry,'kind':key})
                if key not in ('file','files','ui_page'):
                    runtime.update(x for x in matches if x.suffix=='.lua' and x.is_file())
        for dep in fields.get('dependency',[])+fields.get('dependencies',[]):
            if dep.startswith('/'):continue
            if dep not in resources:missing_deps.append({'resource':name,'dependency':dep})
            elif name in startup and dep in startup and startup.index(dep)>startup.index(name):order.append({'resource':name,'dependency':dep})
    for p in sorted(runtime):
        err=check(p)
        if err:syntax.append({'file':str(p.relative_to(ROOT)),'error':err})
    report={'resources':len(resources),'runtime_lua_files':len(runtime),'duplicates':duplicates,
        'missing_startup_resources':[n for n in startup if n not in resources], 'startup_order_errors':order,
        'missing_imports':missing_imports,'missing_dependencies':missing_deps,'missing_manifest_entries':missing_files,'lua_errors':syntax}
    (ROOT/'docs/resource-audit.json').write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({k:len(v) if isinstance(v,list) else v for k,v in report.items()},indent=2))
    active=set(startup)
    blocking=bool(duplicates or report['missing_startup_resources'] or order or syntax or [x for x in missing_imports+missing_deps if x['resource'] in active] or [x for x in missing_files if x['resource'] in active])
    return int(blocking)
if __name__=='__main__':sys.exit(audit())
