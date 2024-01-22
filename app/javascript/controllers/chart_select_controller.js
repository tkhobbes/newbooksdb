import { Controller } from "@hotwired/stimulus";
import "chartkick/chart.js";

// Connects to data-controller="chart-select"
export default class extends Controller {
  static targets = ["list"];
  static values = {
    id: String,
    filter: String, // variable to hold whatever was clicked
    url: String,
    criteria: String,
  };

  connect() {
    console.log(this.urlValue);
    setTimeout(() => {
      // wrapped into timeout to ensure chart is available when we call this
      var chart = Chartkick.charts[this.idValue]; // get the chart (always the same id)

      let _this = this; // hacky but needed to access the function loadChart

      let chartConfig = chart.getChartObject().config;
      chartConfig.options.onClick = function (event, native, active) {
        if (native.length > 0) {
          let xAxisIndex = native[0].index;
          let label = chart.getChartObject().data.labels[xAxisIndex];
          _this.filterValue = label;

          _this.loadChart();
        }
      };
    }, 1000);
  }

  loadChart() {
    fetch(
      this.urlValue +
        "?" +
        new URLSearchParams({
          filter: this.filterValue,
          criteria: this.criteriaValue,
        }),
      {
        method: "GET",
        headers: {
          Accept: "text/vnd.turbo-stream.html",
        },
      }
    )
      .then((response) => response.text())
      .then(async (html) => {
        Turbo.renderStreamMessage(html);
      });
  }
}
