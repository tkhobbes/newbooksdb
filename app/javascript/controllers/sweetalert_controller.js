import { Controller } from "@hotwired/stimulus";
import Swal from "sweetalert2";
import { getMetaValue } from "../helpers/index";

// Connects to data-controller="sweetalert"
export default class extends Controller {
  static values = {
    item: String,
    url: String,
  };

  confirm(event) {
    event.preventDefault();
    const csrfToken = getMetaValue("csrf-token");

    Swal.fire({
      titleText: "Are you sure?",
      text: `You are about to delete "${this.itemValue}"`,
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#991c00",
      cancelButtonColor: "#407bbf",
      confirmButtonText: "Yes, delete it!",
    }).then((result) => {
      if (result.isConfirmed) {
        fetch(this.urlValue, {
          method: "DELETE",
          credentials: "same-origin",
          headers: {
            "X-CSRF-Token": csrfToken,
          },
        });
      }
    });
  }
}
