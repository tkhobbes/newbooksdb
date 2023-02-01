import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="tabnav"
export default class extends Controller {
  // navigate to the url given in the data-url attribute
  navigate(e) {
    e.preventDefault();
    const { url } = e.target.dataset;
    this.element.src = url;
  }
}
