const CACHE_NAME = "photobravo-v4";

const urlsToCache = [
  "/",
  "/index.html",
  "/style.css",
  "/script.js",
  "/manifest.json",

  // BRASÕES (adicione todos que você usa)
  "/assets/brasao_22bpm.png",
  "/assets/brasao_pmesp.png",
  "/assets/forca.png",
  "/assets/1baep.png",
  "/assets/1bpmm.png",
  "/assets/2baep.png",
  "/assets/6bpmi.png",
  "/assets/8bpmi.png",
  "/assets/16bpmi.png",
  "/assets/18bpmi.png",
  "/assets/27bpmm.png",
  "/assets/31bpmi.png",
  "/assets/34bpmi.png",
  "/assets/35bpmi.png",
  "/assets/37bpmm.png",
  "/assets/38bpmm.png",
  "/assets/47bpmi.png",
  "/assets/29bpmi.png",
  "/assets/28bpmm.png"
];

// ===== INSTALAÇÃO =====
self.addEventListener("install", (event) => {
  console.log("Service Worker instalado");

  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(urlsToCache);
    })
  );

  self.skipWaiting();
});

// ===== ATIVAÇÃO =====
self.addEventListener("activate", (event) => {
  console.log("Service Worker ativado");

  event.waitUntil(
    caches.keys().then((keys) => {
      return Promise.all(
        keys.map((key) => {
          if (key !== CACHE_NAME) {
            return caches.delete(key);
          }
        })
      );
    })
  );

  self.clients.claim();
});

// ===== FETCH (ESTRATÉGIA OFFLINE) =====
self.addEventListener("fetch", (event) => {
  event.respondWith(
    caches.match(event.request).then((response) => {

      // Se estiver no cache → usa cache
      if (response) {
        return response;
      }

      // Senão tenta internet
      return fetch(event.request)
        .then((res) => {

          // salva no cache automaticamente
          return caches.open(CACHE_NAME).then((cache) => {
            cache.put(event.request, res.clone());
            return res;
          });

        })
        .catch(() => {

          // fallback offline (opcional)
          if (event.request.destination === "document") {
            return caches.match("/index.html");
          }

        });
    })
  );
});