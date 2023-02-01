import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="another-sub-form"
export default class extends Controller {
  // reads the author subform and adds it again
  addform(e) {
    e.preventDefault();
    const lastID = document.querySelector("#authorform").lastElementChild.id;
    const newID = parseInt(lastID, 10) + 1;
    const newFieldset = document
      .querySelector("#authorform")
      .lastElementChild.outerHTML.replace(/0/g, newID);
    document
      .querySelector("#authorform")
      .insertAdjacentHTML("beforeend", newFieldset);
    // });
  }
}
