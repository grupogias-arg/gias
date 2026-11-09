# Deploy

Kamal sobre un VPS de Hetzner, con Postgres en la misma máquina y las fotos en
Cloudflare R2.

Hoy el sitio corre en una prueba (`gias.morci-the-dog.lat`) con servidor y
bucket en cuentas de Clara. El definitivo va en **cuentas del grupo**, para que
el sitio sea del grupo y no dependa de una persona: Hetzner y Cloudflare a nombre
de `grupogias.arg@gmail.com`, con Clara invitada. O sea que el lanzamiento es
una instalación nueva (servidor, bucket y base nuevos) y al final se borra la
prueba entera.

Lo que hace el grupo está en el PDF que se le mandó a Fiorela, "Publicar el
sitio del GIAS en gias.com.ar": abrir las dos cuentas, invitar a Clara, y el
trámite de Nelson en NIC Argentina.

Todo lo que es código ya está: `config/deploy.yml`, `.kamal/secrets`,
`config/storage.yml` (servicio `r2`) y las credentials encriptadas.

## 0. Antes de empezar

- **`config/master.key` guardada en un gestor de contraseñas.** No está en git,
  y sin ella no se pueden leer las credentials (contraseña de la base, claves
  de R2). Si se pierde no se puede recuperar.
- Docker Desktop (u OrbStack) abierto en la Mac: Kamal construye la imagen
  localmente.
- La clave SSH del proyecto, `~/.ssh/gias` (no la personal ni la del trabajo),
  cargada en el agente: `ssh-add --apple-use-keychain ~/.ssh/gias`.
- Las dos invitaciones aceptadas: proyecto **GIAS** en Hetzner (rol Admin) y la
  cuenta de Cloudflare del grupo (rol Administrator), con R2 ya activado.

## 1. Cloudflare: agregar el dominio (primero, porque tarda)

La delegación en NIC puede tardar hasta 24 horas en verse, así que esto va
antes que todo lo demás.

En la cuenta de Cloudflare **del grupo** (arriba a la izquierda se elige la
cuenta): **Add a site** → `gias.com.ar` → plan **Free**. Al final muestra dos
nameservers, del estilo `nombre.ns.cloudflare.com`.

Mandárselos a Nelson: es el paso 4 del PDF. Cuando avise, se puede ver si ya
tomó:

```sh
dig +short NS gias.com.ar   # tienen que aparecer los dos de Cloudflare
```

## 2. R2: bucket, claves y CORS

En la cuenta del grupo → **R2 Object Storage**:

1. **Create bucket** → nombre `gias`, location hint *Eastern North America*.
2. **Manage API tokens → Create API token** → permiso *Object Read & Write*,
   aplicado solo al bucket `gias`. Muestra **una sola vez** el Access Key ID y
   el Secret Access Key.
3. El **Account ID** está en la página principal de R2.

Reemplazar el bloque `r2:` de las credentials (hoy tiene las de la prueba):

```sh
EDITOR="code --wait" bin/rails credentials:edit
```

4. **CORS**, en el bucket → **Settings → CORS Policy → Add CORS policy**. Sin
   esto, el panel no puede subir fotos ni PDF: el navegador los sube directo a
   R2 (`PUT`) con esos tres encabezados.

   ```json
   [
     {
       "AllowedOrigins": ["https://gias.com.ar", "https://www.gias.com.ar"],
       "AllowedMethods": ["PUT"],
       "AllowedHeaders": ["Content-Type", "Content-MD5", "Content-Disposition"],
       "MaxAgeSeconds": 3600
     }
   ]
   ```

   Para leer no hace falta nada: el bucket es privado y las fotos se sirven
   por redirect de Rails a una URL firmada.

## 3. Hetzner: el servidor

En console.hetzner.com → proyecto **GIAS** (el del grupo, no uno propio) →
**Add server**:

| Opción | Valor |
|---|---|
| Location | Nuremberg o Falkenstein (las ARM solo están en Europa) |
| Image | Ubuntu 24.04 |
| Type | **Arm64 (Ampere) → CAX11** (2 vCPU, 4 GB) |
| Networking | IPv4 + IPv6 |
| SSH keys | pegar el contenido de `~/.ssh/gias.pub` |
| Firewalls | uno con entrada TCP **22, 80 y 443**, nada más |
| Backups | **activados** (+20 % del precio) |

ARM porque la Mac también lo es: la imagen se construye nativa. Con un
servidor x86 habría que emular, el build tarda varias veces más y hay que
cambiar `builder.arch` en `config/deploy.yml`.

Los backups no son opcionales: la base vive solo en el disco de este servidor,
y ahí van a quedar las novedades y todo lo que cargue el grupo.

Anotar la IPv4 y probar que se entra:

```sh
ssh -i ~/.ssh/gias root@IP_DEL_SERVIDOR
```

