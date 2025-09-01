import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    frameId: { type: String, default: "record_detail" },
    currentId: String
  }

  connect() {
    this.frame = document.getElementById(this.frameIdValue)
    this.element.dataset.hasJs = "true"

    this.disableTurboFrameLinks()

    this.onClickCapture = (e) => {
      const a = e.target.closest("a.meal-link")
      if (!a || !this.element.contains(a)) return

      const href = a.getAttribute("href")
      const clickedId = String(a.dataset.recordId || "")
      const currentId = this.getCurrentId()

      if (currentId && clickedId && currentId === clickedId) {
        e.preventDefault()
        e.stopImmediatePropagation()
        this.clearFrame()
        this.currentIdValue = ""
        this.highlightActiveLink("")
        return
      }

      e.preventDefault()
      e.stopImmediatePropagation()
      this.currentIdValue = clickedId
      this.highlightActiveLink(clickedId)
      if (!this.frame) this.frame = document.getElementById(this.frameIdValue)
      this.frame.src = href
    }

    this.element.addEventListener("click", this.onClickCapture, { capture: true })

    this.onFrameEvent = (e) => {
      if (e.target.id !== this.frameIdValue) return
      this.syncFromFrame()
      this.highlightActiveLink(this.currentIdValue || "")
    }
    document.addEventListener("turbo:frame-load", this.onFrameEvent)
    document.addEventListener("turbo:frame-render", this.onFrameEvent)
  }

  disconnect() {
    this.element.removeEventListener("click", this.onClickCapture, { capture: true })
    document.removeEventListener("turbo:frame-load", this.onFrameEvent)
    document.removeEventListener("turbo:frame-render", this.onFrameEvent)
  }

  disableTurboFrameLinks() {
    this.element.querySelectorAll("a.meal-link[data-turbo-frame]").forEach(a => {
      a.removeAttribute("data-turbo-frame")
    })
  }

  getCurrentId() {
    const marker = this.frame?.querySelector("[data-current-id]")
    if (marker?.dataset.currentId) return String(marker.dataset.currentId)

    const src = this.frame?.getAttribute("src")
    if (src) {
      const m = src.match(/\/meal_records\/(\d+)/)
      if (m) return m[1]
    }

    if (this.currentIdValue) return String(this.currentIdValue)
    if (this.frame?.dataset.currentId) return String(this.frame.dataset.currentId)
    return ""
  }

  syncFromFrame() {
    const id = this.getCurrentId()
    if (id) {
      this.frame.dataset.currentId = id
      this.currentIdValue = id
    } else {
      delete this.frame.dataset.currentId
      this.currentIdValue = ""
    }
  }

  clearFrame() {
    if (!this.frame) return
    this.frame.innerHTML = ""
    this.frame.removeAttribute("src")
    delete this.frame.dataset.currentId
  }

  highlightActiveLink(id) {
    this.element.querySelectorAll(".meal-link.is-active").forEach(el => el.classList.remove("is-active"))
    if (!id) return
    const active = this.element.querySelector(`.meal-link[data-record-id="${id}"]`)
    if (active) active.classList.add("is-active")
  }
}