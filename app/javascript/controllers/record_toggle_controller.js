import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    frameId: { type: String, default: "record_detail" },
    currentId: String
  }

  connect() {
    this.frame = document.getElementById(this.frameIdValue)

    // フレーム描画時に currentId を同期
    this.onFrameEvent = (e) => {
      if (e.target.id !== this.frameIdValue) return
      this.syncCurrentIdFromFrame()
      this.highlightActiveLink()
    }
    document.addEventListener("turbo:frame-render", this.onFrameEvent)
    document.addEventListener("turbo:frame-load", this.onFrameEvent)
  }

  disconnect() {
    document.removeEventListener("turbo:frame-render", this.onFrameEvent)
    document.removeEventListener("turbo:frame-load", this.onFrameEvent)
  }

  toggle(e) {
    e.preventDefault() // ← 常に自分で制御する
    const link = e.currentTarget
    const clickedId = String(link.dataset.recordId || "")
    const url = link.dataset.url

    if (!this.frame) this.frame = document.getElementById(this.frameIdValue)
    const currentId = String(this.frame?.dataset.currentId || this.currentIdValue || "")

    if (currentId && clickedId && currentId === clickedId) {
      // 同じ項目 → 閉じる
      this.clearFrame()
      this.currentIdValue = ""
      this.highlightActiveLink()
      return
    }

    // 別の項目 → フレームの src を切替（Turbo が読み込む）
    this.currentIdValue = clickedId
    this.frame.src = url
    // 先にハイライト
    this.highlightActiveLink(clickedId)
  }

  // helpers
  clearFrame() {
    if (!this.frame) return
    // 表示を消す
    this.frame.innerHTML = ""
    // 読み込みを解除
    this.frame.removeAttribute("src")
    delete this.frame.dataset.currentId
  }

  syncCurrentIdFromFrame() {
    if (!this.frame) return
    const marker = this.frame.querySelector("[data-current-id]")
    const id = marker ? String(marker.dataset.currentId || "") : ""
    if (id) {
      this.frame.dataset.currentId = id
      this.currentIdValue = id
    } else {
      delete this.frame.dataset.currentId
    }
  }

  highlightActiveLink(id = (this.frame?.dataset.currentId || this.currentIdValue || "")) {
    this.element.querySelectorAll(".meal-link.is-active")
      .forEach(el => el.classList.remove("is-active"))
    if (!id) return
    const active = this.element.querySelector(`.meal-link[data-record-id="${id}"]`)
    if (active) active.classList.add("is-active")
  }
}