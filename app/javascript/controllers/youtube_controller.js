import { Controller } from "@hotwired/stimulus"

// Carga diferida de los videos: son 6+ y con iframes normales la página
// pesaría varios megas antes de que nadie toque play (CLAUDE.md).
//
// Hasta el click se muestra solo la miniatura; el iframe se crea después,
// contra youtube-nocookie.com.
export default class extends Controller {
  static values = { embedUrl: String }

  play() {
    const iframe = document.createElement("iframe")

    iframe.src = `${this.embedUrlValue}${this.embedUrlValue.includes("?") ? "&" : "?"}autoplay=1&rel=0`
    iframe.title = this.element.dataset.videoTitle || ""
    iframe.allow = "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
    iframe.allowFullscreen = true
    iframe.className = "absolute inset-0 h-full w-full border-0"

    this.element.replaceChildren(iframe)
  }
}
