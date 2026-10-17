// Readiness handshake only; the original app, styling and graphics are unchanged.
window.addEventListener('load', () => {
    fetch(`https://${GetParentResourceName()}/ready`, {
        method: 'POST', headers: {'Content-Type': 'application/json'}, body: '{}'
    }).catch(() => {});
});
