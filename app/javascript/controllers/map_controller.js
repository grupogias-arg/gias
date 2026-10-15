import { Controller } from "@hotwired/stimulus"
import L from "leaflet"

// Mapa de campañas con Leaflet + OpenStreetMap.
//
// El pedido del grupo era que el mapa "te desplace a la campaña" sin salir de
// la página: cada punto está enlazado a la tarjeta de su campaña más abajo.
//
// Solo se instancia en escritorio: en celular el mapa va colapsado u oculto
// (CLAUDE.md), así que si el contenedor no se está mostrando, no hace nada.
export default class extends Controller {
  static values = {
    points: Array,
    minWidth: { type: Number, default: 1024 }
  }

  connect() {
    if (window.innerWidth < this.minWidthValue) return
    if (this.pointsValue.length === 0) return

    this.map = L.map(this.element, { scrollWheelZoom: false })

    L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
      maxZoom: 18,
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(this.map)

    const markers = this.pointsValue.map((point) => {
      // Círculo en vez del pin por defecto: así el mapa no depende de las
      // imágenes de Leaflet y sigue la paleta del Manual de marca GIAS
      // (pizarra de borde, ocre de relleno).
      const marker = L.circleMarker([point.lat, point.lng], {
        radius: 8,
        color: "#495155",
        weight: 2,
        fillColor: "#BF8862",
        fillOpacity: 0.85
      }).addTo(this.map)

      marker.bindPopup(`<strong>${point.name}</strong><br>${point.locality || ""}`)
      marker.on("click", () => this.scrollTo(point.anchor))

      return marker
    })

    this.map.fitBounds(L.featureGroup(markers).getBounds(), { padding: [ 32, 32 ] })
  }

  disconnect() {
    if (this.map) this.map.remove()
  }

  scrollTo(anchor) {
    const target = anchor && document.getElementById(anchor)
    if (target) target.scrollIntoView({ behavior: "smooth", block: "start" })
  }
}
