<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'Sistema de Inventario - Salvietti')</title>
    
    <!-- Estilos -->
    <link rel="stylesheet" href="/css/main.css">
    <link rel="stylesheet" href="/css/theme.css">
    
    <!-- Favicon -->
    <link rel="icon" type="image/x-icon" href="/images/favicon.ico">
    
    @yield('css')
</head>
<body>
    <!-- Navegación -->
    <nav class="navbar">
        <div class="container">
            <div class="nav-brand">
                <img src="/images/logo.png" alt="Salvietti" class="logo">
                <span class="brand-name">Sistema Salvietti</span>
            </div>
            
            <div class="nav-menu">
                <a href="/dashboard" class="nav-link @if(Route::current()->getName() == 'dashboard') active @endif">
                    Dashboard
                </a>
                <a href="/inventario" class="nav-link @if(strpos(Route::current()->getName(), 'inventario') === 0) active @endif">
                    Inventario
                </a>
                <a href="/produccion" class="nav-link @if(strpos(Route::current()->getName(), 'produccion') === 0) active @endif">
                    Producción
                </a>
                <a href="/proveedores" class="nav-link @if(strpos(Route::current()->getName(), 'proveedores') === 0) active @endif">
                    Proveedores
                </a>
                <a href="/alertas" class="nav-link @if(strpos(Route::current()->getName(), 'alertas') === 0) active @endif">
                    Alertas
                </a>
            </div>
            
            <div class="nav-user">
                <span class="user-name">{{ Auth::user()->nombre ?? 'Usuario' }}</span>
                <a href="/logout" class="btn btn-sm btn-danger">Salir</a>
            </div>
        </div>
    </nav>

    <!-- Contenido Principal -->
    <main class="main-content">
        <div class="container">
            <!-- Breadcrumb -->
            @if(isset($breadcrumb))
            <div class="breadcrumb">
                @foreach($breadcrumb as $item)
                    <span class="breadcrumb-item">{{ $item }}</span>
                @endforeach
            </div>
            @endif

            <!-- Alertas -->
            @if($errors->any())
            <div class="alert alert-danger">
                <strong>Errores:</strong>
                <ul>
                    @foreach($errors->all() as $error)
                        <li>{{ $error }}</li>
                    @endforeach
                </ul>
            </div>
            @endif

            @if(session('success'))
            <div class="alert alert-success">
                {{ session('success') }}
            </div>
            @endif

            @if(session('error'))
            <div class="alert alert-danger">
                {{ session('error') }}
            </div>
            @endif

            <!-- Contenido -->
            @yield('content')
        </div>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <p>&copy; 2026 Sistema de Inventario Salvietti. Todos los derechos reservados.</p>
            <p>Versión 1.0 | Estado: Desarrollo</p>
        </div>
    </footer>

    <!-- Scripts -->
    <script src="/js/main.js"></script>
    <script src="/js/offline.js"></script>
    
    @yield('js')
</body>
</html>
