import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="switch-locale"
export default class extends Controller {
  static values = {
    path: String,
  };

  updatelocale() {
    fetch(this.pathValue, {
      method: "PUT",
    });
  }
}
