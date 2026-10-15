# GIAS — Sitio del Grupo de Aracnología

Sitio institucional para un grupo de investigación en arañas Mygalomorphae
(CERZOS — CONICET/UNS y Departamento de Agronomía, Bahía Blanca).

El cliente es el grupo de investigación. La interlocutora principal es Fiorela,
que no es técnica y va a ser quien cargue contenido.

---

## Stack

- Ruby on Rails 8 (última estable)
- PostgreSQL
- Hotwire (Turbo + Stimulus) — sin framework de JS
- Active Storage para imágenes y PDFs
- Action Text para el cuerpo de las novedades
- Leaflet + OpenStreetMap para los mapas
- Propshaft + importmap (defaults de Rails 8)
- Deploy: Kamal sobre VPS (Hetzner)

**No usar**: React, Vue, ActiveAdmin.

**CSS**: Tailwind (`tailwindcss-rails`, compatible con Propshaft). Ya está
instalado. Los tokens de diseño viven en `@theme` en
`app/assets/tailwind/application.css` — ver "Diseño visual".

---

## Decisiones ya tomadas (no re-litigar)

### Estructura de páginas
La home hace scroll largo con todas las secciones, pero el contenido que
crece tiene rutas propias. Nada importante vive solo dentro de un ancla.

```
/                      home con las 8 secciones
/novedades             índice
/novedades/:slug       permalink individual
/equipo
/publicaciones
/proyectos
/campanas
/divulgacion
/contacto
```

Razón: las novedades necesitan permalink para compartirse por WhatsApp y mail.

### Orden de las secciones en la home
Portada · Novedades · Equipo · Publicaciones · Proyectos · Campañas ·
Divulgación · Contacto

Ese orden lo definió el cliente. No reordenar.

### Contenido de las novedades
Action Text (Trix), NO PDFs embebidos. El PDF va como adjunto descargable
al pie de la nota, nunca como cuerpo.

Razón: el PDF no refluye en celular y no deja extraer un resumen para el índice.
Esto ya se discutió y se le comunicó al cliente.

### Publicaciones
El cliente pidió subir PDFs. Muchas revistas no permiten alojar el PDF
publicado, así que el modelo soporta las dos cosas:
- `doi` siempre (enlace a la editorial)
- `pdf` opcional, solo donde la política lo permita

Si se carga a mano: al pegar un DOI se pueden traer título, autores y año
desde la API de Crossref para no tipear a mano.

#### Sincronización automática — diseñada, sin implementar
Evaluado en octubre de 2026: que el listado se actualice solo, para no cargar
cada paper a mano. **Es viable y no depende de que el grupo mande nada.**

**Fuente: la ficha de CONICET (BICYT), enriquecida con CONICET Digital.**

- **BICYT** (`bicyt.conicet.gov.ar/fichas/p/nelson-edgardo-ferretti`) es el
  perfil público del SIGEVA. Lo cargan los propios investigadores porque
  CONICET los evalúa con eso, así que está curado: en los 107 artículos de
  Ferretti no hay ningún título repetido. Responde 200, sin Cloudflare ni
  login. Están los 7 (artículos / congresos): Ferretti 107/83 (+1 libro,
  5 capítulos), Schwerdt 32/25, Nicoletta 10/5, Panchuk 10/17, Allegue 7/6,
  Signorotto 5/3, Millenpeier 4/1.
  - No es una API documentada. La producción se pide con
    `POST /fichas/persona/cargarListado` (`id=<bicyt_id>&coleccion=produccion`)
    y vuelve como HTML. **El formato cambia según el tamaño de la lista**: con
    muchos artículos viene un JSON embebido en
    `cargarListadoBackgroundAJAX(...)`; con pocos, tarjetas HTML con links
    `/fichas/produccion/<id>`. El parser tiene que soportar las dos formas.
  - Trae título, autores, año, mes, editorial, ISSN, páginas y
    `handle_repositorio`. **No trae DOI, y en el listado tampoco la revista**:
    el nombre de la revista (y el resumen) está en `/fichas/produccion/<id>`.
  - El `bicyt_id` de cada integrante es la llave, así que no hay homónimos.
    Los de los 6 dirigidos salen de la ficha de Ferretti: Ferretti 21413,
    Schwerdt 52301, Nicoletta 436652, Signorotto 478347, Panchuk 428349,
    Millenpeier 477881, Allegue 456846. La ficha
    `bicyt.conicet.gov.ar/fichas/persona/<bicyt_id>` es además el perfil de
    CONICET, o sea el `conicet_url` que faltaba.
