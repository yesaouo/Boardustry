const cacheName = "store-v1.0";
const assets = [
    '/Boardustry/',
    '/Boardustry/index.html',
    '/Boardustry/styles.css',
    '/Boardustry/JavaScript/background.js',
    '/Boardustry/JavaScript/firebase.js',
    '/Boardustry/JavaScript/index.js',
    '/Boardustry/audio/Ancient-Game-Open.mp3',
    '/Boardustry/audio/High-Seas-Adventures.mp3',
    '/Boardustry/img/bg.png',
    '/Boardustry/img/tgdy.png',
    '/Boardustry/img/wifi-slash.png',
    '/Boardustry/img/database/1.png',
    '/Boardustry/img/database/2.png',
    '/Boardustry/img/database/3.png',
    '/Boardustry/img/database/45.png',
    '/Boardustry/img/database/6.png',
    '/Boardustry/img/database/7.png',
    '/Boardustry/img/database/8.png',
    '/Boardustry/img/database/9.png',
    '/Boardustry/img/database/10.png',
    '/Boardustry/img/item/copper.png',
    '/Boardustry/img/item/cryofluid.png',
    '/Boardustry/img/item/lead.png',
    '/Boardustry/img/item/silicon.png',
    '/Boardustry/img/item/titanium.png',
    '/Boardustry/img/item/water.png',
    '/Boardustry/img/unit/atrax.png',
    '/Boardustry/img/unit/coreNucleus.png',
    '/Boardustry/img/unit/cryofluidMixer.png',
    '/Boardustry/img/unit/gamma.png',
    '/Boardustry/img/unit/mace.png',
    '/Boardustry/img/unit/mechanicalDrill.png',
    '/Boardustry/img/unit/pneumaticDrill.png',
    '/Boardustry/img/unit/poly.png',
    '/Boardustry/img/unit/pulsar.png',
    '/Boardustry/img/unit/siliconSmelter.png',
    '/Boardustry/img/rank/chevron (0).png',
    '/Boardustry/img/icon/add.png',
    '/Boardustry/img/icon/arrow.left.png',
    '/Boardustry/img/icon/book.closed.png',
    '/Boardustry/img/icon/book.png',
    '/Boardustry/img/icon/checkmark.fill.png',
    '/Boardustry/img/icon/checkmark.png',
    '/Boardustry/img/icon/diamond.png',
    '/Boardustry/img/icon/dollar.png',
    '/Boardustry/img/icon/donate.png',
    '/Boardustry/img/icon/hammer.png',
    '/Boardustry/img/icon/home.png',
    '/Boardustry/img/icon/icloud.down.fill.png',
    '/Boardustry/img/icon/icloud.down.png',
    '/Boardustry/img/icon/icloud.up.fill.png',
    '/Boardustry/img/icon/icloud.up.png',
    '/Boardustry/img/icon/menu.png',
    '/Boardustry/img/icon/mute.png',
    '/Boardustry/img/icon/play.png',
    '/Boardustry/img/icon/plus.png',
    '/Boardustry/img/icon/portrait.png',
    '/Boardustry/img/icon/search.png',
    '/Boardustry/img/icon/up-down.png',
    '/Boardustry/img/icon/user.png',
    '/Boardustry/img/icon/uturn.png',
    '/Boardustry/img/icon/volume.png',
    '/Boardustry/img/icon/vs.png'
];

self.addEventListener('install', (e) => {
    console.log("installing...");
    e.waitUntil(caches.open(cacheName).then((cache) => cache.addAll(assets)));
});
self.addEventListener("activate", (e) => {
    console.log("ready to handle fetches!");
    e.waitUntil(
        caches.keys().then((keyList) => {
            return Promise.all(
                keyList.map((key) => {
                    if (key !== cacheName) {return caches.delete(key);}
                })
            );
        })
    );
});  
self.addEventListener('fetch', (e) => {
    console.log("fetch", e.request.url);
    e.respondWith(caches.match(e.request).then((response) => response || fetch(e.request)));
});