/**
 * MAIN.JS - Script principal del sistema
 * Inicialización y funciones globales
 */

// Configuración global
const CONFIG = {
    apiUrl: '/api',
    timeout: 5000,
    retryAttempts: 3,
    colors: {
        primary: '#0FA34A',
        secondary: '#FFD166',
        accent: '#E0E0E0',
        danger: '#DC2626'
    }
};

// Estado de la aplicación
const APP_STATE = {
    online: navigator.onLine,
    user: null,
    authenticated: false
};

/**
 * Inicializar aplicación
 */
document.addEventListener('DOMContentLoaded', function() {
    console.log('🚀 Sistema Salvietti iniciando...');
    
    // Registrar Service Worker
    if ('serviceWorker' in navigator) {
        navigator.serviceWorker.register('/js/offline.js')
            .then(registration => {
                console.log('✅ Service Worker registrado:', registration);
            })
            .catch(error => {
                console.error('❌ Error registrando Service Worker:', error);
            });
    }

    // Detectar cambios de conexión
    detectarConexion();
    
    // Inicializar IndexedDB
    inicializarIndexedDB();
    
    // Cargar datos locales
    cargarDatos();
    
    // Configurar event listeners
    configurarEventListeners();
});

/**
 * Detectar estado de conexión
 */
function detectarConexion() {
    window.addEventListener('online', function() {
        APP_STATE.online = true;
        mostrarNotificacion('✅ Conexión establecida', 'success');
        sincronizarDatos();
    });

    window.addEventListener('offline', function() {
        APP_STATE.online = false;
        mostrarNotificacion('📴 Sin conexión - Modo offline', 'warning');
    });

    // Mostrar estado inicial
    mostrarEstadoConexion();
}

/**
 * Mostrar estado de conexión
 */
function mostrarEstadoConexion() {
    const indicador = document.getElementById('conexion-status');
    if (indicador) {
        indicador.innerHTML = APP_STATE.online 
            ? '<span class="status-badge online">● En línea</span>'
            : '<span class="status-badge offline">● Offline</span>';
    }
}

/**
 * Inicializar IndexedDB
 */
function inicializarIndexedDB() {
    const dbRequest = indexedDB.open('SalviettiDB', 1);

    dbRequest.onerror = function() {
        console.error('Error abriendo IndexedDB');
    };

    dbRequest.onsuccess = function(event) {
        console.log('✅ IndexedDB inicializado');
        window.db = event.target.result;
    };

    dbRequest.onupgradeneeded = function(event) {
        const db = event.target.result;

        // Crear object stores
        if (!db.objectStoreNames.contains('movimientos')) {
            db.createObjectStore('movimientos', { keyPath: 'id', autoIncrement: true });
        }
        if (!db.objectStoreNames.contains('insumos')) {
            db.createObjectStore('insumos', { keyPath: 'id' });
        }
        if (!db.objectStoreNames.contains('alertas')) {
            db.createObjectStore('alertas', { keyPath: 'id', autoIncrement: true });
        }
    };
}

/**
 * Cargar datos locales
 */
function cargarDatos() {
    // Cargar datos de localStorage y IndexedDB
    const usuario = localStorage.getItem('usuario');
    if (usuario) {
        APP_STATE.user = JSON.parse(usuario);
        APP_STATE.authenticated = true;
    }
}

/**
 * Configurar event listeners globales
 */
function configurarEventListeners() {
    // Botones comunes
    document.addEventListener('click', function(e) {
        // Cerrar dropdowns
        if (!e.target.closest('.dropdown-toggle')) {
            document.querySelectorAll('.dropdown-menu.show').forEach(menu => {
                menu.classList.remove('show');
            });
        }
    });

    // Validación de formularios
    document.querySelectorAll('form').forEach(form => {
        form.addEventListener('submit', validarFormulario);
    });
}

/**
 * Hacer request API
 */
async function apiRequest(endpoint, options = {}) {
    const url = CONFIG.apiUrl + endpoint;
    const defaultOptions = {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': obtenerCSRFToken()
        }
    };

    const config = { ...defaultOptions, ...options };

    try {
        const response = await fetch(url, config);

        if (!response.ok) {
            throw new Error(`Error ${response.status}: ${response.statusText}`);
        }

        return await response.json();
    } catch (error) {
        console.error('Error en API request:', error);
        throw error;
    }
}

/**
 * Sincronizar datos con servidor
 */
