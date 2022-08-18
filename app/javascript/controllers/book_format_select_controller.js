import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="book-format-select"
export default class extends Controller {
  connect() {
    console.log("wave");
  }
}
