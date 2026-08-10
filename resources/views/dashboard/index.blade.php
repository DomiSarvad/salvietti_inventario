@extends('layouts.app')

@section('title', 'Dashboard - Salvietti')

@section('content')
<div class="page-header">
    <h1>Dashboard Ejecutivo</h1>
    <p class="text-secondary">Resumen del estado actual del inventario</p>
</div>

<!-- Indicadores Principales -->
<div class="row">
    <div class="col-3">
        <div class="card metric-card">
            <div class="card-body">
                <div class="metric-icon" style="background-color: var(--success);">
                    📊
                </div>
                <div class="metric-content">
                    <h3>Salud del Inventario</h3>
                    <p class="metric-value">{{ $salud_inventario['estado'] ?? 'Óptimo' }}</p>
                    <span class="badge badge-success">{{ $salud_inventario['porcentaje'] ?? '95%' }}</span>
                </div>
            </div>
        </div>
    </div>

    <div class="col-3">
        <div class="card metric-card">
            <div class="card-body">
                <div class="metric-icon" style="background-color: var(--danger);">
                    ⚠️
                </div>
                <div class="metric-content">
                    <h3>Stock Crítico</h3>
                    <p class="metric-value">{{ count($stock_critico) }}</p>
                    <a href="/inventario?filtro=critico" class="text-sm">Ver insumos</a>
                </div>
            </div>
        </div>
    </div>

    <div class="col-3">
        <div class="card metric-card">
            <div class="card-body">
                <div class="metric-icon" style="background-color: var(--warning);">
                    📅
                </div>
                <div class="metric-content">
                    <h3>Próximo a Vencer</h3>
                    <p class="metric-value">{{ count($insumos_proximo_vencer) }}</p>
                    <a href="/inventario?filtro=vencimiento" class="text-sm">Ver lotes</a>
                </div>
            </div>
        </div>
    </div>

    <div class="col-3">
        <div class="card metric-card">
            <div class="card-body">
                <div class="metric-icon" style="background-color: var(--info);">
                    📦
                </div>
                <div class="metric-content">
                    <h3>Movimientos</h3>
                    <p class="metric-value">{{ count($movimientos_recientes) }}</p>
                    <a href="/inventario/movimientos" class="text-sm">Ver historial</a>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="row mt">
    <!-- Tabla de Stock Crítico -->
    <div class="col-6">
        <div class="card">
            <div class="card-header">
                🔴 Insumos en Stock Crítico
            </div>
            <div class="card-body">
                @if(count($stock_critico) > 0)
                <table>
                    <thead>
                        <tr>
                            <th>Insumo</th>
                            <th>Stock</th>
                            <th>Mínimo</th>
                            <th>Acción</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($stock_critico as $insumo)
                        <tr>
                            <td>{{ $insumo['nombre'] }}</td>
                            <td>
                                <span class="stock-indicator red"></span>
                                {{ $insumo['stock'] }}
                            </td>
                            <td>{{ $insumo['minimo'] }}</td>
                            <td>
                                <a href="/inventario/entradas/crear" class="btn btn-sm btn-primary">
                                    Comprar
                                </a>
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
                @else
                <p class="text-center text-secondary">No hay insumos en stock crítico</p>
                @endif
            </div>
        </div>
    </div>

    <!-- Insumos Próximos a Vencer -->
    <div class="col-6">
        <div class="card">
            <div class="card-header">
                📅 Lotes Próximos a Vencer
            </div>
            <div class="card-body">
                @if(count($insumos_proximo_vencer) > 0)
                <table>
                    <thead>
                        <tr>
                            <th>Lote</th>
                            <th>Insumo</th>
                            <th>Días</th>
                            <th>Acción</th>
                        </tr>
                    </thead>
                    <tbody>
                        @foreach($insumos_proximo_vencer as $lote)
                        <tr>
                            <td>{{ $lote['codigo'] }}</td>
                            <td>{{ $lote['insumo'] }}</td>
                            <td>
                                <span class="stock-indicator yellow"></span>
                                {{ $lote['dias'] }} días
                            </td>
                            <td>
                                <a href="#" class="btn btn-sm btn-secondary">Usar</a>
                            </td>
                        </tr>
                        @endforeach
                    </tbody>
                </table>
                @else
                <p class="text-center text-secondary">No hay lotes próximos a vencer</p>
                @endif
            </div>
        </div>
    </div>
</div>

<!-- Movimientos Recientes -->
<div class="card mt">
    <div class="card-header">
        📝 Últimos Movimientos
    </div>
    <div class="card-body">
        @if(count($movimientos_recientes) > 0)
        <table>
            <thead>
                <tr>
                    <th>Fecha</th>
                    <th>Tipo</th>
                    <th>Insumo</th>
                    <th>Cantidad</th>
                    <th>Usuario</th>
                </tr>
            </thead>
            <tbody>
                @foreach($movimientos_recientes as $mov)
                <tr>
                    <td>{{ $mov['fecha'] }}</td>
                    <td>
                        @if($mov['tipo'] == 'entrada')
                            <span class="badge badge-success">Entrada</span>
                        @elseif($mov['tipo'] == 'salida')
                            <span class="badge badge-danger">Salida</span>
                        @else
                            <span class="badge badge-info">Consumo</span>
                        @endif
                    </td>
                    <td>{{ $mov['insumo'] }}</td>
                    <td>{{ $mov['cantidad'] }} {{ $mov['unidad'] }}</td>
                    <td>{{ $mov['usuario'] }}</td>
                </tr>
                @endforeach
            </tbody>
        </table>
        @else
        <p class="text-center text-secondary">No hay movimientos registrados</p>
        @endif
    </div>
</div>

@endsection

@section('css')
<style>
    .page-header {
        margin-bottom: 2rem;
    }

    .metric-card {
        transition: transform 0.2s, box-shadow 0.2s;
    }

    .metric-card:hover {
        transform: translateY(-4px);
        box-shadow: var(--shadow-lg);
    }

    .metric-icon {
        width: 50px;
        height: 50px;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 1.5rem;
        margin-bottom: 1rem;
    }

    .metric-value {
        font-size: 2rem;
        font-weight: 700;
        color: var(--primary);
    }

    .text-sm {
        font-size: var(--font-size-sm);
    }
</style>
@endsection
