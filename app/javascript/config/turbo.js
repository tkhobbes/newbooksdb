import * as Turbo from "@hotwired/turbo"
import Swal from "sweetalert2"

// From Discord
// Takes the following data-elements:
// data-title-text
// data-icon
// data-show-cancel-button
// data-confirm-button-color
// data-cancel-button-color
// data-confirm-button-text
Turbo.setConfirmMethod((text, formElement) => {
  const defaults = {
    titleText: "Are you sure?",
    icon: "warning",
    showCancelButton: true,
    confirmButtonColor: "#991c00",
    cancelButtonColor: "#407bbf",
    confirmButtonText: "Yes, delete it!",
  };

  let {
    titleText,
    icon,
    showCancelButton,
    confirmButtonColor,
    cancelButtonColor,
    confirmButtonText,
  } = Object.assign({}, defaults, formElement.dataset);
  showCancelButton = showCancelButton.toString() === "true";

  const swal = Swal.fire({
    titleText,
    text,
    icon,
    showCancelButton,
    confirmButtonColor,
    cancelButtonColor,
    confirmButtonText,
  });

  return new Promise((resolve, reject) => {
    swal.then((result) => resolve(result.isConfirmed)).catch(() => reject());
  });
});
