import { Turbo } from "@hotwired/turbo-rails";
import { ApplicationController, useDebounce } from "stimulus-use";

// Connects to data-controller="quick-search"

export default class extends ApplicationController {
  static targets = ["searchinput"];
  static debounces = ["search"];

  connect() {
    useDebounce(this, { wait: 300 });
  }

  search() {
    let params = new URLSearchParams();
    params.append("query", this.searchinputTarget.value);
    fetch(`/en/quicksearch?${params}`, {
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
