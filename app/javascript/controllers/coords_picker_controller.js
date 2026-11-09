import { Controller } from "@hotwired/stimulus"
import L from "leaflet"

// Mapa del formulario de campañas: un toque en el mapa completa latitud y
// longitud, y si se escriben a mano, el punto se mueve. Así nadie tiene que
// saber de dónde sacar las coordenadas.
export default class extends Controller {
  static targets = [ "map", "lat", "lng" ]

  // Argentina entera, para cuando todavía no hay punto.
  static center = [ -38.4, -63.6 ]
  static zoom = 4

  connect() {
    this.map = L.map(this.mapTarget)

    L.tileLayer("https://tile.openstreetmap.org/{z}/{x}/{y}.png", {
      maxZoom: 18,
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(this.map)

    this.map.on("click", (event) => this.pick(event.latlng))

    const point = this.point
    if (point) {
      this.place(point)
      this.map.setView(point, 8)
    } else {
      this.map.setView(this.constructor.center, this.constructor.zoom)
    }
  }

  disconnect() {
    this.map?.remove()
  }

  pick({ lat, lng }) {
    this.latTarget.value = lat.toFixed(6)
    this.lngTarget.value = lng.toFixed(6)
    this.place([ lat, lng ])
  }

  // Coordenadas escritas o pegadas a mano.
  sync() {
    this.tidy()
    const point = this.point

    if (point) {
      this.place(point)
      this.map.panTo(point)
    } else {
      this.marker?.remove()
      this.marker = null
    }
  }

  // Google Maps copia "-38.1333, -61.7833" de una vez: si se pega eso en un
  // campo, se reparte entre los dos. Y la coma decimal pasa a punto, que es
  // lo que entiende el servidor. El par pide punto en los dos números, para
  // no confundir "-38,13" (coma decimal) con dos coordenadas.
  tidy() {
    for (const input of [ this.latTarget, this.lngTarget ]) {
      const pair = input.value.match(/^\s*(-?\d+\.\d+)\s*,\s*(-?\d+\.\d+)\s*$/)
      if (pair) {
        this.latTarget.value = pair[1]
        this.lngTarget.value = pair[2]
        return
      }
    }

    for (const input of [ this.latTarget, this.lngTarget ]) {
      input.value = input.value.trim().replace(",", ".")
    }
  }

  place(point) {
    if (this.marker) {
      this.marker.setLatLng(point)
    } else {
      // Los colores salen de los tokens de la paleta, no se repiten acá.
      const styles = getComputedStyle(document.documentElement)
      this.marker = L.circleMarker(point, {
        radius: 9,
        color: styles.getPropertyValue("--color-structure").trim(),
        weight: 2,
        fillColor: styles.getPropertyValue("--color-ocre").trim(),
        fillOpacity: 0.9
      }).addTo(this.map)
    }
  }

  get point() {
    const lat = parseFloat(this.latTarget.value)
    const lng = parseFloat(this.lngTarget.value)

    return Number.isFinite(lat) && Number.isFinite(lng) ? [ lat, lng ] : null
  }
}
