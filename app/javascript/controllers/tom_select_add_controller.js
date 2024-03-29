import { Controller } from "@hotwired/stimulus";
import TomSelect from "tom-select";

// Connects to data-controller="tom-select-add"
export default class extends Controller {
  static values = { url: String };

  connect() {
    const url = this.urlValue;
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
      create: function (input, callback) {
        const data = { name: input };
        const token = document.querySelector('meta[name="csrf-token"]').content;
        fetch(url, {
          method: "POST",
          headers: {
            "X-CSRF-Token": token,
            "Content-Type": "application/json",
            Accept: "application/json",
          },
          body: JSON.stringify(data),
        })
          .then((response) => {
            return response.json();
          })
          .then((data) => {
            callback({ value: data.id, text: data.name });
          });
      },
    });
  }
}
