import { Controller } from "@hotwired/stimulus";
import { Html5QrcodeScanner } from "html5-qrcode";

// Connects to data-controller="barcode"
export default class extends Controller {
  static targets = ["search", "isbn"];

  connect() {
    console.log("search target", this.searchTarget);
    console.log("isbn target", this.isbnTarget);
    let html5QrcodeScanner = new Html5QrcodeScanner(
      "barcodereader",
      { fps: 2, qrbox: { width: 400, height: 150 } },
      /* verbose= */ false
    );
    html5QrcodeScanner.render(this.onScanSuccess, this.onScanFailure);
  }

  // as these functions are triggered unbound, need to be fat arrow functions
  // so that the "this" keyword is bound to the controller
  onScanSuccess = (decodedText, decodedResult) => {
    // send a post request to "show" with the ISBN as params
    this.isbnTarget.value = decodedText;
    this.searchTarget.click();
  };

  onScanFailure = (error) => {};

  disconnect() {}
}
