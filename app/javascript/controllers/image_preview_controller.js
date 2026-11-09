import { Controller } from "@hotwired/stimulus"

// Vista previa de las fotos elegidas en el panel, antes de guardar. Así se ve
// si se eligió la foto correcta sin tener que guardar y volver a entrar.
export default class extends Controller {
  static targets = [ "input", "preview", "current" ]

  show() {
    this.clear()

    for (const file of this.inputTarget.files) {
      if (!file.type.startsWith("image/")) continue

      const url = URL.createObjectURL(file)
      this.urls.push(url)

      const img = document.createElement("img")
      img.src = url
      img.alt = file.name
      img.className = "h-28 w-auto border border-hairline bg-paper-2 object-cover"
      this.previewTarget.append(img)
    }

    // Una foto nueva reemplaza a la actual: se atenúa para que se note.
    const replacing = this.inputTarget.files.length > 0 && !this.inputTarget.multiple
    if (this.hasCurrentTarget) this.currentTarget.classList.toggle("opacity-40", replacing)
  }

  disconnect() {
    this.clear()
  }

  clear() {
    (this.urls || []).forEach((url) => URL.revokeObjectURL(url))
    this.urls = []
    this.previewTarget.replaceChildren()
  }
}
