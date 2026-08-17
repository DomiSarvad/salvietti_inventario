-- ============================================================
-- BASE DE DATOS: Salvietti en Supabase (PostgreSQL)
-- Sistema de Gestión de Inventario - Salvietti
-- ============================================================
CREATE SCHEMA IF NOT EXISTS public;

GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
GRANT ALL ON SCHEMA public TO anon;
GRANT ALL ON SCHEMA public TO authenticated;
GRANT ALL ON SCHEMA public TO service_role;

create extension if not exists pgcrypto;

-- ============================================================
-- TABLA: public.usuarios
-- Usuarios del sistema dentro de la aplicación. No se usa Auth.
-- ============================================================
create table if not exists public.usuarios (
  id uuid primary key default gen_random_uuid(),
  email text not null unique,
  password_hash text not null,
  nombre text not null default 'Usuario',
  rol text not null default 'encargado_almacen'
    check (rol in ('gerente', 'jefe_produccion', 'encargado_almacen', 'encargado_jarabes')),
  empresa text,
  telefono text,
  estado boolean not null default true,
  foto_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists idx_usuarios_email on public.usuarios(email);
create index if not exists idx_usuarios_rol on public.usuarios(rol, estado);

-- ============================================================
-- TABLA: public.proveedores
-- ============================================================
create table if not exists public.proveedores (
  id uuid primary key default gen_random_uuid(),
  nombre_empresa text not null,
  ruc text unique,
  contacto text,
  telefono text,
  correo text,
  catalogo_insumos text,
  activo boolean not null default true,
  created_at timestamptz not null default now()
);

create index if not exists idx_proveedores_nombre on public.proveedores(nombre_empresa);

-- ============================================================
-- TABLA: public.insumos_materias_primas
-- ============================================================
create table if not exists public.insumos_materias_primas (
  id uuid primary key default gen_random_uuid(),
  nombre text not null unique,
  descripcion text,
  stock_actual numeric(12,2) not null default 0,
  cantidad_minima numeric(12,2) not null default 0,
  unidad_medida text not null default 'kg',
  proveedor_id uuid references public.proveedores(id) on delete set null,
  proveedor_nombre text,
  numero_lote text,
  fecha_vencimiento date,
  ultimo_movimiento timestamptz,
  activo boolean not null default true,
  created_at timestamptz not null default now()
);

create index if not exists idx_insumos_stock on public.insumos_materias_primas(stock_actual);

-- ============================================================
-- TABLA: public.movimientos_inventario
-- ============================================================
create table if not exists public.movimientos_inventario (
  id uuid primary key default gen_random_uuid(),
  insumo_id uuid references public.insumos_materias_primas(id) on delete cascade,
  usuario_id uuid references public.usuarios(id) on delete set null,
  tipo text not null check (tipo in ('entrada', 'salida', 'consumo', 'borrado_logico')),
  cantidad numeric(12,2) not null default 0,
  stock_anterior numeric(12,2),
  stock_resultante numeric(12,2),
  detalle jsonb default '{}'::jsonb,
  created_at timestamptz not null default now(),
  sincronizado boolean not null default false
);

create index if not exists idx_movimientos_tipo on public.movimientos_inventario(tipo, created_at);
create index if not exists idx_movimientos_insumo on public.movimientos_inventario(insumo_id, created_at);

-- ============================================================
-- TABLA: public.bitacora_inventario
-- ============================================================
create table if not exists public.bitacora_inventario (
  id uuid primary key default gen_random_uuid(),
  usuario_id uuid references public.usuarios(id) on delete set null,
  evento text not null,
  tipo text not null,
  insumo_id uuid references public.insumos_materias_primas(id) on delete set null,
  insumo_nombre text,
  cantidad numeric(12,2) not null default 0,
  detalle jsonb default '{}'::jsonb,
  timestamp timestamptz not null default now(),
  sincronizado boolean not null default true,
  activo boolean not null default true
);

create index if not exists idx_bitacora_tipo on public.bitacora_inventario(tipo, timestamp);

-- ============================================================
-- TABLA: public.auditoria
-- ============================================================
create table if not exists public.auditoria (
  id uuid primary key default gen_random_uuid(),
  usuario_id uuid references public.usuarios(id) on delete set null,
  evento text not null,
  timestamp timestamptz not null default now(),
  activo boolean not null default true
);

-- ============================================================
-- TABLA: public.consumo_semanal
-- ============================================================
create table if not exists public.consumo_semanal (
  id uuid primary key default gen_random_uuid(),
  dia integer not null unique check (dia between 1 and 7),
  valor numeric(12,2) not null default 0,
  created_at timestamptz not null default now()
);

-- ============================================================
-- SEGURIDAD: RLS
-- Nota: como no usamos Supabase Auth, las políticas se dejan simples.
-- Para producción real conviene mover el login a un backend o edge function.
-- ============================================================
alter table public.usuarios enable row level security;
alter table public.proveedores enable row level security;
alter table public.insumos_materias_primas enable row level security;
alter table public.movimientos_inventario enable row level security;
alter table public.bitacora_inventario enable row level security;
alter table public.auditoria enable row level security;
alter table public.consumo_semanal enable row level security;

drop policy if exists "usuarios_read_all" on public.usuarios;
create policy "usuarios_read_all" on public.usuarios for select using (true);

drop policy if exists "usuarios_write_all" on public.usuarios;
create policy "usuarios_write_all" on public.usuarios for insert with check (true);

drop policy if exists "usuarios_update_all" on public.usuarios;
create policy "usuarios_update_all" on public.usuarios for update using (true) with check (true);

drop policy if exists "proveedores_read_all" on public.proveedores;
create policy "proveedores_read_all" on public.proveedores for select using (true);

drop policy if exists "proveedores_write_all" on public.proveedores;
create policy "proveedores_write_all" on public.proveedores for insert with check (true);

drop policy if exists "proveedores_update_all" on public.proveedores;
create policy "proveedores_update_all" on public.proveedores for update using (true) with check (true);

drop policy if exists "insumos_read_all" on public.insumos_materias_primas;
create policy "insumos_read_all" on public.insumos_materias_primas for select using (true);

drop policy if exists "insumos_write_all" on public.insumos_materias_primas;
create policy "insumos_write_all" on public.insumos_materias_primas for insert with check (true);

drop policy if exists "insumos_update_all" on public.insumos_materias_primas;
create policy "insumos_update_all" on public.insumos_materias_primas for update using (true) with check (true);

drop policy if exists "movimientos_read_all" on public.movimientos_inventario;
create policy "movimientos_read_all" on public.movimientos_inventario for select using (true);

drop policy if exists "movimientos_write_all" on public.movimientos_inventario;
create policy "movimientos_write_all" on public.movimientos_inventario for insert with check (true);

drop policy if exists "movimientos_update_all" on public.movimientos_inventario;
create policy "movimientos_update_all" on public.movimientos_inventario for update using (true) with check (true);

drop policy if exists "bitacora_read_all" on public.bitacora_inventario;
create policy "bitacora_read_all" on public.bitacora_inventario for select using (true);

drop policy if exists "bitacora_write_all" on public.bitacora_inventario;
create policy "bitacora_write_all" on public.bitacora_inventario for insert with check (true);

drop policy if exists "auditoria_read_all" on public.auditoria;
create policy "auditoria_read_all" on public.auditoria for select using (true);

drop policy if exists "auditoria_write_all" on public.auditoria;
create policy "auditoria_write_all" on public.auditoria for insert with check (true);

drop policy if exists "consumo_read_all" on public.consumo_semanal;
create policy "consumo_read_all" on public.consumo_semanal for select using (true);

drop policy if exists "consumo_write_all" on public.consumo_semanal;
create policy "consumo_write_all" on public.consumo_semanal for insert with check (true);

-- ============================================================
-- TRIGGER: updated_at
-- ============================================================
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists trg_usuarios_updated_at on public.usuarios;
create trigger trg_usuarios_updated_at
before update on public.usuarios
for each row execute function public.set_updated_at();

-- ============================================================
-- FUNCION DE LOGIN DENTRO DEL SISTEMA
-- Valida email + password usando bcrypt/pgcrypto.
-- ============================================================
create or replace function public.login_usuario(p_email text, p_password text)
returns table (
  id uuid,
  email text,
  nombre text,
  rol text,
  estado boolean,
  empresa text,
  telefono text,
  foto_url text
)
language plpgsql
security definer
as $$
begin
  return query
  select
    u.id,
    u.email,
    u.nombre,
    u.rol,
    u.estado,
    u.empresa,
    u.telefono,
    u.foto_url
  from public.usuarios u
  where lower(trim(u.email)) = lower(trim(p_email))
    and u.estado = true
    and u.password_hash = crypt(p_password, u.password_hash)
  limit 1;
end;
$$;

grant execute on function public.login_usuario(text, text) to anon;
grant execute on function public.login_usuario(text, text) to authenticated;

-- ============================================================
-- USUARIO BASE DEL SISTEMA
-- ============================================================
insert into public.usuarios (
  email,
  password_hash,
  nombre,
  rol,
  estado,
  empresa,
  telefono
)
values (
  'gerente@salvietti.com',
  crypt('12345678', gen_salt('bf')),
  'Gerente',
  'gerente',
  true,
  'Salvietti',
  '+591 00000000'
)
on conflict (email) do update set
  password_hash = excluded.password_hash,
  nombre = excluded.nombre,
  rol = excluded.rol,
  estado = true,
  empresa = excluded.empresa,
  telefono = excluded.telefono,
  updated_at = now();

-- ============================================================
-- DATOS DE PRUEBA
-- ============================================================
insert into public.proveedores (nombre_empresa, ruc, contacto, telefono, correo, catalogo_insumos, activo)
values
  ('Productos Andinos S.A.', '123456789', 'Juan Pérez', '+591 7654321', 'juan@productosandinos.com', 'Catálogo principal 2025', true),
  ('Packaging Solutions Ltd.', '987654321', 'María García', '+591 2345678', 'maria@packagingsol.com', 'Catálogo de envases', true),
  ('Insumos Nacionales E.I.R.L.', '456789012', 'Carlos López', '+591 3456789', 'carlos@insumosna.com', 'Catálogo complementario', true)
on conflict (ruc) do nothing;

insert into public.insumos_materias_primas (nombre, descripcion, stock_actual, cantidad_minima, unidad_medida, proveedor_nombre, activo)
values
  ('Tapa Short 32oz', 'Tapa corta negra para envase de 32oz con rosca estándar', 1200, 500, 'unidad', 'Productos Andinos S.A.', true),
  ('Tapa Pet 16oz', 'Tapa de polietileno tereftalato para botellas 16oz con cierre hermético', 900, 300, 'unidad', 'Productos Andinos S.A.', true),
  ('Tapa Pet 24oz', 'Tapa transparente con precinto de seguridad para 24oz', 1100, 400, 'unidad', 'Productos Andinos S.A.', true),
  ('Preforma 32oz', 'Preforma de PET 32oz grado alimentario para bebidas frías', 1500, 1000, 'unidad', 'Packaging Solutions Ltd.', true),
  ('Preforma 24oz', 'Preforma de PET 24oz alta resistencia certificada', 1100, 800, 'unidad', 'Packaging Solutions Ltd.', true),
  ('Preforma 20oz', 'Preforma de PET 20oz para bebidas de baja carbonatación', 850, 600, 'unidad', 'Packaging Solutions Ltd.', true),
  ('Etiqueta Full Print', 'Etiqueta adhesiva full color con laminado satinado 300x150mm', 2500, 1000, 'rollo', 'Insumos Nacionales E.I.R.L.', true),
  ('Tapa Flip 500ml', 'Tapa de volteo para botellas de 500ml bebidas deportivas', 600, 250, 'unidad', 'Insumos Nacionales E.I.R.L.', true)
on conflict (nombre) do nothing;

insert into public.consumo_semanal (dia, valor)
values
  (1, 3.0),
  (2, 5.2),
  (3, 4.5),
  (4, 6.0),
  (5, 4.8),
  (6, 5.0),
  (7, 3.3)
on conflict (dia) do update set
  valor = excluded.valor,
  created_at = now();

-- ============================================================
-- VISTAS DE SOPORTE
-- ============================================================
create or replace view public.vista_insumos_estado as
select
  i.id,
  i.nombre,
  i.unidad_medida,
  i.stock_actual,
  i.cantidad_minima,
  case
    when i.stock_actual < i.cantidad_minima then 'critico'
    when i.stock_actual < (i.cantidad_minima * 1.5) then 'bajo'
    else 'normal'
  end as estado,
  case
    when i.stock_actual < i.cantidad_minima then 'rojo'
    when i.stock_actual < (i.cantidad_minima * 1.5) then 'amarillo'
    else 'verde'
  end as indicador
from public.insumos_materias_primas i
where i.activo = true;

create or replace view public.vista_proveedores_activos as
select
  p.id,
  p.nombre_empresa,
  p.ruc,
  p.contacto,
  p.telefono,
  p.correo,
  count(ipm.id) as total_insumos
from public.proveedores p
left join public.insumos_materias_primas ipm on ipm.proveedor_id = p.id
where p.activo = true
group by p.id, p.nombre_empresa, p.ruc, p.contacto, p.telefono, p.correo;

-- ============================================================
-- FIN DEL SCRIPT
-- ============================================================