## 4. DNS en Cloudflare

En la cuenta del grupo → `gias.com.ar` → **DNS → Records**:

| Type | Name | Content | Proxy status |
|---|---|---|---|
| A | `@` | IP del servidor | **DNS only** (nube gris) |
| A | `www` | IP del servidor | **DNS only** (nube gris) |

Con la nube naranja, Let's Encrypt no puede validar el dominio contra el
servidor y no hay certificado.

## 5. Configurar y commitear

En `config/deploy.yml`:

- La IP del servidor de prueba aparece **dos veces** (`servers.web` y
  `accessories.db.host`): reemplazar las dos por la nueva.
- `host: gias.morci-the-dog.lat` pasa a:
  ```yaml
  hosts:
    - gias.com.ar
    - www.gias.com.ar
  ```

**Kamal construye desde el último commit, no desde los archivos sueltos.** Lo
que no esté commiteado no llega al servidor:

```sh
git commit -am "Deploy en gias.com.ar"
```

Desde acá, `bin/kamal deploy` va al servidor nuevo. El de prueba sigue andando
como está, pero ya no recibe cambios.

## 6. Primer deploy

```sh
bin/kamal setup
```

Tarda unos minutos la primera vez: instala Docker en el servidor, levanta
Postgres y el proxy, construye la imagen, la sube y arranca la app, que crea
las bases y corre las migraciones sola.

El certificado lo pide el proxy en la primera visita, así que el DNS tiene que
estar apuntando (paso 4) y la delegación de Nelson tiene que haber tomado
(paso 1). Al terminar, `https://gias.com.ar` abre el sitio con candado y
**vacío**.

## 7. Cargar el contenido

Los seeds leen `drive/`, que no va en la imagen, y convierten fotos con
`sips`, que existe solo en macOS. Por eso se corren **desde la Mac**, contra la
base del servidor por un túnel SSH, y las fotos van directo a R2.

En una terminal, abrir el túnel y dejarlo abierto:

```sh
ssh -i ~/.ssh/gias -N -L 5433:127.0.0.1:5432 root@IP_DEL_SERVIDOR
```

En otra:

```sh
RAILS_ENV=production DB_HOST=127.0.0.1 DB_PORT=5433 \
GIAS_DATABASE_PASSWORD=$(bin/rails credentials:fetch database_password) \
bin/rails db:seed
```

Las publicaciones `[EJEMPLO]` **no** se cargan salvo con
`SEED_PLACEHOLDERS=true`. Es una decisión del grupo: con ellas o con la sección
vacía hasta que exista la sincronización con BICYT.

**Los seeds se corren una sola vez.** Pisan lo que se haya editado en el panel
(textos y fotos del equipo, campañas, proyectos): después de que el grupo
empiece a cargar, no se vuelven a correr contra producción.

Si alguien cargó algo a mano en el panel de la prueba (una novedad, una
descripción de campaña), **no viaja con los seeds**: hay que volver a cargarlo
en el sitio nuevo.

## 8. Usuarios del panel

Uno por persona, con su mail:

```sh
bin/kamal app exec -i --reuse "bin/rails admin:usuario"
```

El mismo comando cambia la contraseña de un usuario que ya existe.

## 9. Probar antes de avisar

- `https://gias.com.ar` y `https://www.gias.com.ar` abren, con candado.
- Entrar a `/admin`, crear una novedad en borrador, arrastrar una foto adentro
  del texto y adjuntar un PDF. Si falla, la consola del navegador muestra un
  error de CORS: revisar el paso 2.
- Un link de novedad mandado por WhatsApp muestra título y resumen.

## 10. Borrar la prueba

Recién cuando el sitio definitivo ande:

1. Namecheap → el dominio de prueba → Advanced DNS: borrar el registro A `gias`.
2. Hetzner, en la cuenta de Clara: borrar el servidor de prueba (y su firewall).
3. Cloudflare, en la cuenta de Clara: vaciar y borrar el bucket de prueba, y
   borrar su API token.

## Deploys siguientes

```sh
git commit -am "..." && bin/kamal deploy
```

Comandos útiles: `bin/kamal logs`, `bin/kamal console` (consola de Rails en
producción), `bin/kamal rollback <versión>`.

Para arrancar de cero: `bin/kamal app exec "bin/rails db:reset"` no sirve
(está bloqueado en producción). Lo más simple es `bin/kamal remove`, que borra
todo del servidor incluida la base; vaciar el bucket desde Cloudflare y volver
al paso 6.

## Pendiente para más adelante

- **Copia de la base fuera de Hetzner.** Los backups de Hetzner cubren que se
  rompa el disco, no que se cierre la cuenta. Un `pg_dump` semanal a R2 sería
  la segunda copia.
- **Renovación del dominio**: vence el 5/10/2027 y la renueva Nelson en nic.ar.
