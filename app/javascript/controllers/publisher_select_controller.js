import { Controller } from "@hotwired/stimulus";
import TomSelect from "tom-select";

// Connects to data-controller="publisher-select"
export default class extends Controller {
  connect() {
    const selectInput = document.getElementById("book_publisher_id");
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
        create: function (input, callback) {
          const data = { name: input };
          const token = document.querySelector(
            'meta[name="csrf-token"]'
          ).content;
          fetch("/publishers", {
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
}
