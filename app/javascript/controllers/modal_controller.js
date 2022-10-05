// this is adapted from https://www.colby.so/posts/building-modal-forms-with-turbo-streams
// which in turn is an edited-to-the-essentials version of the
// modal component created by @excid3 as part of the essential tailwind-stimulus-components package found here:
// https://github.com/excid3/tailwindcss-stimulus-components
import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["container"];

  connect() {
    this.toggleClass = "hidden";
    this.backgroundId = "modal-background";
    this.backgroundHtml = this._backgroundHTML();
  }

  disconnect() {
    this.close();
  }

  open() {
    document.body.classList.add("fixed", "overflow-hidden");
    this.containerTarget.classList.remove(this.toggleClass);
    document.body.insertAdjacentHTML("beforeend", this.backgroundHtml);
    this.background = document.querySelector(`#${this.backgroundId}`);
  }

  close() {
    if (typeof event !== "undefined") {
      event.preventDefault();
    }
    this.containerTarget.classList.add(this.toggleClass);
    if (this.background) {
      this.background.remove();
    }
  }

  _backgroundHTML() {
    return `<div id="${this.backgroundId}" class="modal-bg"></div>`;
  }
}
