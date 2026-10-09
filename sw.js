// Minimaler Service Worker: macht die Website als App installierbar ("Zum Startbildschirm").
// Er speichert nichts zwischen, damit ihr immer die aktuellen Einträge seht.
self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', e => e.waitUntil(self.clients.claim()));
self.addEventListener('fetch', () => {});
