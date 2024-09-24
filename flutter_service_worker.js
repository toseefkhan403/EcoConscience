'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.json": "e6a87855e16ff0fea332b1204796831f",
"assets/assets/google_fonts/VT323-Regular.ttf": "034de38c65e202c1cc838e7d014385fd",
"assets/assets/images/Interiors/5_Classroom_and_library_32x32.png": "faad1ccfeeec1c53af4f39302ad19f62",
"assets/assets/images/Interiors/thinking_32x64.png": "8e8247f63d3bb1a360a2cda8edfe76da",
"assets/assets/images/Interiors/13_Conference_Hall_32x32.png": "abfe57d48f8896df91492c8c9b2eb1ff",
"assets/assets/images/Interiors/mail_32x64.png": "180b7396ce172cc32eb8c33857edda57",
"assets/assets/images/Interiors/3_2Bathroom_32x32.png.png": "76c16d7c2378eee1ca335e7a68111c1b",
"assets/assets/images/Interiors/4_1Bedroom_32x32.png": "e964b503e7015d733d888573296c6505",
"assets/assets/images/Interiors/arrow_down_32x32.png": "cd46633a211778a7af24773e95d21455",
"assets/assets/images/Interiors/1_Room_Builder_borders_32x32.png": "11c230aec99eed06b4afc0ada61e5814",
"assets/assets/images/Interiors/Room_Builder_Floors_32x32.png": "9176bacacb33d02b697542274490d585",
"assets/assets/images/Interiors/fancy_mat.png": "03164c2ae1892d4620793c5b84a8688c",
"assets/assets/images/Interiors/Room_Builder_Walls_32x32.png": "7c37a5b343de4cd3e380392917e658cf",
"assets/assets/images/Interiors/2_LivingRoom_32x32.png": "b93806d1cf5a3c329f35a97d3161b290",
"assets/assets/images/Interiors/exclamation_32x32.png": "f56ba1d1c4f902ca45165152fed6a764",
"assets/assets/images/Interiors/3_1Bathroom_32x32.png.png": "00aec5182773a3a1093670e96ea29dcb",
"assets/assets/images/HUD/arrow_l.png": "d161ebba55ffcd3381b47eb4f79fcf84",
"assets/assets/images/HUD/arrow_l_pressed.png": "8f069cf16a138b45c5183ebc64777fe0",
"assets/assets/images/HUD/settings_button_pressed.png": "85b89a4a0c546d6ce0e418edd557b6d8",
"assets/assets/images/HUD/play_button.png": "d655c18341adde15cde6c75d9f68043f",
"assets/assets/images/HUD/keyboard_r.png": "2230a865fbd7b9416c11ef22707dfb44",
"assets/assets/images/HUD/keyboard_u.png": "963ef98c1b5efb88eb58de2f1ebfd2a0",
"assets/assets/images/HUD/keyboard_d.png": "2a995655bc910673f3650b97cc64075b",
"assets/assets/images/HUD/settings_button.png": "fc68ff4748b5a95cd74e0b5f489ac488",
"assets/assets/images/HUD/keyboard_d_pressed.png": "00b858a8e27a37647c04c39072c2b1f5",
"assets/assets/images/HUD/keyboard_r_pressed.png": "05f6fbe9ad3097a49bcecb6ba70e5978",
"assets/assets/images/HUD/arrow_r.png": "190d26d3ee6d171dfc0eb6afabf65672",
"assets/assets/images/HUD/keyboard_l_pressed.png": "16469485a88379a64dd5f1c69ce1c7a7",
"assets/assets/images/HUD/arrow_r_pressed.png": "265ac0fb3c6ba010417996c6e878bc08",
"assets/assets/images/HUD/keyboard_u_pressed.png": "d1b48ebc96de52c764f71ddbe80e51be",
"assets/assets/images/HUD/play_button_pressed.png": "424aa246d233ca63a8c3e1614ecf2023",
"assets/assets/images/HUD/keyboard_l.png": "e37073bc4bd403419c36983883ff20ab",
"assets/assets/images/HUD/Earth.png": "7df9bc235ac7ae0d5d8a139bcb725843",
"assets/assets/images/Characters/Alex_run_16x16.png": "db63d9bab7d75250ba842277d501fb91",
"assets/assets/images/Characters/Alex_idle_anim_16x16.png": "030b53d6f71394d3fb1d63ef39191db1",
"assets/assets/images/Characters/Bob_run_16x16.png": "b04767ddc1c973ce907d57e4cc25510d",
"assets/assets/images/Characters/Bob_idle_anim_16x16.png": "a02e48940c323d29dd6a47df40e5414e",
"assets/assets/images/Characters/Adam_idle_anim_16x16.png": "6338300b0ae022cbac0797c62cb25303",
"assets/assets/images/Characters/marcus.png": "22f1e62fabaa4fecc1634668a6a237bb",
"assets/assets/images/Characters/julie.png": "aeba4f7574cbca21d3d7eaa493a20d80",
"assets/assets/images/Characters/Adam_run_16x16.png": "04d9257b4abd487f04d45fb30059c8ac",
"assets/assets/images/Characters/security_guard.png": "752fafa16d6e3ab4400760824fa0d20a",
"assets/assets/images/Characters/tomas.png": "d76ef1033e5debcc487d867ab84607c2",
"assets/assets/images/Characters/jack.png": "e93dda521aed5a234e1e8261b7e25263",
"assets/assets/images/Characters/Amelia_run_16x16.png": "69215d9cee3f3e0c141744840c78ce3f",
"assets/assets/images/Characters/Amelia_idle_anim_16x16.png": "e964da819bf9ac05f3678ad1265436f8",
"assets/assets/images/Characters/julie_reading.png": "92f0eb5e724c59e9bfd86de636002eb0",
"assets/assets/images/Characters/demon_dialog.png": "f5d1806f8382e99189a970300a494445",
"assets/assets/images/Characters/angel_dialog.png": "421fa938862bc314f1173f7a9c5f3449",
"assets/assets/images/Exteriors/3_1City_Props_32x32.png": "371430d10f1c5c052a77bcb3bfa841a1",
"assets/assets/images/Exteriors/busStand.png": "4a9dc4d3dbc425b1d03fed999060bbeb",
"assets/assets/images/Exteriors/5_5Floor_Modular_Buildings_32x32.png": "5427d3a9e5e7d79ad8d924f5ec87575e",
"assets/assets/images/Exteriors/vehicles.png": "358e4292d950d169f32a45f3635fa8ee",
"assets/assets/images/Exteriors/5_1Floor_Modular_Buildings_32x32.png": "85757ac895bd8d3fd40d32bf95b8ce85",
"assets/assets/images/Exteriors/garbage_dump.png": "e972b7188c5f0f2c55cb5d262c452837",
"assets/assets/images/Exteriors/5_Floor_Modular_Buildings_32x32.png": "bd74ca2bea19af0dc895a13b169058a7",
"assets/assets/images/Exteriors/5_2Floor_Modular_Buildings_32x32.png": "e54f45dd0b32efd0e9f992c56690c770",
"assets/assets/images/Exteriors/garbage_sprinkle.png": "7580d6b867827e7e038950a6b212723f",
"assets/assets/images/Exteriors/5_3Floor_Modular_Buildings_32x32.png": "9f04059bf8ba1fe0c4e0ea6e9023ca11",
"assets/assets/images/Exteriors/garbage_bags.png": "17c57d297eb209529cb15bce8cb61549",
"assets/assets/images/Exteriors/tacoTruck.png": "51f00031c3e486987494b995cec81c41",
"assets/assets/images/Exteriors/1_2Terrains_and_Fences_32x32.png.png": "d70e053ffb9fe76c7fba388a76465217",
"assets/assets/images/Exteriors/4_1Generic_Buildings_32x32.png": "99f0f1e1bd92e39c696b2a155ba1b45b",
"assets/assets/images/Exteriors/5_6Floor_Modular_Buildings_32x32.png": "ac60998a1e4313b95ac8de42d2a1fd91",
"assets/assets/images/Exteriors/16_1Office_32x32.png": "a83aa25426a0af4509e45c8fab5fede6",
"assets/assets/images/Exteriors/skyline/4.png": "6358c0f4d6e94c29e67fac538c0eecb5",
"assets/assets/images/Exteriors/skyline/longEvening.png": "dbc27acc46428bdcb4a5d43bfe7e54a9",
"assets/assets/images/Exteriors/skyline/cloudsOverlay.png": "ba675381dbddacebe86137fdcfc0fca5",
"assets/assets/images/Exteriors/skyline/6.png": "8cb49e4950522e111ea2bf41af5e8350",
"assets/assets/images/Exteriors/skyline/longBg.png": "c02a3ef6e9deff04c3cbd419c770369d",
"assets/assets/images/Exteriors/skyline/3.png": "f0a0e01f7748b18121309a66719289a7",
"assets/assets/images/Exteriors/skyline/1.png": "ec5594a2f55c11ecdd0054c1bb9d31a7",
"assets/assets/images/Exteriors/skyline/5.png": "a5f4fff3325cc0104169859d7cfbb031",
"assets/assets/images/Exteriors/skyline/longCloudsOverlay.png": "44b8621cad789864977a6e078baa060e",
"assets/assets/images/Exteriors/skyline/2.png": "a5c90e3a0198c72770d1cbce968777ad",
"assets/assets/images/Exteriors/2_1City_Terrains_32x32.png": "4c1fd083e59a491fdb3ee9ca777a9c39",
"assets/assets/images/Lessons/busToOfficeArc.png": "476f5659212f81d57b4a33e3a2b32964",
"assets/assets/images/Lessons/houseLightsArc.png": "a385a705f3804f623b70e0e24ed48677",
"assets/assets/images/Lessons/officePlantationArc.png": "f8864e97ebdbda83848c6e9c88743df9",
"assets/assets/images/Lessons/bathroomArc.png": "9bdbbc3957c4c955776ac1bfb9fbbedf",
"assets/assets/images/Lessons/tacoArc.png": "3bb3ad195c095b6e4d28f286893046ec",
"assets/assets/images/Lessons/introArc.png": "ebdeac6cb5c5e658f02a51d475177ee4",
"assets/assets/tiles/office.tmx": "64afbdadae65c3a656935aa5fd7be6ac",
"assets/assets/tiles/Eco%2520Conscience.tiled-project": "97165873765b29a5041f09e541be15d5",
"assets/assets/tiles/tileSets/3_1City_Props_32x32.tsx": "8ea2aad067c3ac24a1ed804b51b4a62f",
"assets/assets/tiles/tileSets/5_5Floor_Modular_Buildings_32x32.tsx": "559515380ab4d25d3158f068bdc959f7",
"assets/assets/tiles/tileSets/5_1Floor_Modular_Buildings_32x32.tsx": "f4ca31e50981a1641337f77ec9851b39",
"assets/assets/tiles/tileSets/vehicles.tsx": "bd78f703b51ff88747a32f4962d62ec0",
"assets/assets/tiles/tileSets/5_3Floor_Modular_Buildings_32x32.tsx": "b0058619f2bc87fabcd6e047de3224f2",
"assets/assets/tiles/tileSets/13_Conference_Hall_32x32.tsx": "c2bdc985b664d9cdace1f96b1f8233ef",
"assets/assets/tiles/tileSets/1_Room_Builder_borders_32x32.tsx": "2ddd50102764d64fe4d69c2a0e2a10b3",
"assets/assets/tiles/tileSets/4_1Generic_Buildings_32x32.tsx": "2ef4a55c615f91ad4d9617fc9b06412f",
"assets/assets/tiles/tileSets/tacoTruck.tsx": "f49a82faf581af0e7a1b16ab2c8ec125",
"assets/assets/tiles/tileSets/Room_Builder_Walls_32x32.tsx": "9f4c31050ff4a5a201d06f40b93c2f39",
"assets/assets/tiles/tileSets/5_Classroom_and_library_32x32.tsx": "e8faf8261a33b8ba06a495e170d27e55",
"assets/assets/tiles/tileSets/5_Floor_Modular_Buildings_32x32.tsx": "d20bb47fadbe9e66d82ca243572a8054",
"assets/assets/tiles/tileSets/Room_Builder_Floors_32x32.tsx": "546eb1aa6f85013ab3c82f393fc5c610",
"assets/assets/tiles/tileSets/1_2Terrains_and_Fences_32x32.png.tsx": "0fd952c7d0811a3c21a4c66c71bbdbd9",
"assets/assets/tiles/tileSets/4_1Bedroom_32x32.tsx": "aef078be838d7c7c57ae5ec9bde8565e",
"assets/assets/tiles/tileSets/5_2Floor_Modular_Buildings_32x32.tsx": "13d90b79a4f6564a87da5e08c15c9737",
"assets/assets/tiles/tileSets/3_2Bathroom_32x32.png.tsx": "62ce0e1e1c581b0200696f93e1ae2cd9",
"assets/assets/tiles/tileSets/busStand.tsx": "f71ea41e7997475c6761eccead6357a3",
"assets/assets/tiles/tileSets/3_1Bathroom_32x32.png.tsx": "36e71d064c97813d6030fc92318345f2",
"assets/assets/tiles/tileSets/2_LivingRoom_32x32.tsx": "769da058bbea3f086ccce285caef584e",
"assets/assets/tiles/tileSets/2_1City_Terrains_32x32.tsx": "2924026b31ef580af2e9cb4ceed1ba23",
"assets/assets/tiles/tileSets/16_1Office_32x32.tsx": "713ba4cd3cd9ea1aa4fda1df7935822b",
"assets/assets/tiles/tileSets/fancy_mat.tsx": "0e8788de09ebf5a7342e42f48d82709d",
"assets/assets/tiles/tileSets/5_6Floor_Modular_Buildings_32x32.tsx": "6dcf6abdf5ae76440913a848853e644f",
"assets/assets/tiles/outdoors.tmx": "b19c43cb84fb7bb8fe6b8441a7c05559",
"assets/assets/tiles/bathroom.tmx": "2cd35246548f3eca2048e7a02a62eed4",
"assets/assets/tiles/Eco%2520Conscience.tiled-session": "17f51be8d60212a8ddf2f7be708e86e5",
"assets/assets/tiles/outdoorsTaco.tmx": "5f824e98eb7abbede2a28883322325bc",
"assets/assets/tiles/home.tmx": "a9f0162f459e528d2638e756bc1b5279",
"assets/assets/tiles/outdoorsOffice.tmx": "bc89796cc4aecca130c1de87e214824a",
"assets/assets/tiles/outdoorsBus.tmx": "8db40d5d022c56e171fd3f095cfcfe75",
"assets/assets/tiles/startingSequence.tmx": "729d141d363319e17c90829389916e48",
"assets/assets/google_buttons/en_wallet_button_condensed.svg": "b7de62572ebbd02edb55b97fea662cda",
"assets/assets/google_buttons/ja_wallet_button_condensed.svg": "03896b8a5dad9a42adb1bb6a7b428bd4",
"assets/assets/audio/typing.mp3": "aaeeb8e26f25deedf96a74bf8f5e3788",
"assets/assets/audio/Three-Red-Hearts-Princess-Quest.mp3": "7792057b4e31e2bc7af80ffe1ab78947",
"assets/assets/audio/click.wav": "2de245cf63eb94409bd5d71a82b87807",
"assets/assets/audio/typing_devil.mp3": "c9edfd07d43ba3efec73f0c1e277d3ca",
"assets/assets/audio/teleport.wav": "2ffeffd9c4c8d38174ceb30ca9564159",
"assets/assets/audio/Three-Red-Hearts-Penguin-Town.mp3": "51f755705e5ce9426c1f032422ee196c",
"assets/assets/audio/Three-Red-Hearts-Save-the-City.mp3": "b3cfdbd894a0365b4c0eec7ce3e610a6",
"assets/assets/fonts/04B_30__.TTF": "f03febe581b686cbac1e6d5cb7677df3",
"assets/assets/fonts/8-bit%2520Arcade%2520Out.ttf": "11fb9e29eadedb0222926532c53702b5",
"assets/assets/fonts/jackeyfont.ttf": "bb4acd434607b4a15207b7c02ecc75b6",
"assets/assets/fonts/8-bit%2520Arcade%2520In.ttf": "c817b12ca64d82575cc6fa0f759ac24b",
"assets/AssetManifest.bin.json": "36d0f6102bf18c2352d298bd629f5af6",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "f3c236e0a2e65a6f5ebea48e52439c81",
"assets/FontManifest.json": "77f9dc471584ef4790165e9f9e40a3d5",
"assets/NOTICES": "669b6b1dd7719a82ff98630c554d1d76",
"assets/fonts/MaterialIcons-Regular.otf": "0db35ae7a415370b89e807027510caf0",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"canvaskit/canvaskit.js.symbols": "74a84c23f5ada42fe063514c587968c6",
"canvaskit/skwasm.worker.js": "bfb704a6c714a75da9ef320991e88b03",
"canvaskit/canvaskit.js": "738255d00768497e86aa4ca510cce1e1",
"canvaskit/skwasm.wasm": "4051bfc27ba29bf420d17aa0c3a98bce",
"canvaskit/canvaskit.wasm": "9251bb81ae8464c4df3b072f84aa969b",
"canvaskit/skwasm.js": "5d4f9263ec93efeb022bb14a3881d240",
"canvaskit/chromium/canvaskit.js.symbols": "ee7e331f7f5bbf5ec937737542112372",
"canvaskit/chromium/canvaskit.js": "901bb9e28fac643b7da75ecfd3339f3f",
"canvaskit/chromium/canvaskit.wasm": "399e2344480862e2dfa26f12fa5891d7",
"canvaskit/skwasm.js.symbols": "c3c05bd50bdf59da8626bbe446ce65a3",
"main.dart.js": "bac3830f964d7cba0be20b1e7b5b12a3",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"flutter_bootstrap.js": "254157bdf16302089a348bf2e0dfb816",
"flutter.js": "383e55f7f3cce5be08fcf1f3881f585c",
"index.html": "4298a38dfa2e245ab42d8a58bc245ddc",
"/": "4298a38dfa2e245ab42d8a58bc245ddc",
"favicon.ico": "55fd0b270b8e04d4f3b4eb9229e7c2fa",
"version.json": "2411f1c560a3cce941f9ddea98f3418b",
"manifest.json": "0ca51517d3ee2ea460800bd0605f92df"};
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