- **CONICET Digital** (`ri.conicet.gov.ar/handle/<handle>`): 92 de los 107
  artículos de Ferretti tienen handle. La página del ítem trae `citation_doi`
  (73 de 92), la licencia y si es `info:eu-repo/semantics/openAccess` (68 de 92).
  **El PDF se enlaza solo si el registro dice openAccess**: los otros 24 también
  muestran un link a PDF, pero sin esa marca (probablemente restringidos). El
  PDF lo aloja CONICET, así que no hace falta alojar nada propio. Su
  `robots.txt` solo bloquea una lista de bots de IA, no a `*`. Tiene OAI-PMH
  (`/oai/request`), pero **va atrasado**: un ítem cargado en mayo de 2026
  todavía no estaba ahí. Usar la página del ítem.
- **Crossref** completa el DOI de los que no tienen handle (15) o lo tienen sin
  DOI (19). No pide key. Lo que no aparezca se completa a mano al aprobar.

**Descartados:**
- **ResearchGate**: sin API pública, `GET /profile/Nelson-Ferretti` devuelve
  403 aun con user-agent de navegador (Cloudflare). Los `researchgate_url`
  quedan como links.
- **ORCID**: está casi vacío; el de Ferretti (`0000-0002-2633-5867`) tiene 1 obra.
- **OpenAlex**: parte los autores ("Nelson Ferretti" tiene 4 fichas) y duplica
  cada trabajo taxonómico con los depósitos de Plazi, Zenodo y GBIF (164
  registros de Ferretti, 115 con `type:article`, igual con duplicados).
  Además **ya no es "sin key"**: sin API key el cupo diario se comparte por IP
  y en octubre de 2026 devolvió 429. Si se usa para algo, sacar una key
  gratuita.

**Diseño del job:**
1. `SyncPublicationsJob`, **semanal** en `config/recurring.yml` (lunes 4 AM;
   el grupo publica poco, unos 10 artículos por año). Encola un job por
   integrante. Hay un botón "Buscar publicaciones nuevas ahora" en `/admin`
   que encola el mismo job.
2. `FetchMemberWorksJob(member)` compara contra lo conocido por ID de
   producción de BICYT. Lo nuevo entra como `PublicationCandidate` pendiente.
3. `EnrichCandidateJob(candidate)`: CONICET Digital, Crossref y la revista
   desde la ficha del trabajo. Si falla, el candidato queda pendiente sin DOI.
4. En `/admin` alguien aprueba (se crea la `Publication`) o descarta. Lo
   descartado se recuerda para no volver a proponerlo.

**El job propone, una persona aprueba.** El sitio público lee solo de la base,
nunca de BICYT en vivo.

**Si algo falla:**
- Errores de red: `retry_on` con espera. Como el job compara contra lo
  conocido, la corrida siguiente encuentra lo que se perdió.
- **Solo agrega, nunca borra.** Si el parser devuelve 0 para alguien que tenía
  trabajos (CONICET cambió el HTML), es un error, no un dato.
- No hay mails (etapa 2): cada corrida queda en `sync_runs`, y el panel muestra
  la última corrida exitosa y avisa si pasaron más de 8 días sin una.

