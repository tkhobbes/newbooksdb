import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="burgermenu"
// enables functionality to hide or show the sidebar
export default class extends Controller {
  static targets = ["sidebar"];

  toggle(event) {
    event.preventDefault();
    const sidebar = this.sidebarTarget;
    sidebar.classList.toggle("hidden");
  }
}
