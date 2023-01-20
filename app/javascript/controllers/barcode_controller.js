import { Controller } from "@hotwired/stimulus";
import { Html5QrcodeScanner } from "html5-qrcode";

// Connects to data-controller="barcode"
export default class extends Controller {
  connect() {
    let html5QrcodeScanner = new Html5QrcodeScanner(
      "barcodereader",
      { fps: 10, qrbox: { width: 250, height: 250 } },
      /* verbose= */ false
    );
    html5QrcodeScanner.render(this.onScanSuccess, this.onScanFailure);
  }

  onScanSuccess(decodedText, decodedResult) {
    // handle the scanned code as you like, for example:
    console.log(`Code matched = ${decodedText}`, decodedResult);
  }

  onScanFailure(error) {
    // handle scan failure, usually better to ignore and keep scanning.
    // for example:
    console.warn(`Code scan error = ${error}`);
  }
}