Columnas nuevas: `Member.bicyt_id`, `Publication.bicyt_id` y
`Publication.source`. Tablas nuevas: `publication_candidates` y `sync_runs`.
`solid_queue` y `config/recurring.yml` ya están: sin cron ni Sidekiq.

### Fuera de alcance en esta etapa
**Suscripción por email con envío automático.** El cliente lo pidió, se
decidió postergarlo a una etapa 2. No implementarlo salvo pedido explícito.
En su lugar: feed RSS en `/novedades.rss`.

### Idiomas
Bilingüe ES/EN, con español por defecto. Campos de traducción opcionales
con fallback al español: si no cargaron la versión en inglés, se muestra
la española. No dejar páginas vacías.

---

## Modelo de datos

```ruby
Post            # novedades
  title, slug, kind (enum), published_at, excerpt
  has_rich_text :body
  has_many_attached :documents
  # kind: :divulgacion, :libro, :premio, :equipo, :publicaciones, :curso

Member          # equipo
  name, rank, focus, email, conicet_url, researchgate_url, position, sede
  bicyt_id                    # llave para la sincronización de publicaciones
  has_one_attached :photo
  # rank: texto libre (Investigador/a, Posdoc, Becario/a doctoral, Pasante)

Publication
  title, authors, year, journal, doi, kind
  has_one_attached :pdf
  # kind: :cientifica, :divulgacion

Project         # proyectos
  title, funder, year_start, year_end, description
  has_one_attached :photo
  # funder: pict, sgcyt_uns, aas, rufford, bts, isa, ngc, otros
  #   (los del Drive; PNUD lo mencionaba el pedido, pero ningún proyecto lo tiene)

Campaign        # campañas
  name, locality, province, lat, lng, date, days, description
  year_start, year_end        # el material vino fechado por año, y varias
                              # campañas abarcan un rango ("2013-2015").
                              # `date` solo donde se conoce la fecha exacta.
  coords_estimated            # true mientras la coordenada sea aproximada
  has_many_attached :photos   # 3 por campaña (Campaign::EXPECTED_PHOTOS)

CoverPhoto      # portada: fotos que rotan al lado del logo fijo
  position
  has_one_attached :image     # fotos de estudio, araña sobre fondo blanco

OutreachItem    # divulgación
  title, kind, url, youtube_id, position
  authors                     # los artículos de los boletines vienen firmados
  # kind: :video, :playlist, :articulo, :guia, :actividad
```

Todos los modelos con contenido textual necesitan su par en inglés
(`title_en`, `description_en`, etc.) con fallback.

---

## Panel de administración

Fiorela y el grupo cargan contenido. No usar ActiveAdmin (se rompe en cada
major de Rails). CRUD propio en `/admin` con autenticación simple, o
Administrate si se prefiere.

Prioridad: que sea claro para alguien no técnico. Etiquetas en español,
campos con ayuda, previsualización de imágenes.

Aviso: van a pegar texto desde Word. Sanitizar el HTML pegado en Trix.

### Estado (octubre de 2026)
Hecho: login, **Novedades** y **Portada** (`/admin/portada`: subir varias
fotos de una vez, flechas para reordenar, sacar). Faltan los demás modelos,
que siguen el mismo patrón (`Admin::BaseController`, helper `admin_field`, clases `admin-*`).

- **Login**: el generador de autenticación de Rails 8, acotado a `/admin`
  (`Admin::BaseController` incluye `Authentication`; el sitio público no pide
  login). Sin registro público ni "olvidé mi contraseña", porque no hay mails
  hasta la etapa 2. Los usuarios se crean y las contraseñas se cambian con
  `bin/rails admin:usuario` (en producción:
  `bin/kamal app exec -i --reuse "bin/rails admin:usuario"`).
- **Rutas por id, no por slug**: `Post#to_param` es el slug y en el panel se
  puede editar. Usar `edit_admin_post_path(post.id)`.
