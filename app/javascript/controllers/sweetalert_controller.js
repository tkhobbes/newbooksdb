import { Controller } from "@hotwired/stimulus";
import Swal from "sweetalert2";
import { destroy } from "@rails/request.js";
import * as Turbo from "@hotwired/turbo-rails";

// Connects to data-controller="sweetalert"
export default class extends Controller {
  static values = {
    item: String,
    url: String,
    answer: String,
    redirect: String,
  };

  confirm(event) {
    console.log(this.urlValue);
    console.log(this.answerValue);
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
          contentType:
            this.answerValue == "turbo"
              ? "text/vnd.turbo-stream.html"
              : "text/html",
          responseKind: this.answerValue == "turbo" ? "turbo-stream" : "html",
        });
        if (response.ok && this.answerValue == "html") {
          Turbo.visit(this.redirectValue);
        }
      }
    });
  }
}
