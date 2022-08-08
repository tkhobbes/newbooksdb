import { Controller } from "@hotwired/stimulus";
import Swal from "sweetalert2";
import { destroy } from "@rails/request.js";

// Connects to data-controller="sweetalert"
export default class extends Controller {
  static values = {
    item: String,
    url: String,
  };

  confirm(event) {
    event.preventDefault();

    Swal.fire({
      titleText: "Are you sure?",
      text: `You are about to delete "${this.itemValue}"`,
      icon: "warning",
      showCancelButton: true,
      confirmButtonColor: "#991c00",
      cancelButtonColor: "#407bbf",
      confirmButtonText: "Yes, delete it!",
    }).then(async (result) => {
      if (result.isConfirmed) {
        const response = await destroy(this.urlValue, {
          contentType: "text/vnd.turbo-stream.html",
          responseKind: "turbo-stream",
        });
        // if (response.ok) {
        //   console.log(response);
        // }
      }
    });
  }
}
