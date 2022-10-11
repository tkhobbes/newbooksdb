import { Controller } from "@hotwired/stimulus";
import TomSelect from "tom-select";

// Connects to data-controller="tom-select"
export default class extends Controller {
  connect() {
    new TomSelect(this.element, {
      plugins: {
        remove_button: {
          title: "Remove this item",
        },
      },
      onItemAdd: function () {
        this.setTextboxValue("");
        this.refreshOptions();
      },
      persist: false,
    });
  }
}
