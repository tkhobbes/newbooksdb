import { Controller } from "@hotwired/stimulus";
import TomSelect from "tom-select";

// Connects to data-controller="book-format-select"
export default class extends Controller {
  connect() {
    const selectInput = document.getElementById("book_book_format_id");
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
          fetch("/book_formats", {
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