- **Estados**: sin `published_at` es borrador, con fecha futura queda
  programada. Los botones del formulario son "Publicar" y "Guardar como
  borrador". **El slug solo se edita mientras es borrador**: una nota
  publicada pudo haberse compartido por WhatsApp.
- **Vista previa**: `admin/novedades/:id` muestra la nota con el layout
  público, también en borrador.
- **Pegado desde Word** (`word_paste_controller.js`, en `trix-before-paste`):
  Trix 2.1 ya descarta estilos y clases, y resuelve solo el `<b>` envolvente
  de Google Docs (probado). Lo que no resuelve, y el controller sí, son las
  viñetas falsas de Word (`mso-list:Ignore`) y los párrafos vacíos.
- **CSS de Trix**: `actiontext.css` no está en ninguna `@layer`, así que le
  gana a todo `@layer components`. Las reglas del editor del panel van fuera
  de capa, al final de `application.css`.
- **Pendiente para producción: CORS en el bucket de R2.** Los PDF y las fotos
  del cuerpo se suben directo del navegador a R2 (direct upload). Sin una
  regla CORS que permita `PUT` desde `https://gias.com.ar`, la subida falla en
  producción aunque en local ande.

---

## CSS y frontend

**Mobile-first.** Media queries con `min-width`, no `max-width`. La mayor
parte del tráfico va a llegar de links compartidos por WhatsApp, o sea
desde el teléfono.

- Menú hamburguesa funcional abajo de 1060px (Stimulus controller)
- `srcset` en todas las imágenes. Las fotos de campo vienen de cámara a 6 MB;
  el celular no debe bajar eso. Variantes de Active Storage.
- Mapa sticky de campañas: solo en escritorio. En mobile, colapsado u oculto.
- Videos de YouTube con carga diferida (lite embed o `youtube-nocookie.com`).
  Son 6+ videos; iframes normales harían pesar la página varios megas.

### Diseño visual
`docs/mockup.html` es un borrador, no una referencia aprobada. Sirve para el
layout tentativo, **no para la paleta**: proponía un acento petróleo `#1F4E4A`
que no es un color de la marca.

Ojo: el borrador está hecho desktop-first (todas sus media queries son
`max-width`), al revés de lo que pide la sección de CSS más abajo.

#### Paleta — del Manual de marca GIAS (2021)
El manual llegó con el material del grupo: `drive/GIAS/Manual de marca GIAS.pdf`.
La paleta de su página 5 manda, y la página 9 prohíbe explícitamente modificar
los colores y re-tipografiar el nombre de la marca.

| Token | Hex | Rol | Contraste s/ papel |
|---|---|---|---|
| `pizarra` | `#495155` | cuerpo de la araña y "GIAS" del isologotipo | 7.22:1 |
| `ocre` | `#BF8862` | abdomen y bajada del isologotipo | 2.71:1 |
| `terracota` | `#9E584E` | paleta extendida | 4.73:1 |
| `vino` | `#793B51` | paleta extendida | 7.32:1 |

El ocre **no alcanza para texto chico**. Por eso los roles semánticos son:
`accent` = terracota (links y hovers), `structure` = pizarra (menú activo,
hover sólido), y el ocre queda para rellenos y titulares grandes.

Neutros derivados: papel `#F2F2EE`, papel-2 `#E9E6E0`, tinta `#23282B`,
tinta-suave `#5E6468`, hairline `#D5D2CA`.

Todo vive en `@theme` en `app/assets/tailwind/application.css`. No hardcodear
hex en vistas ni en controllers de Stimulus.

#### Tipografías
- Newsreader (títulos), Karla (cuerpo), Azeret Mono (etiquetas)
- Nombres científicos siempre en serif itálica. Dos helpers:
  `sci` para escribirlos a mano en una vista, y `sci_text` para texto que viene
  cargado desde el panel (bios del equipo, descripciones). `sci_text` itálica
  los taxones de la lista `ApplicationHelper::TAXA`; si el grupo empieza con
  otro género, se agrega ahí. La detección es por lista explícita a propósito:
  por forma daría falsos positivos con apellidos y topónimos

