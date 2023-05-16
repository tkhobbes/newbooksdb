import { Controller } from "@hotwired/stimulus";
import "chartkick/chart.js";

// Connects to data-controller="chart-select"
export default class extends Controller {
  static values = {
    id: String,
  };
  connect() {
    console.log(this.idValue);
    console.log(document.getElementById(this.idValue));
    var chart = Chartkick.charts[this.idValue];
    console.log(chart);
    let chartConfig = chart.getChartObject().config;
    chartConfig.options.onClick = function (event, native, active) {
      if (native.length > 0) {
        let xAxisIndex = native[0].index;
        let label = chart.GetChartObject().data.labels[xAxisIndex];
        console.log(label);
      }
    };
  }
}
