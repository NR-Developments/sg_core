// Exercise the shipped NUI handlers with a minimal DOM and actual callback transport code.
const fs = require('node:fs');
const vm = require('node:vm');
const assert = require('node:assert/strict');
function ui(file, name) {
    const elements = new Map(), requests = [], listeners = {};
    const element = id => {
        if (!elements.has(id)) elements.set(id, {
            style: {}, innerHTML: '', offsetWidth: 300, reset() {},
            appendChild() {}, setAttribute() {}, removeAttribute() {}, insertBefore() {}, addEventListener() {},
            insertAdjacentHTML(where, value) { this.innerHTML += value; }
        });
        return elements.get(id);
    };
    let fields = {};
    class XHR {
        open(method, url) { this.url = url; }
        setRequestHeader() {}
        send(body) { requests.push({url: this.url, data: JSON.parse(body)}); }
    }
    const context = vm.createContext({
        console, XMLHttpRequest: XHR, GetParentResourceName: () => name,
        document: {getElementById: element, createElement: element, createTextNode: text => text,
            querySelector: element, querySelectorAll: () => []},
        window: {addEventListener: (event, fn) => { listeners[event] = fn; }},
        FormData: class { [Symbol.iterator]() { return Object.entries(fields)[Symbol.iterator](); } },
        setTimeout() {}, Date
    });
    vm.runInContext(fs.readFileSync(file, 'utf8'), context, {filename: file});
    return {context, elements, requests, message: data => listeners.message({data}), fields: data => { fields = data; }};
}
const screen = ui('resources/[scripts]/sg_multicharacter/web/script.js', 'sg_multicharacter');
screen.message({data: {characters: {}, slots: 1}});
assert.match(screen.elements.get('characters').innerHTML, /showchar\('1'\)/);
screen.context.showchar('1');
assert.equal(screen.requests.at(-1).url, 'https://sg_multicharacter/nuicb');
assert.equal(screen.requests.at(-1).data.slot, 1);
screen.message({showcharacter: {showoptions: 'new', slot: 1, customregister: false}});
assert.equal(screen.elements.get('register').style.display, 'flex');
screen.message({data: {characters: [{name: 'First Character'}], slots: 2}});
screen.message({showcharacter: {showoptions: 'existing', slot: 1}});
assert.match(screen.elements.get('infos').innerHTML, /First Character/);
screen.message({data: {characters: {2: {name: 'Second Character'}}, slots: 2}});
screen.message({showcharacter: {showoptions: 'existing', slot: 2}});
assert.match(screen.elements.get('infos').innerHTML, /Second Character/);
screen.fields({firstname: 'Josh', lastname: 'Test', sex: 'm', dateofbirth: '1990-01-01', nationality: 'United States', freeform: ''});
screen.context.register();
assert.equal(screen.requests.at(-1).data.msg, 'create');
assert.equal(screen.requests.at(-1).data.slot, 2);
assert.equal(screen.requests.at(-1).data.info.nationality, 'United States');
screen.message({registrationError: true});
assert.equal(screen.elements.get('body').style.display, 'block');
assert.equal(screen.elements.get('register').style.display, 'flex');
const spawn = ui('resources/[scripts]/sg_spawn/web/script.js', 'sg_spawn');
spawn.context.preview('airport');
assert.equal(spawn.requests.at(-1).url, 'https://sg_spawn/nuicb');
spawn.context.spawn('airport');
assert.equal(spawn.requests.at(-1).data.msg, 'spawn');
console.log('PASS: empty-slot registration, contiguous/sparse slot identity, form submission/recovery and SG NUI origins');
