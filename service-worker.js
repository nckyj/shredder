const CACHE = 'shredder-v1';
const SHELL = ['./index.html', './manifest.json', './icon-192.png', './icon-512.png'];

self.addEventListener('install', e=>{
  self.skipWaiting();
  e.waitUntil(caches.open(CACHE).then(c=>c.addAll(SHELL)));
});

self.addEventListener('activate', e=>{
  e.waitUntil(
    caches.keys().then(keys=>Promise.all(keys.filter(k=>k!==CACHE).map(k=>caches.delete(k))))
  );
  self.clients.claim();
});

// Network-first for the app shell HTML (so you always get the latest logic),
// falling back to cache when offline. Cache-first for static assets (icons, manifest).
self.addEventListener('fetch', e=>{
  const url = new URL(e.request.url);
  if(url.origin !== self.location.origin){
    return; // let Supabase / API calls go straight to network, untouched
  }
  if(e.request.mode === 'navigate' || url.pathname.endsWith('.html')){
    e.respondWith(
      fetch(e.request).then(res=>{
        caches.open(CACHE).then(c=>c.put(e.request, res.clone()));
        return res;
      }).catch(()=> caches.match(e.request))
    );
    return;
  }
  e.respondWith(
    caches.match(e.request).then(cached=> cached || fetch(e.request))
  );
});
