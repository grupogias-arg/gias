import { Controller } from "@hotwired/stimulus"

// Limpia el HTML que se pega en Trix desde Word (CLAUDE.md: el grupo va a
// pegar desde Word).
//
// Trix ya descarta los estilos, las clases y las etiquetas que no conoce, y
// conserva negritas, cursivas y links. Pero de Word deja pasar dos cosas que
// ensucian la nota:
//   - las viñetas falsas: Word no manda una lista, manda párrafos con un "·"
//     adentro de un <span style="mso-list:Ignore">, que quedan como texto;
//   - los párrafos vacíos (<p>&nbsp;</p>) que Word pone entre cada párrafo.
//
// Uso: data-controller="word-paste" data-action="trix-before-paste->word-paste#clean"
export default class extends Controller {
  clean(event) {
    const paste = event.paste
    if (paste?.type !== "text/html" || !paste.html) return

    const doc = new DOMParser().parseFromString(paste.html, "text/html")

    doc.body.querySelectorAll("span[style*='mso-list']").forEach(span => {
      if (/mso-list:\s*ignore/i.test(span.getAttribute("style"))) span.remove()
    })

    doc.body.querySelectorAll("p").forEach(p => {
      if (p.textContent.replace(/ /g, "").trim() === "" && !p.querySelector("img")) p.remove()
    })

    paste.html = doc.body.innerHTML
  }
}
