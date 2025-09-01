import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    frameId: { type: String, default: "record_detail" },
    currentId: String
  }

  connect() {
    this.frame = document.getElementById(this.frameIdValue)
    this.onFrameEvent = (e) => {
      if (e.target.id !== this.frameIdValue) return
      // 表示された詳細から currentId を同期
      const marker = e.target.querySelector("[data-current-id]")
      const id = marker ? String(marker.dataset.currentId || "") : ""
      if (id) {
        e.target.dataset.currentId = id
        this.currentIdValue = id
      } else {
        delete e.target.dataset.currentId
        this.currentIdValue = ""
      }
      this.highlightActiveLink()
    }
    document.addEventListener("turbo:frame-load", this.onFrameEvent)
    document.addEventListener("turbo:frame-render", this.onFrameEvent)
  }

  disconnect() {
    document.removeEventListener("turbo:frame-load", this.onFrameEvent)
    document.removeEventListener("turbo:frame-render", this.onFrameEvent)
  }

  toggle(e) {
    // JSが生きている時だけ「閉じる」を上書き
    e.preventDefault()

    const link = e.currentTarget
    const clickedId = String(link.dataset.recordId || "")
    const url = link.getAttribute("href")

    if (!this.frame) this.frame = document.getElementById(this.frameIdValue)
    const currentId = String(this.frame?.dataset.currentId || this.currentIdValue || "")

    if (currentId && clickedId && currentId === clickedId) {
      // 同じ項目 → 閉じる
      this.clearFrame()
      this.currentIdValue = ""
      this.highlightActiveLink()
      return
    }

    // 別項目 → フレーム遷移（確実に置換）
    this.currentIdValue = clickedId
    this.frame.src = url
    this.highlightActiveLink(clickedId)
  }

  clearFrame() {
    if (!this.frame) return
    this.frame.innerHTML = ""
    this.frame.removeAttribute("src")
    delete this.frame.dataset.currentId
  }

  highlightActiveLink(id = (this.frame?.dataset.currentId || this.currentIdValue || "")) {
    this.element.querySelectorAll(".meal-link.is-active")
      .forEach(el => el.classList.remove("is-active"))
    if (!id) return
    const active = this.element.querySelector(`.meal-link[data-record-id="${id}"]`)
    if (active) active.classList.add("is-active")
  }
}