import { Controller } from "@hotwired/stimulus"

// Menú hamburguesa. Abajo de 1060px los 8 links del menú no entran en una
// fila, así que el panel se abre y se cierra desde acá (CLAUDE.md).
export default class extends Controller {
  static targets = ["panel", "button", "label"]
  static values = { open: Boolean }

  connect() {
    this.closeOnResize = this.closeOnResize.bind(this)
    window.addEventListener("resize", this.closeOnResize)
  }

  disconnect() {
    window.removeEventListener("resize", this.closeOnResize)
  }

  toggle() {
    this.openValue = !this.openValue
  }

  close() {
    this.openValue = false
  }

  // Cerrar con Escape, que es lo que espera quien navega con teclado.
  closeOnEscape(event) {
    if (event.key === "Escape") this.close()
  }

  // Si la ventana se agranda hasta mostrar el menú de escritorio, el panel
  // abierto queda colgado: se cierra solo.
  closeOnResize() {
    if (window.innerWidth >= 1060) this.close()
  }

  openValueChanged() {
    this.panelTarget.classList.toggle("hidden", !this.openValue)
    this.buttonTarget.setAttribute("aria-expanded", String(this.openValue))

    if (this.hasLabelTarget) {
      this.labelTarget.textContent = this.openValue
        ? this.labelTarget.dataset.closeLabel || this.labelTarget.textContent
        : this.labelTarget.dataset.openLabel || this.labelTarget.textContent
    }
  }
}
