<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Sistema Salvietti</title>
    <link rel="stylesheet" href="/css/main.css">
    <link rel="stylesheet" href="/css/theme.css">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <style>
        body {
            background: linear-gradient(135deg, #0FA34A 0%, #0d8c3a 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .login-container {
            background: white;
            border-radius: 0.75rem;
            box-shadow: var(--shadow-xl);
            width: 100%;
            max-width: 450px;
            padding: 3rem;
        }

        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .logo-login {
            width: 80px;
            height: 80px;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, #0FA34A 0%, #FFD166 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin-left: auto;
            margin-right: auto;
            color: white;
            font-weight: bold;
        }

        .login-header h1 {
            color: var(--text-dark);
            margin-bottom: 0.5rem;
        }

        .login-header p {
            color: var(--text-secondary);
            font-size: var(--font-size-sm);
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
            color: var(--text-dark);
        }

        .form-group input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid var(--border);
            border-radius: 0.375rem;
            font-size: var(--font-size-base);
            transition: border-color 0.2s;
        }

        .form-group input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(15, 163, 74, 0.1);
        }

        .login-btn {
            width: 100%;
            padding: 0.875rem;
            background: linear-gradient(135deg, #0FA34A 0%, #0d8c3a 100%);
            color: white;
            border: none;
            border-radius: 0.375rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            margin-bottom: 1rem;
        }

        .login-btn:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-lg);
        }

        .login-footer {
            text-align: center;
            color: var(--text-secondary);
            font-size: var(--font-size-sm);
        }

        .alert-error {
            background-color: #fee2e2;
            border-left: 4px solid var(--danger);
            color: #7f1d1d;
            padding: 1rem;
            border-radius: 0.375rem;
            margin-bottom: 1rem;
        }

        .estado-conexion {
            position: absolute;
            top: 20px;
            right: 20px;
            padding: 0.75rem 1rem;
            border-radius: 9999px;
            font-size: var(--font-size-sm);
            font-weight: 600;
        }

        .status-online {
            background: #d1fae5;
            color: #065f46;
        }

        .status-offline {
            background: #fef3c7;
            color: #78350f;
        }
    </style>
</head>
<body>
    <!-- Indicador de conexión -->
    <div id="conexion-status" class="estado-conexion"></div>

    <div class="login-container">
        <div class="login-header">
            <div class="logo-login">S</div>
            <h1>Sistema Salvietti</h1>
            <p>Gestión Integral de Inventario</p>
        </div>

        @if ($errors->any())
            <div class="alert-error">
                <strong>Error en el login:</strong>
                <ul>
                    @foreach ($errors->all() as $error)
                        <li>{{ $error }}</li>
                    @endforeach
                </ul>
            </div>
        @endif

        <form method="POST" action="/login" class="login-form">
            @csrf

            <div class="form-group">
                <label for="email">Email</label>
                <input 
                    type="email" 
                    id="email" 
                    name="email" 
                    required 
                    placeholder="tu@email.com"
                    value="{{ old('email') }}"
                >
            </div>

            <div class="form-group">
                <label for="contrasena">Contraseña</label>
                <input 
                    type="password" 
                    id="contrasena" 
                    name="contrasena" 
                    required 
                    placeholder="••••••••"
                >
            </div>

            <button type="submit" class="login-btn">
                Iniciar Sesión
            </button>

            <div class="login-footer">
                <p>Sistema en fase de desarrollo</p>
                <p>Para soporte: <strong>soporte@salvietti.com</strong></p>
            </div>
        </form>
    </div>

    <script src="/js/main.js"></script>
    <script>
        // Mostrar estado de conexión
        document.addEventListener('DOMContentLoaded', function() {
            const indicador = document.getElementById('conexion-status');
            if (navigator.onLine) {
                indicador.textContent = '● En línea';
                indicador.className = 'estado-conexion status-online';
            } else {
                indicador.textContent = '● Offline';
                indicador.className = 'estado-conexion status-offline';
            }

            window.addEventListener('online', function() {
                indicador.textContent = '● En línea';
                indicador.className = 'estado-conexion status-online';
            });

            window.addEventListener('offline', function() {
                indicador.textContent = '● Offline';
                indicador.className = 'estado-conexion status-offline';
            });
        });
    </script>
</body>
</html>
