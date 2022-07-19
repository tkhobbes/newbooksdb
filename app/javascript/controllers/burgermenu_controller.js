import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="burgermenu"
export default class extends Controller {
  static targets = ["sidebar"];

  toggle(event) {
    event.preventDefault();
    const sidebar = this.sidebarTarget;
    sidebar.classList.toggle("hidden");
  }
}
