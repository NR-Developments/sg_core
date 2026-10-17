"""Structural Lua 5.4 checks, normalizing Cfx hash literals, optional access, and compound assignment.
This is not an FXServer runtime test; diagnostics retain original source line numbers.
"""
import ctypes, ctypes.util, re, sys
from pathlib import Path
lib=ctypes.CDLL(ctypes.util.find_library('lua5.4'))
lib.luaL_newstate.restype=ctypes.c_void_p
lib.luaL_loadbufferx.argtypes=[ctypes.c_void_p,ctypes.c_char_p,ctypes.c_size_t,ctypes.c_char_p,ctypes.c_char_p]
lib.lua_tolstring.argtypes=[ctypes.c_void_p,ctypes.c_int,ctypes.c_void_p];lib.lua_tolstring.restype=ctypes.c_char_p
lib.lua_close.argtypes=[ctypes.c_void_p]
def normalize(text):
    text=re.sub(r'`[^`\n]*`','0',text)
    text=text.replace('?.','.').replace('?[','[')
    pattern=r'(\b[A-Za-z_]\w*(?:(?:\.[A-Za-z_]\w*)|(?:\[[^\]\n]+\]))*)\s*(\+|-|\*|/|\.\.)=\s*'
    text=re.sub(pattern,lambda m:f'{m[1]} = {m[1]} {m[2]} ',text)
    return text

def check(path):
    source=normalize(path.read_text(errors='replace')).encode();state=lib.luaL_newstate()
    status=lib.luaL_loadbufferx(state,source,len(source),str(path).encode(),None)
    error=lib.lua_tolstring(state,-1,None).decode() if status else None
    lib.lua_close(state);return error
if __name__=='__main__':
    paths=[Path(p) for p in sys.argv[1:]] or list(Path('resources').rglob('*.lua'))
    errors=[(p,err) for p in paths if (err:=check(p))]
    for p,err in errors:print(err)
    print(f'{len(paths)} Lua files checked; {len(errors)} structural errors')
    sys.exit(bool(errors))
