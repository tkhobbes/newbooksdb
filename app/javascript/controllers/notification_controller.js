import { Controller } from "@hotwired/stimulus";
import Noty from "noty";

// Connects to data-controller="notification"
// enables noty for flash messages
export default class extends Controller {
  static targets = ["type", "message"];

  connect() {
    new Noty({
      text: this.messageTarget.value,
      type: this.getNotificationType(),
      theme: "relax",
      progressBar: true,
      timeout: 5000,
    }).show();
  }

  getNotificationType() {
    switch (this.typeTarget.value) {
      case "notice":
        return "info";
      case "success":
        return "success";
      case "error":
        return "error";
      case "alert":
        return "warning";
      default:
        return "info";
    }
  }
}
