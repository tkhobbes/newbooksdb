import { Controller } from "@hotwired/stimulus";
import { Turbo } from "@hotwired/turbo-rails";
import { debounce } from "lodash.debounce";

// Connects to data-controller="quick-search"

export default class extends Controller {
  static targets = ["searchinput"];

  search() {
    let params = new URLSearchParams();
    params.append("query", this.searchinputTarget.value);
    fetch(`/quicksearch?${params}`, {
      method: "GET",
      headers: {
        Accept: "text/vnd.turbo-stream.html",
      },
    })
      .then((r) => r.text())
      .then(async (html) => {
        Turbo.renderStreamMessage(html);
      });
  }

  // ensure the browser's form validation messages don't show
  hideValidationMessage(event) {
    event.stopPropagation();
    event.preventDefault();
  }
}
