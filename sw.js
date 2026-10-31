// Минимальный service worker: нужен, чтобы браузер предлагал установку как приложение.
// Ничего не кэширует, поэтому обновления чата применяются сразу.
self.addEventListener("install", () => self.skipWaiting());
self.addEventListener("activate", e => e.waitUntil(self.clients.claim()));
self.addEventListener("fetch", () => {});