El manual especifica DIN Bold y Raleway Medium, pero **solo para construir el
isologotipo**, no para el cuerpo del sitio. Newsreader hace falta igual para
los nombres científicos.

#### Logo
`app/assets/images/logo.png` (marca completa) y `logo-sintesis.png` (la araña
sola). Son la marca aprobada y **sí se versionan**: 71 KB entre los dos.

El manual prohíbe re-tipografiar el nombre, así que al lado del logo no va
texto. En celular la barra muestra solo la síntesis de imagen, porque la bajada
quedaría ilegible a esa altura (uso indebido 5); el manual lo habilita (p.10)
a condición de que la marca completa aparezca visible en la página, y está en
el pie.

- Menú fijo arriba con resaltado fuerte en hover (fondo sólido, no subrayado)
- Logo fijo a la izquierda

#### Links en pestaña nueva
Pedido del grupo: **todos** los links de contenido abren en pestaña nueva, no
solo los externos. Se usa el helper `new_tab` (`target` + `rel="noopener"`),
que es greppable; no escribir los atributos a mano.

Quedan afuera a propósito, porque ahí la pestaña nueva estorba: la barra de
navegación, el logo, el menú de celular, el switch de idioma, el "saltar al
contenido", el "volver a novedades" (es navegación hacia atrás) y los
`mailto:`, que en varios navegadores dejan una pestaña vacía colgada.

Ojo con el cuerpo de las novedades: **Action Text descarta el atributo
`target`** de los `<a>` al sanitizar, así que un link guardado desde Trix lo
pierde en la base. Por eso el `target` se agrega al renderizar, en el helper
`rich_body`, que de paso itálica los taxones.

---

## Deploy

Kamal sobre Hetzner. Postgres en la misma máquina. Imágenes en Cloudflare R2
(10 GB gratis, sin cargo de egress) vía el adapter de S3.

Paso a paso en `docs/deploy.md`. Dos cosas que no son obvias: Kamal construye
desde el último **commit** (lo no commiteado no llega), y los seeds se corren
desde la Mac contra producción por túnel SSH, porque leen `drive/` (excluido
de la imagen) y convierten fotos con `sips`, que es solo de macOS.

**Dominio:** `gias.com.ar` está registrado en NIC Argentina a nombre de
**Nelson Ferretti** (alta 5/10/2026, vence 5/10/2027). Las delegaciones DNS
las cambia él con su clave fiscal, no Fiorela.

Si más adelante se implementa el envío de mails: proveedor transaccional
(Postmark, Resend o SES), nunca desde la IP del VPS. Con SPF, DKIM y DMARC
configurados en el dominio.

---

## Material del cliente

El grupo dejó su contenido en el Drive de `grupogias.arg@gmail.com`, carpeta
"Pagina Web / Contenido para web". Hay una copia local en `drive/`, **ignorada
por git** (~680 MB): se consulta, no se versiona.

Se puede leer el Drive directo con el conector de Google Drive (`/mcp`), pero
lista las carpetas y los Google Docs y **no devuelve los archivos binarios**
(fotos, `.docx`, `.pdf`). Para esos hay que ir a la copia local.

Actualizado el 15/10/2026 con un zip nuevo del Drive. La copia anterior quedó
en la Papelera (`drive-anterior-2026-10-15`). Para la próxima actualización:
bajar el zip a otra carpeta, comparar contra `drive/` y recién después
reemplazar, porque el grupo no avisa qué cambió.

### Ya llegó

- **Equipo** — 7 integrantes con bio, rango, sede, email, ResearchGate y foto,
  **ya traducidos ES/EN** por el grupo. Cargados en `db/seeds/members.rb`,
  con las fotos reales de `drive/EQUIPO/`. **Sin prefijo `[EJEMPLO]`.**
