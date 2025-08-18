// app/javascript/controllers/gallery_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["main"]
  static values = { urls: Array }

  connect() {
    // Recolecta las urls desde las miniaturas
    this.urls = Array.from(this.element.querySelectorAll("img[data-gallery-index-param]"))
      .map(img => img.src.replace(/(\?.*)$/, "")) // limpia variantes
  }

  show(event) {
    const i = parseInt(event.params.index, 10)
    const clicked = event.target.getAttribute("src")
    this.mainTarget.setAttribute("src", clicked)
  }
}