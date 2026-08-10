/**
 * Service Worker para funcionalidad OFFLINE
 * Sincronización automática cuando hay conexión
 */

const CACHE_NAME = 'salvietti-v1';
const API_CACHE = 'salvietti-api-v1';

const urlsToCache = [
    '/',
    '/css/main.css',
    '/css/theme.css',
    '/js/main.js',
    '/index.html'
];

// Instalación del Service Worker
self.addEventListener('install', event => {
    event.waitUntil(
        caches.open(CACHE_NAME)
            .then(cache => cache.addAll(urlsToCache))
            .then(() => self.skipWaiting())
    );
});

// Activación del Service Worker
self.addEventListener('activate', event => {
    event.waitUntil(
        caches.keys().then(cacheNames => {
            return Promise.all(
                cacheNames.map(cacheName => {
                    if (cacheName !== CACHE_NAME && cacheName !== API_CACHE) {
                        return caches.delete(cacheName);
                    }
                })
            );
        }).then(() => self.clients.claim())
    );
});

// Estrategia de caching: Network first, fallback to cache
self.addEventListener('fetch', event => {
    const { request } = event;
    const url = new URL(request.url);

    // Ignorar requests no-GET
    if (request.method !== 'GET') {
        return;
    }

    // API requests - Network first
    if (url.pathname.startsWith('/api/')) {
        event.respondWith(
            fetch(request)
                .then(response => {
                    if (response.ok) {
                        const clonedResponse = response.clone();
                        caches.open(API_CACHE).then(cache => {
                            cache.put(request, clonedResponse);
                        });
                    }
                    return response;
                })
                .catch(() => {
                    return caches.match(request)
                        .then(cachedResponse => {
                            return cachedResponse || createOfflineResponse();
                        });
                })
        );
    } else {
        // Static assets - Cache first
        event.respondWith(
            caches.match(request)
                .then(response => {
                    return response || fetch(request)
                        .then(fetchResponse => {
                            if (!fetchResponse || fetchResponse.status !== 200 || fetchResponse.type !== 'basic') {
                                return fetchResponse;
                            }

                            const responseToCache = fetchResponse.clone();
                            caches.open(CACHE_NAME)
                                .then(cache => {
                                    cache.put(request, responseToCache);
                                });

                            return fetchResponse;
                        })
                        .catch(() => createOfflineResponse());
                })
        );
    }
});

/**
 * Crear respuesta offline
 */
function createOfflineResponse() {
    return new Response(
        'Modo offline - Datos en caché disponibles',
        {
            status: 503,
            statusText: 'Service Unavailable',
            headers: new Headers({
                'Content-Type': 'text/plain'
            })
        }
    );
}

/**
 * Sincronización en background cuando hay conexión
 */
self.addEventListener('sync', event => {
    if (event.tag === 'sync-movimientos') {
        event.waitUntil(sincronizarMovimientos());
    }
});

async function sincronizarMovimientos() {
    try {
        // Obtener movimientos pendientes de IndexedDB
        const db = await abrirIndexedDB();
        const movimientos = await obtenerMovimientosPendientes(db);

        // Enviar al servidor
        for (const mov of movimientos) {
            await enviarMovimiento(mov);
        }

        // Notificar al usuario
        self.clients.matchAll().then(clients => {
            clients.forEach(client => {
                client.postMessage({
                    type: 'SYNC_COMPLETE',
                    mensaje: 'Datos sincronizados correctamente'
                });
            });
        });
    } catch (error) {
        console.error('Error en sincronización:', error);
    }
}

/**
 * Detectar cambio de conexión
 */
self.addEventListener('online', () => {
    console.log('Conexión establecida');
    registrarSync();
});

self.addEventListener('offline', () => {
    console.log('Sin conexión - Modo offline');
});

function registrarSync() {
    if ('serviceWorkerRegistration' in self && 'sync' in self.serviceWorkerRegistration.prototype) {
        self.serviceWorkerRegistration.sync.register('sync-movimientos')
            .catch(error => console.error('Error registrando sync:', error));
    }
}
