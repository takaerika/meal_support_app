import { Application } from "@hotwired/stimulus"
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"

export const application = Application.start()
application.debug = false
window.Stimulus = application

// controllers 配下の *_controller.js を自動登録
eagerLoadControllersFrom("controllers", application)