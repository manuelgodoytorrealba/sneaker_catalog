// app/javascript/controllers/images_preview_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list"]

  select(event) {
    const files = Array.from(event.target.files || [])
    this.listTarget.innerHTML = ""
    files.forEach(file => {
      const reader = new FileReader()
      reader.onload = e => {
        const img = document.createElement("img")
        img.src = e.target.result
        img.className = "h-32 w-full object-cover rounded-lg"
        const wrap = document.createElement("div")
        wrap.appendChild(img)
        this.listTarget.appendChild(wrap)
      }
      reader.readAsDataURL(file)
    })
  }
}