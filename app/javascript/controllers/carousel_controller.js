import { Controller } from "@hotwired/stimulus"

// Portada con dos o tres imágenes rotativas, como pidió el grupo
// (docs/pedido.md). La rotación se apaga si el sistema pide menos movimiento.
export default class extends Controller {
  static targets = ["slide", "dot"]
  static values = { interval: { type: Number, default: 7000 } }

  connect() {
    this.index = 0
    this.show(0)

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
    const index = Number(event.currentTarget.dataset.index)
    if (this.timer) clearInterval(this.timer)
    this.show(index)
  }

  show(index) {
    this.index = index

    this.slideTargets.forEach((slide, i) => {
      slide.classList.toggle("opacity-0", i !== index)
      slide.classList.toggle("opacity-100", i === index)
    })

    this.dotTargets.forEach((dot, i) => {
      dot.classList.toggle("bg-paper", i === index)
      dot.classList.toggle("bg-paper/35", i !== index)
      dot.setAttribute("aria-current", String(i === index))
    })
  }
}