- **Novedades** — 3 notas con texto final, en `db/seeds/posts.rb`: libro
  *Tarántulas de Argentina*, pasantía en UNESP, premio de divulgación CERZOS
  2026. Las fotos van **embebidas en el cuerpo de Action Text**, no adjuntas:
  `Post` no tiene imagen de portada y `documents` es para los PDF del pie.
  `published_at` es aproximado, deducido del EXIF de las fotos — el grupo no
  pasó fechas de publicación.
- **Divulgación** — en `db/seeds/outreach.rb`: 7 artículos de los boletines del
  CERZOS con autores y link al PDF, la guía de Coronel Suárez, y los 7 videos.
  Los IDs de YouTube ya estaban en `docs/pedido.md` y coinciden con los del
  Drive. Los títulos son los de YouTube (oEmbed). El orden es el de
  `videos.docx`; ahí algunos links están como hipervínculo detrás del título,
  así que extraer el texto del Word no alcanza para verlos.
- **Campañas** — 25 campañas reales con año, localidad y provincia, cargadas
  en `db/seeds/campaigns.rb`, con sus fotos de `drive/CAMPAÑAS/`: las 3
  primeras de cada carpeta (Martín García y Lihué Calel 2016 tienen 2). **No llevan
  el prefijo `[EJEMPLO]`**: el dato es real, a diferencia del resto.
- **Proyectos** — 18 proyectos con título, año, descripción y foto, en
  `db/seeds/projects.rb` (de `drive/PROYECTOS/`). El documento da un solo año
  por proyecto: `year_end = year_start` y la vista muestra el año solo. Los
  títulos de subsidios internacionales vinieron en inglés y van tal cual.
- **Contacto** — mail, teléfono e Instagram en `config/site.yml`.
- **Marca** — manual, isologotipo y paleta (ver "Diseño visual").
- **Portada** — 16 fotos candidatas en `drive/PORTADA/` (arañas de estudio
  sobre fondo blanco) y `ejemplo_portada.png`, el boceto del grupo: logo fijo
  a la izquierda y la foto rotando al lado. Cargadas como `CoverPhoto` en
  `db/seeds/cover_photos.rb`, todas y en orden numérico; el grupo elige
  desde el panel cuáles quedan. La vista las funde con el papel con
  `mix-blend-multiply` (por eso conviene fondo blanco, no fotos de campo).

### Sigue pendiente

- **Qué fotos de portada quedan** — mandaron 16 candidatas y el pedido original
  hablaba de "dos o tres". Hoy rotan las 16; que Fiorela saque las que sobren.
- **Publicaciones científicas** — `drive/PUBLICACIONES/` trae solo el CV
  SIGEVA de Ferretti. Se decidió no cargarlo a mano: las reales llegan con la
  sincronización de BICYT. Mientras tanto quedan las de `[EJEMPLO]`.
- Descripciones de las campañas
- **Coordenadas reales de las campañas.** Las cargadas son estimadas a partir
  de la localidad: van con `coords_estimated: true` y el mapa avisa que la
  ubicación es aproximada. Al reemplazarlas por las del grupo, bajar el flag.
- Texto de la nota de "Semana de la Ciencia" (las fotos y el video ya están en
  `drive/DIVULGACION/`), que el doc "Ideas" menciona pero
  no incluye
- Perfiles de CONICET del equipo: ya no hace falta pedirlos, son las fichas de
  BICYT (`/fichas/persona/<bicyt_id>`, ver "Sincronización automática").
  Falta cargarlos en `conicet_url`
- **ORCID iD de los 7 integrantes.** Pedido a Fiorela en octubre de 2026. Ya no
  bloquea la sincronización de Publicaciones (la llave es el `bicyt_id`); sirve
  solo como dato de la ficha
- Quién traduce al inglés lo que no sea el equipo

No inventar estos datos en producción. Usar seeds claramente marcados
como ejemplo.
