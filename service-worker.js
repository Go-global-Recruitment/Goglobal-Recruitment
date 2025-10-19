const CACHE_NAME = 'goglobal-cache-v1';
const urlsToCache = [
  '/',
  '/index.html',
  '/about.html',
  '/expertise.html',
  '/contact.html',
  '/application-tracker.html',
  '/thank-you.html',
  '/manifest.json',
  '/cleaned_application_tracker.csv',
  '/icon-192.png',
  '/icon-512.png',
  '/home-background.jpg',
  '/goglobal-logo-header.svg',
  '/robots.txt',
  '/sitemap.xml',
  '/google068621c9101086af.html'
];

self.addEventListener('install', event => {
  event.waitUntil(
    caches.open(CACHE_NAME).then(cache => cache.addAll(urlsToCache))
  );
  self.skipWaiting();
});

self.addEventListener('activate', event => {
  const cacheWhitelist = [CACHE_NAME];
  event.waitUntil(
    caches.keys().then(keyList =>
      Promise.all(keyList.map(key => {
        if (!cacheWhitelist.includes(key)) return caches.delete(key);
      }))
    ).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', event => {
  const req = event.request;
  const url = new URL(req.url);

  // Only handle GET requests; let others pass through (e.g., form posts)
  if (req.method !== 'GET') return;

  // Network-first for CSV so online users see fresh data; fallback to cache offline
  if (url.pathname.endsWith('/cleaned_application_tracker.csv')) {
    event.respondWith(
      fetch(req)
        .then(res => {
          const copy = res.clone();
          caches.open(CACHE_NAME).then(cache => cache.put(req, copy));
          return res;
        })
        .catch(() => caches.match(req))
    );
    return;
  }

  // Cache-first for pages and assets; populate cache if fetched from network; fallback to index.html
  event.respondWith(
    caches.match(req).then(response => {
      if (response) {
        return response;
      }
      return fetch(req)
        .then(res => {
          const copy = res.clone();
          caches.open(CACHE_NAME).then(cache => cache.put(req, copy));
          return res;
        })
        .catch(() => caches.match('/index.html'));
    })
  );
});