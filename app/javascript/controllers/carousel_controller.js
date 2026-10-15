import { Controller } from "@hotwired/stimulus"

// Fotos que rotan en la portada, al lado del logo fijo (docs/pedido.md).
// La rotación se apaga si el sistema pide menos movimiento.
//
// Las fotos que no se ven arrancan con `hidden`, para que el navegador no las
// descargue todas de entrada. Cada vez que cambia la foto se destapa la que
// sigue (todavía transparente), así ya está bajada cuando le toca.
export default class extends Controller {
  static targets = ["slide", "dot"]
  static values = { interval: { type: Number, default: 3000 } }

  connect() {
    this.index = 0
    this.reveal(1)

    if (this.slideTargets.length < 2) return
    if (window.matchMedia("(prefers-reduced-motion: reduce)").matches) return

    this.timer = setInterval(() => this.next(), this.intervalValue)
  }

  disconnect() {
    if (this.timer) clearInterval(this.timer)
  }

  next() {
    this.show((this.index + 1) % this.slideTargets.length)
  }

  // Click en un puntito: va a esa foto y corta la rotación automática, para
  // no arrastrar a quien eligió mirar una.
  goTo(event) {
    if (this.timer) clearInterval(this.timer)

    const index = Number(event.currentTarget.dataset.index)
    const slide = this.slideTargets[index]

    // Si estaba oculta, el fundido necesita un cuadro con la foto ya en
    // pantalla (transparente) antes de cambiarle la opacidad.
    if (slide.classList.contains("hidden")) {
      this.reveal(index)
      requestAnimationFrame(() => requestAnimationFrame(() => this.show(index)))
    } else {
      this.show(index)
    }
  }

  show(index) {
    this.index = index
    this.reveal(index)
    this.reveal((index + 1) % this.slideTargets.length)

    this.slideTargets.forEach((slide, i) => {
      slide.classList.toggle("opacity-0", i !== index)
      slide.classList.toggle("opacity-100", i === index)
    })

    this.dotTargets.forEach((dot, i) => {
      dot.setAttribute("aria-current", String(i === index))
    })
  }

  reveal(index) {
    this.slideTargets[index]?.classList.remove("hidden")
  }
}
