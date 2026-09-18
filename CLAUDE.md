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

**CSS**: sin definir todavía. La preferencia actual es Tailwind
(`tailwindcss-rails`, compatible con Propshaft) por sobre CSS a mano.
No está instalado: se decide cuando se arranquen las vistas.

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

Si se implementa: al pegar un DOI se pueden traer título, autores y año
desde la API de Crossref para no tipear a mano.

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
  has_many_attached :photos   # 2 por campaña

OutreachItem    # divulgación
  title, kind, url, youtube_id, position
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
`docs/mockup.html` es un borrador, no una referencia aprobada. Sirve para
paleta y tipografías; el layout puede cambiar.

Ojo: el borrador está hecho desktop-first (todas sus media queries son
`max-width`), al revés de lo que pide la sección de CSS más abajo.

- Paleta: papel `#F2F2EE`, tinta `#17191A`, acento petróleo `#1F4E4A`
- Tipografías: Newsreader (títulos), Karla (cuerpo), Azeret Mono (etiquetas)
- Nombres científicos siempre en serif itálica — hacer un helper
- Menú fijo arriba con resaltado fuerte en hover (fondo sólido, no subrayado)
- Logo fijo a la izquierda

---

## Deploy

Kamal sobre Hetzner. Postgres en la misma máquina. Imágenes en Cloudflare R2
(10 GB gratis, sin cargo de egress) vía el adapter de S3.

Si más adelante se implementa el envío de mails: proveedor transaccional
(Postmark, Resend o SES), nunca desde la IP del VPS. Con SPF, DKIM y DMARC
configurados en el dominio.

---

## Pendiente del cliente

- Nombres, rangos y descripciones del equipo
- Datos de publicaciones, proyectos y campañas
- Títulos de los videos de divulgación
- Logo del grupo (el del mockup es un placeholder)
- Fotos de portada, equipo, campañas y proyectos
- Coordenadas de las campañas para el mapa
- Quién traduce el contenido al inglés

No inventar estos datos en producción. Usar seeds claramente marcados
como ejemplo.
