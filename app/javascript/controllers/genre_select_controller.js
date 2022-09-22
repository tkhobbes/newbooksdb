import { Controller } from "@hotwired/stimulus";
import TomSelect from "tom-select";

// Connects to data-controller="genre-select"
// hooks tom-select to the genre-select element
export default class extends Controller {
  connect() {
    const selectInput = document.getElementById("book_genre_ids");
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
          fetch("/genres", {
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
