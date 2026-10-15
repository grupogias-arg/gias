# Deploy

Kamal sobre un VPS de Hetzner, con Postgres en la misma máquina y las fotos en
Cloudflare R2. La primera vez se prueba en un subdominio propio de Namecheap;
después se pasa a `gias.com.ar` y el de prueba se borra.

Todo lo que es código ya está configurado: `config/deploy.yml`,
`.kamal/secrets`, `config/storage.yml` (servicio `r2`) y las credentials
encriptadas, que ya tienen la contraseña de Postgres generada.

## 0. Antes de empezar

- **Guardar `config/master.key` en un gestor de contraseñas.** No está en git,
  y sin ella no se pueden leer las credentials (contraseña de la base, claves
  de R2). Si se pierde no se puede recuperar.
- Instalar Docker Desktop (u OrbStack) en la Mac y dejarlo abierto: Kamal
  construye la imagen localmente.
- Tener una clave SSH: `~/.ssh/id_ed25519.pub`.

## 1. Servidor en Hetzner

En console.hetzner.cloud → nuevo proyecto "GIAS" → **Add server**:

| Opción | Valor |
|---|---|
| Location | Nuremberg o Falkenstein (las ARM solo están en Europa) |
| Image | Ubuntu 24.04 |
| Type | **Arm64 (Ampere) → CAX11** (2 vCPU, 4 GB) |
| Networking | IPv4 + IPv6 |
| SSH keys | pegar el contenido de `~/.ssh/id_ed25519.pub` |
| Firewalls | crear uno con entrada TCP **22, 80 y 443**, nada más |

Se elige ARM porque la Mac también lo es: la imagen se construye nativa. Con
un servidor x86 habría que emular y el build tarda varias veces más.

Anotar la IPv4 y probar que se puede entrar:

```sh
ssh root@IP_DEL_SERVIDOR
```

## 2. DNS de prueba en Namecheap

Domain List → tu dominio → **Manage → Advanced DNS → Add new record**:

| Type | Host | Value | TTL |
|---|---|---|---|
| A Record | `gias` | IP del servidor | Automatic |

Eso crea `gias.tudominio.com` sin tocar nada más del dominio. Esperar a que
resuelva (unos minutos):

```sh
dig +short gias.tudominio.com   # tiene que devolver la IP
```

Hace falta **antes** del deploy: Let's Encrypt verifica el dominio contra el
servidor para emitir el certificado.

## 3. Bucket en Cloudflare R2

En dash.cloudflare.com → **R2 Object Storage** (pide tarjeta aunque los
primeros 10 GB son gratis):

1. **Create bucket** → nombre `gias`, location hint *Eastern North America*.
2. **Manage API tokens → Create API token** → permiso *Object Read & Write*,
   aplicado solo al bucket `gias`. Te muestra **una sola vez** el Access Key ID
   y el Secret Access Key.
3. El **Account ID** está en la página principal de R2.

Cargarlos en las credentials:

```sh
EDITOR="code --wait" bin/rails credentials:edit
```

Al final del archivo hay un bloque `r2:` comentado: descomentarlo, completar
y guardar.

## 4. Configurar y commitear

En `config/deploy.yml` reemplazar `IP_DEL_SERVIDOR` (aparece dos veces) y
`DOMINIO` (por `gias.tudominio.com`).

**Kamal construye desde el último commit, no desde los archivos sueltos.** Lo
que no esté commiteado no llega al servidor:

```sh
git add -A && git commit -m "Configurar deploy"
```

## 5. Primer deploy

```sh
bin/kamal setup
```

Tarda unos minutos la primera vez. Instala Docker en el servidor, levanta
Postgres y el proxy, construye la imagen, la sube y arranca la app, que crea
las bases y corre las migraciones sola.

Al terminar, `https://gias.tudominio.com` tiene que abrir el sitio, con
candado y **vacío**: todavía no tiene contenido.

## 6. Cargar el contenido

Los seeds leen `drive/`, que no va en la imagen, y convierten fotos con
`sips`, que existe solo en macOS. Por eso se corren **desde la Mac**, contra la
base del servidor por un túnel SSH, y las fotos van directo a R2.

En una terminal, abrir el túnel y dejarlo abierto:

```sh
ssh -N -L 5433:127.0.0.1:5432 root@IP_DEL_SERVIDOR
```

En otra:

```sh
RAILS_ENV=production DB_HOST=127.0.0.1 DB_PORT=5433 \
GIAS_DATABASE_PASSWORD=$(bin/rails credentials:fetch database_password) \
SEED_PLACEHOLDERS=true bin/rails db:seed
```

`SEED_PLACEHOLDERS=true` también carga las publicaciones y proyectos
`[EJEMPLO]`. Para la prueba está bien. Para `gias.com.ar`, primero hay que
decidir con el grupo si se publica con eso (ver CLAUDE.md).

## Deploys siguientes

```sh
git commit -am "..." && bin/kamal deploy
```

Comandos útiles: `bin/kamal logs`, `bin/kamal console` (consola de Rails en
producción), `bin/kamal rollback <versión>`.

## 7. Pasar a gias.com.ar y borrar el de prueba

1. En Cloudflare: **Add a site** → `gias.com.ar`, plan Free. Te da dos
   nameservers.
2. **Ferretti**, que es el titular, los carga en nic.ar → Mis dominios →
   gias.com.ar → Delegaciones (con su clave fiscal).
3. En Cloudflare → DNS: registro A `gias.com.ar` → IP del servidor, y otro A
   `www` → misma IP, los dos con la nube en **gris (DNS only)**. Con la nube
   naranja, Let's Encrypt no puede validar el dominio desde el servidor.
4. En `config/deploy.yml`, cambiar `host: DOMINIO` por:
   ```yaml
   hosts:
     - gias.com.ar
     - www.gias.com.ar
   ```
   Commit y `bin/kamal deploy`.
5. Borrar el registro A `gias` en Namecheap. Listo, el de prueba deja de
   existir.

El servidor, la base y el bucket son los mismos: no se borra nada. Si se quiere
arrancar de cero, `bin/kamal app exec "bin/rails db:reset"` no sirve (está
bloqueado en producción). Lo más simple es `bin/kamal remove`, que borra todo
del servidor incluida la base; vaciar el bucket desde Cloudflare y volver al
paso 5.

## Pendiente para más adelante

- **Backups de Postgres.** Hoy la base vive solo en el disco del VPS. Activar
  los backups de Hetzner (+20 % del precio) como mínimo.
- **CORS en el bucket**, cuando exista el panel: Trix sube las imágenes
  directo del navegador a R2 y sin CORS falla.
