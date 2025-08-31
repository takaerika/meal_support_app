import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { frameId: { type: String, default: "record_detail" }, currentId: String }

  connect() {
    this.updateFrame()
    this.onFrameLoad = (e) => {
      if (e.target.id !== this.frameIdValue) return
      this.frame = e.target

      // 追加：中のマーカーから currentId を読み取り、フレームにセット
      const marker = this.frame.querySelector("[data-current-id]")
      const id = marker ? marker.dataset.currentId : ""
      if (id) {
        this.frame.dataset.currentId = id
        this.currentIdValue = id
      } else {
        delete this.frame.dataset.currentId
        this.currentIdValue = ""
      }

      this.highlightActiveLink()
      this.frame.scrollIntoView({ behavior: "smooth", block: "start" })
    }
    document.addEventListener("turbo:frame-load", this.onFrameLoad)
  }

  disconnect() { document.removeEventListener("turbo:frame-load", this.onFrameLoad) }

  toggle(e) {
    const link = e.currentTarget
    const clickedId = String(link.dataset.recordId || "")
    this.updateFrame()

    const currentId = String(this.frame?.dataset.currentId || this.currentIdValue || "")
    if (currentId && currentId === clickedId) {
      // 同じ項目 → 閉じる（遷移を止める）
      e.preventDefault()
      this.clearFrame()
      this.clearActiveLinks()
      this.currentIdValue = ""
      return
    }

    // 別の項目 → Turbo に任せて読み込み
    this.clearActiveLinks()
    link.classList.add("is-active")
  }

  // helpers
  updateFrame() { this.frame = document.getElementById(this.frameIdValue) }
  clearFrame() {
    if (!this.frame) return
    this.frame.innerHTML = ""
    delete this.frame.dataset.currentId
  }
  clearActiveLinks() {
    this.element.querySelectorAll(".meal-link.is-active").forEach(el => el.classList.remove("is-active"))
  }
  highlightActiveLink() {
    const currentId = this.frame?.dataset.currentId || this.currentIdValue
    this.clearActiveLinks()
    if (!currentId) return
    const active = this.element.querySelector(`.meal-link[data-record-id="${currentId}"]`)
    if (active) active.classList.add("is-active")
  }
}