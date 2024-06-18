'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"icons/Icon-maskable-192.png": "fdc23543e92168d6c5e52453d09cb975",
"icons/Icon-maskable-512.png": "6baaef5b4e475df2936ed8358e8f9247",
"icons/Icon-512.png": "6baaef5b4e475df2936ed8358e8f9247",
"icons/Icon-192.png": "fdc23543e92168d6c5e52453d09cb975",
"manifest.json": "d1072c83025093cd3d384146774967aa",
"favicon.png": "7c97213e698398f94ccadb4935881a12",
"flutter_bootstrap.js": "2d5a2bdf926cf4e6a3e11c8546d45dae",
"version.json": "9f83d483769ccb6fdc21e928d217d977",
"index.html": "dfdcfcefdcbedcfc602488d7cd23fbe4",
"/": "dfdcfcefdcbedcfc602488d7cd23fbe4",
"main.dart.js": "2f74d8ceb6141075b1b8ca13b7b5588b",
"assets/AssetManifest.json": "5890256fe0aa6c2271b8d0005413902a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "e986ebe42ef785b27164c36a9abc7818",
"assets/packages/suggest_a_feature/assets/suggestions_declined.svg": "569f457194c134b72eef4cb9a88db9c3",
"assets/packages/suggest_a_feature/assets/arrow_down_icon.svg": "b80d0a00333c3a94784b73baf14ef27f",
"assets/packages/suggest_a_feature/assets/check_icon.svg": "7f805a45e3f6a7337ac00ad507e06adf",
"assets/packages/suggest_a_feature/assets/close_icon.svg": "966a13cef4d007fa0031f4ef7ff48912",
"assets/packages/suggest_a_feature/assets/arrow_left_icon.svg": "94d21835ad2d64282cdcb36060c25d8c",
"assets/packages/suggest_a_feature/assets/plus_icon_thick.svg": "6e71f5850314c887e21b7a69b08290e4",
"assets/packages/suggest_a_feature/assets/add_photo_icon.svg": "4a50c284a3adcf30486cd617fa2cc40d",
"assets/packages/suggest_a_feature/assets/suggestions_duplicated.svg": "06435fa51f47bc27b21643cce7d2f214",
"assets/packages/suggest_a_feature/assets/pen_icon.svg": "3a52d82e0209c466c6a009df52fe464d",
"assets/packages/suggest_a_feature/assets/suggestions_in_progress.svg": "b0fed40d17fe61302022d7522b75094b",
"assets/packages/suggest_a_feature/assets/profile_icon.svg": "3b2d402fe38fa55e0f708a0ff93af8f9",
"assets/packages/suggest_a_feature/assets/download_icon.svg": "2d71cf4bfdc8cf4c5dd9d5acb8c7a92f",
"assets/packages/suggest_a_feature/assets/suggestions_completed.svg": "0762b9ecac63cf855ee291f23764e3c7",
"assets/packages/suggest_a_feature/assets/notifications_icon.svg": "a55b5842c3f0b4b16bc051e77679fd79",
"assets/packages/suggest_a_feature/assets/arrow_up_suggestion.svg": "e178ee191d9b6fa2eaaa52977ec23447",
"assets/packages/suggest_a_feature/assets/suggestions_requests.svg": "10cf8c200f718f906a845bf4b3424303",
"assets/packages/suggest_a_feature/assets/delete_icon.svg": "d3cf6b9329e818a8fb5312f26de395e9",
"assets/packages/suggest_a_feature/assets/plus_icon_thin.svg": "790c5e5ffa9f00bbe9dbbfbfcaec42a5",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "948c450193ba1073b964adad3ef42d5d",
"assets/fonts/MaterialIcons-Regular.otf": "0db35ae7a415370b89e807027510caf0",
"assets/NOTICES": "8316aca013a825aadb2fa08694e24f6f",
"assets/AssetManifest.bin": "591ee23ae0d99b8cfe1c80d54382f622",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
