import { Controller } from "@hotwired/stimulus"

// Botón "Traer datos" del formulario de publicaciones: con el DOI pegado,
// pide a Crossref título, autores, año y revista (Admin::PublicationsController
// #crossref) y completa los campos.
//
// Solo llena los que están vacíos: lo que alguien ya escribió a mano no se
// pisa. El mensaje dice qué se completó y qué se dejó como estaba.
export default class extends Controller {
  static targets = [ "doi", "button", "status", "title", "authors", "year", "journal" ]
  static values = { url: String, publicationId: String }

  static labels = { title: "el título", authors: "los autores", year: "el año", journal: "la revista" }

  async fetch(event) {
    event.preventDefault()

    const doi = this.doiTarget.value.trim()
    if (!doi) return this.show("Pegá primero el DOI.", "error")

    const url = new URL(this.urlValue, window.location.origin)
    url.searchParams.set("doi", doi)
    if (this.publicationIdValue) url.searchParams.set("id", this.publicationIdValue)

    this.buttonTarget.disabled = true
    this.show("Buscando en Crossref…")

    try {
      const response = await fetch(url, { headers: { Accept: "application/json" } })
      const data = await response.json()

      if (response.ok) {
        this.fill(data)
      } else {
        this.show(data.error, "error", data.edit_url)
      }
    } catch {
      this.show("No se pudo consultar Crossref. Revisá la conexión y probá de nuevo.", "error")
    } finally {
      this.buttonTarget.disabled = false
    }
  }

  fill(work) {
    const filled = []
    const kept = []

    for (const [ field, label ] of Object.entries(this.constructor.labels)) {
      const value = work[field]
      const input = this[`${field}Target`]
      if (value === null || value === undefined || value === "") continue

      if (input.value.trim() === "") {
        input.value = value
        filled.push(label)
      } else if (input.value.trim() !== String(value)) {
        kept.push(label)
      }
    }

    // Se guarda el DOI limpio, sin "https://doi.org/".
    if (work.doi) this.doiTarget.value = work.doi

    if (filled.length === 0 && kept.length === 0) {
      this.show("Los datos ya coinciden con Crossref.", "ok")
    } else {
      const parts = []
      if (filled.length) parts.push(`Completado desde Crossref: ${this.sentence(filled)}.`)
      if (kept.length) parts.push(`Sin cambios en ${this.sentence(kept)}, porque ya había algo escrito.`)
      this.show(`${parts.join(" ")} Revisá antes de guardar.`, "ok")
    }
  }

  // ["el título", "el año", "la revista"] → "el título, el año y la revista"
  sentence(items) {
    return items.length > 1 ? `${items.slice(0, -1).join(", ")} y ${items.at(-1)}` : items[0]
  }

  show(message, kind = "info", link = null) {
    this.statusTarget.textContent = message
    this.statusTarget.classList.toggle("text-vino", kind === "error")
    this.statusTarget.classList.toggle("font-semibold", kind === "error")

    if (link) {
      const anchor = document.createElement("a")
      anchor.href = link
      anchor.textContent = " Ir a esa publicación"
      anchor.className = "underline"
      this.statusTarget.append(anchor)
    }
  }
}
