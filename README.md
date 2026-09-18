# GIAS

Sitio del Grupo de Aracnología (CERZOS — CONICET/UNS, Bahía Blanca).

## Arrancar el proyecto

Este repo todavía no tiene la app Rails. Para generarla, parado en `/gias`:

```bash
rails new . --database=postgresql --skip-test
```

`--skip-test` porque vas a usar RSpec. Si preferís Minitest, sacá el flag.

Después:

```bash
bin/rails db:create
bin/rails action_text:install
bin/rails active_storage:install
bin/rails db:migrate
bin/dev
```

## Estructura

```
CLAUDE.md          contexto y decisiones del proyecto — leer primero
docs/mockup.html   referencia visual aprobada por el cliente
docs/pedido.md     el pedido original del grupo, textual
```

## Notas

- El contenido lo carga gente no técnica. El panel de admin tiene que ser claro.
- CSS mobile-first. La mayoría entra desde el celular.
- La suscripción por email quedó para una etapa 2.
