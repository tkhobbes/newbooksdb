import { Controller } from "@hotwired/stimulus";
import TomSelect from "tom-select";

// Connects to data-controller="country-select"
export default class extends Controller {
  connect() {
    const selectInput = document.getElementById("book_country");
    if (selectInput) {
      new TomSelect(selectInput, {
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
}
