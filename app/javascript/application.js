// Entry point for the build script in your package.json
import { Turbo } from "@hotwired/turbo-rails";

Turbo.setProgressBarDelay(100);

import "./controllers";
// we will do this once turbo is ready
//import "./swal";
import "trix";
import "@rails/actiontext";

// chart stuff - this might move to a stimulus controller
import "chartkick/chart.js";
