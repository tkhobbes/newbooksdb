import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="add-sub-form"
// adds a new "create author" portion to the book create page
export default class extends Controller {
  static targets = ["subform", "selectmenu", "togglebutton"];

  toggle(event) {
    event.preventDefault();
    const submenu = this.subformTarget;
    const selectmenu = this.selectmenuTarget;
    const togglebutton = this.togglebuttonTarget;
    submenu.classList.toggle("hidden");
    selectmenu.classList.toggle("hidden");
    if (togglebutton.innerHTML === "...or add an Author") {
      togglebutton.innerHTML = "...or select an Author";
    } else {
      togglebutton.innerHTML = "...or add an Author";
    }
  }
}