async function sincronizarDatos() {
    if (!APP_STATE.online) {
        console.log('No hay conexión - Sincronización pospuesta');
        return;
    }

    console.log('🔄 Sincronizando datos...');

    try {
        // Sincronizar movimientos locales
        const db = window.db;
        if (db && db.objectStoreNames.contains('movimientos')) {
            const tx = db.transaction('movimientos', 'readonly');
            const store = tx.objectStore('movimientos');
            const request = store.getAll();

            request.onsuccess = async function() {
                const movimientos = request.result.filter(m => !m.sincronizado);
                
                for (const mov of movimientos) {
                    try {
                        await apiRequest('/inventario/movimientos', {
                            method: 'POST',
                            body: JSON.stringify(mov)
                        });

                        // Marcar como sincronizado
                        const updateTx = db.transaction('movimientos', 'readwrite');
                        updateTx.objectStore('movimientos').put({ ...mov, sincronizado: true });
                    } catch (error) {
                        console.error('Error sincronizando movimiento:', error);
                    }
                }
            };
        }

        mostrarNotificacion('✅ Sincronización completada', 'success');
    } catch (error) {
        console.error('Error en sincronización:', error);
    }
}

/**
 * Mostrar notificación
 */
function mostrarNotificacion(mensaje, tipo = 'info') {
    const container = document.getElementById('notificaciones-container') || crearContenedorNotificaciones();
    
    const notif = document.createElement('div');
    notif.className = `notificacion notificacion-${tipo} fade-in`;
    notif.innerHTML = `
        <span>${mensaje}</span>
        <button class="cerrar-notif" onclick="this.parentElement.remove()">×</button>
    `;

    container.appendChild(notif);

    // Auto-cerrar después de 4 segundos
    setTimeout(() => {
        notif.classList.add('fade-out');
        setTimeout(() => notif.remove(), 300);
    }, 4000);
}

/**
 * Crear contenedor de notificaciones
 */
function crearContenedorNotificaciones() {
    const container = document.createElement('div');
    container.id = 'notificaciones-container';
    container.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        z-index: 10000;
        max-width: 400px;
    `;
    document.body.appendChild(container);
    return container;
}

/**
 * Validar formulario
 */
function validarFormulario(e) {
    const form = e.target;
    let valido = true;

    form.querySelectorAll('input, textarea, select').forEach(field => {
        if (!validarCampo(field)) {
            valido = false;
        }
    });

    if (!valido) {
        e.preventDefault();
        mostrarNotificacion('Por favor revisa los campos marcados', 'warning');
    }
}

/**
 * Validar campo individual
 */
function validarCampo(field) {
    const valor = field.value.trim();

    if (field.required && !valor) {
        field.classList.add('is-invalid');
        return false;
    }

    if (field.type === 'email' && valor && !esEmailValido(valor)) {
        field.classList.add('is-invalid');
        return false;
    }

    if (field.type === 'number' && valor && isNaN(parseFloat(valor))) {
        field.classList.add('is-invalid');
        return false;
    }

    field.classList.remove('is-invalid');
    field.classList.add('is-valid');
    return true;
}

/**
 * Validar email
 */
function esEmailValido(email) {
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return regex.test(email);
}

/**
 * Obtener token CSRF
 */
function obtenerCSRFToken() {
    return document.querySelector('meta[name="csrf-token"]')?.content || '';
}

/**
 * Guardar en IndexedDB
 */
function guardarEnIndexedDB(storeName, datos) {
    if (!window.db) {
        console.error('IndexedDB no disponible');
        return Promise.reject('DB no disponible');
    }

    return new Promise((resolve, reject) => {
        const tx = window.db.transaction(storeName, 'readwrite');
        const store = tx.objectStore(storeName);
        const request = store.add(datos);

        request.onsuccess = () => resolve(request.result);
        request.onerror = () => reject(request.error);
    });
}

/**
 * Obtener de IndexedDB
 */
function obtenerDeIndexedDB(storeName, key) {
    if (!window.db) {
        console.error('IndexedDB no disponible');
        return Promise.reject('DB no disponible');
    }

    return new Promise((resolve, reject) => {
        const tx = window.db.transaction(storeName, 'readonly');
        const store = tx.objectStore(storeName);
        const request = key ? store.get(key) : store.getAll();

        request.onsuccess = () => resolve(request.result);
        request.onerror = () => reject(request.error);
    });
}

// Exportar funciones globales
window.apiRequest = apiRequest;
window.sincronizarDatos = sincronizarDatos;
window.mostrarNotificacion = mostrarNotificacion;
window.guardarEnIndexedDB = guardarEnIndexedDB;
window.obtenerDeIndexedDB = obtenerDeIndexedDB;

console.log('✅ Sistema Salvietti cargado correctamente');
