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

#### Sincronización automática — evaluado, falta un dato del grupo
Evaluado en octubre de 2026: que el listado se actualice solo con un job
diario, para no cargar cada paper a mano. **Es viable.** Lo que se midió:

- **ResearchGate no sirve.** No tiene API pública y bloquea el acceso
  automático: `GET /profile/Nelson-Ferretti` devuelve 403 aun con user-agent
  de navegador (Cloudflare). Un perfil de grupo no cambia eso — el bloqueo es
  de infraestructura. Los `researchgate_url` de cada ficha quedan como están.
- **ORCID es la fuente correcta pero está vacía.** API pública, sin key, y la
  cura el propio autor (o sea, sin homónimos). Pero depende de que la curen:
  el ORCID de Ferretti (`0000-0002-2633-5867`) tiene **1 obra cargada**.
  No alcanza como fuente de datos.
- **OpenAlex es la fuente real.** Gratis, sin key. Están los 7: Ferretti 165,
  Schwerdt 33, Nicoletta 25, Signorotto 25, Panchuk 10, Millenpeier 6,
  Allegue 1. Devuelve DOI, título, revista, año y autores — todo lo que
  `Publication` ya tiene.

El ORCID se pide igual, pero como **llave de identificación**, no como fuente:
`api.openalex.org/authors/https://orcid.org/<id>` resuelve al registro
correcto de una. Hace falta porque OpenAlex parte los autores: "Nelson
Ferretti" tiene 4 fichas distintas, Nicoletta 3, Schwerdt 2.

**Trampa del dominio: el job no puede publicar directo.** En taxonomía cada
especie nueva se deposita por separado en Plazi, Zenodo, GBIF y Catalogue of
Life, así que el mismo trabajo aparece 3 o 4 veces y además hay un registro
por especie descrita. Filtrar `type:article` baja de 164 a 115 y **no
alcanza**: los más recientes de Ferretti siguen siendo depósitos de Zenodo
duplicados entre sí. Por eso el diseño es **el job propone, una persona
aprueba**: lo que llega entra como pendiente y alguien lo acepta o descarta.
Es una pantalla mucho más chica que un CRUD de publicaciones, pero no es cero
— el panel no se evita, y además hace falta igual para novedades y campañas.

Infra: ya está. `solid_queue` está en el Gemfile y `config/recurring.yml`
existe, así que el job diario son unas líneas de YAML. Sin cron ni Sidekiq.

De paso resuelve lo del PDF: OpenAlex marca el link de acceso abierto legal de
cada paper (`best_oa_location`), así que se enlaza la versión libre donde
exista en vez de alojar un PDF que la revista quizá no permite.

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
  has_one_attached :photo
  # rank: texto libre (Investigador/a, Posdoc, Becario/a doctoral, Pasante)

Publication
  title, authors, year, journal, doi, kind
  has_one_attached :pdf
  # kind: :cientifica, :divulgacion

Project         # proyectos
  title, funder, year_start, year_end, description
  has_one_attached :photo
  # funder: PICT, Rufford, PNUD, otros

Campaign        # campañas
  name, locality, province, lat, lng, date, days, description
  year_start, year_end        # el material vino fechado por año, y varias
                              # campañas abarcan un rango ("2013-2015").
                              # `date` solo donde se conoce la fecha exacta.
  coords_estimated            # true mientras la coordenada sea aproximada
  has_many_attached :photos   # 2 por campaña

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
por git** (647 MB): se consulta, no se versiona.

Se puede leer el Drive directo con el conector de Google Drive (`/mcp`), pero
lista las carpetas y los Google Docs y **no devuelve los archivos binarios**
(fotos, `.docx`, `.pdf`). Para esos hay que ir a la copia local.

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
  Drive. **4 de los 7 videos siguen sin título del grupo**: van con un nombre
  que dice "(título pendiente)" en vez de uno inventado que parezca real.
- **Campañas** — 25 campañas reales con año, localidad y provincia, cargadas
  en `db/seeds/campaigns.rb`, con sus fotos de `drive/CAMPAÑAS/` (23 de 25; las
  dos de Comodoro Rivadavia tienen la carpeta vacía en el Drive). **No llevan
  el prefijo `[EJEMPLO]`**: el dato es real, a diferencia del resto.
- **Marca** — manual, isologotipo y paleta (ver "Diseño visual").

### Sigue pendiente

- **Fotos de portada** — la carpeta PORTADA del Drive está vacía. Es la única
  sección que todavía muestra los degradés de relleno de `db/seeds/images/`
- **Proyectos** (PICT, Rufford, PNUD) — no existe la carpeta, cero datos
- **Publicaciones científicas** — no existe la carpeta, cero datos
- Descripciones de las campañas
- **Coordenadas reales de las campañas.** Las cargadas son estimadas a partir
  de la localidad: van con `coords_estimated: true` y el mapa avisa que la
  ubicación es aproximada. Al reemplazarlas por las del grupo, bajar el flag.
- Títulos de 4 de los 7 videos (3 vinieron nombrados)
- Texto de la nota de "Semana de la Ciencia", que el doc "Ideas" menciona pero
  no incluye
- Perfiles de CONICET del equipo (el modelo tiene `conicet_url`; solo mandaron
  ResearchGate)
- **ORCID iD de los 7 integrantes.** Pedido a Fiorela en octubre de 2026; es
  lo que destraba la sincronización automática de Publicaciones (ver esa
  sección). Todo investigador de CONICET tiene uno, lo piden en SIGEVA. Si no
  llegan, el plan B es confirmar a mano las fichas de OpenAlex ya encontradas
- Quién traduce al inglés lo que no sea el equipo

No inventar estos datos en producción. Usar seeds claramente marcados
como ejemplo.
